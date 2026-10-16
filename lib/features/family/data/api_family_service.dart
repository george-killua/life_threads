import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../domain/family_models.dart';
import 'family_api_client.dart';
import 'family_crypto.dart';
import 'family_invite_link.dart';
import 'family_local_cache.dart';
import 'family_photo_processor.dart';
import 'family_platform.dart';
import 'family_secure_store.dart';
import 'family_service.dart';

/// [FamilyService] against the LifeThreads family API.
///
/// - Everything that leaves the device is encrypted with the family key
///   (AES-256-GCM, see [FamilyCipher]); the server sees ids, sizes and
///   timestamps only.
/// - Reads come from [FamilyLocalCache] and work offline; [sync] pulls the
///   server's change feed incrementally. Writes need a connection and fail
///   with `network_error` when offline (there is no offline write queue).
class ApiFamilyService implements FamilyService {
  ApiFamilyService({
    required this.api,
    required this.secrets,
    required this.cache,
    required this.identity,
    required this.purchases,
    this.photos = const DefaultFamilyPhotoProcessor(),
    this.cipher = const FamilyCipher(),
    String Function()? newId,
    DateTime Function()? now,
  }) : _newId = newId ?? const Uuid().v4,
       _now = now ?? DateTime.now {
    api.tokenProvider = secrets.sessionToken;
    api.onUnauthorized = _sessionExpired;
  }

  final FamilyApiClient api;
  final FamilySecrets secrets;
  final FamilyLocalCache cache;
  final FamilyIdentityProvider identity;
  final FamilyPurchaseSource purchases;
  final FamilyPhotoProcessor photos;
  final FamilyCipher cipher;
  final String Function() _newId;
  final DateTime Function() _now;

  static const _maxNameBytes = 700;
  static const _changesPageSize = 200;
  static const _downloadConcurrency = 4;

  final _account = _Value<FamilyAccount?>(null);
  final _families = _Value<List<Family>>(const []);
  final Map<String, _Value<List<FamilyMemory>>> _memoryValues = {};
  final Map<String, _Value<FamilySyncStatus>> _statusValues = {};
  final Map<String, int> _memoryWatchers = {};
  final Map<String, Future<void>> _syncs = {};
  final Set<String> _syncAgain = {};
  final Map<String, Future<void>> _locks = {};
  final Map<String, Future<File>> _photoLoads = {};
  Future<void>? _accountLoad;
  Future<void>? _familiesLoad;
  bool _disposed = false;

  /// Bumped when local content is wiped, so background work that started
  /// before (a sync, a photo download) does not write it back.
  int _generation = 0;

  /// Bumped each time a family is removed from this device (left, deleted,
  /// removed from it), so work that started before doesn't write it back.
  final _forgotten = <String, int>{};

  // Account -------------------------------------------------------------------

  @override
  Stream<FamilyAccount?> watchAccount() async* {
    await (_accountLoad ??= _loadAccount());
    yield* _account.stream();
  }

  Future<void> _loadAccount() async {
    final token = await secrets.sessionToken();
    if (token == null) {
      _account.set(null);
      return;
    }
    final cached = await cache.account();
    if (cached != null) _account.set(_parseAccount(cached));
    // Refresh in the background; offline the cached account stays.
    unawaited(_refreshAccount().then((_) {}, onError: (_) {}));
  }

  Future<FamilyAccount> _refreshAccount() async {
    final json = await api.getJson('/account');
    await cache.saveAccount(json);
    final account = _parseAccount(json);
    _account.set(account);
    return account;
  }

  static FamilyAccount _parseAccount(Map<String, Object?> json) {
    final account = json['account'];
    final subscription = json['subscription'];
    if (account is! Map || account['id'] is! String) {
      throw const FamilyException(FamilyErrorCodes.invalidResponse);
    }
    return FamilyAccount(
      id: account['id'] as String,
      termsAccepted: account['termsAccepted'] == true,
      requiredTermsVersion: account['termsVersionRequired'] is String
          ? account['termsVersionRequired'] as String
          : '',
      hasActiveSubscription:
          subscription is Map && subscription['active'] == true,
    );
  }

  @override
  Future<FamilyAccount> signInWithApple() async =>
      _signIn('apple', await identity.signInWithApple());

  @override
  Future<FamilyAccount> signInWithGoogle() async =>
      _signIn('google', await identity.signInWithGoogle());

  Future<FamilyAccount> _signIn(
    String provider,
    FamilyIdentityToken token,
  ) async {
    final json = await api.sendJson(
      'POST',
      '/auth/$provider',
      json: {'idToken': token.idToken, 'nonce': ?token.nonce},
      authenticated: false,
    );
    final sessionToken = json['sessionToken'];
    final account = json['account'];
    if (sessionToken is! String ||
        account is! Map ||
        account['id'] is! String) {
      throw const FamilyException(FamilyErrorCodes.invalidResponse);
    }
    final previous = await cache.account();
    final previousId = previous?['account'] is Map
        ? (previous!['account'] as Map)['id']
        : null;
    if (previousId != null && previousId != account['id']) {
      // Another account signed in on this device: drop the old cache.
      await _clearLocalContent();
    }
    await secrets.saveSessionToken(sessionToken);
    _accountLoad = Future.value();
    final result = await _refreshAccount();
    unawaited(refreshFamilies().then((_) {}, onError: (_) {}));
    return result;
  }

  @override
  Future<void> signOut() async {
    try {
      await api.sendJson('POST', '/auth/sign-out');
    } on FamilyException {
      // The local session goes away regardless.
    }
    await _endSession();
  }

  /// Signing out keeps the family keys (Keychain/Keystore) so signing in
  /// again on this device still reads the walls; the decrypted cache goes.
  Future<void> _endSession() async {
    await secrets.clearSessionToken();
    await _clearLocalContent();
    await identity.signOut();
    _accountLoad = Future.value();
    _account.set(null);
  }

  Future<void> _sessionExpired() async {
    if (await secrets.sessionToken() == null) return;
    await _endSession();
  }

  Future<void> _clearLocalContent() async {
    _generation++;
    await Future.wait(_locks.values);
    await cache.clear();
    _families.set(const []);
    _familiesLoad = null;
    for (final value in _memoryValues.values) {
      value.set(const []);
    }
  }

  @override
  Future<void> deleteAccount() async {
    await api.sendJson('DELETE', '/account');
    await secrets.deleteAll();
    await _clearLocalContent();
    await identity.signOut();
    _accountLoad = Future.value();
    _account.set(null);
  }

  @override
  Future<FamilyAccount> acceptTerms(String version) async {
    await api.sendJson(
      'PUT',
      '/account/terms',
      json: {'version': version},
      idempotent: true,
    );
    return _refreshAccount();
  }

  @override
  Future<FamilyAccount> linkSubscription() async {
    final purchase = await purchases.premiumPurchase();
    if (purchase == null) {
      throw const FamilyException(
        FamilyErrorCodes.noPurchaseFound,
        'No Premium subscription was found on this device.',
      );
    }
    await api.sendJson(
      'POST',
      '/account/subscription',
      json: purchase.toJson(),
      idempotent: true,
    );
    return _refreshAccount();
  }

  // Families ------------------------------------------------------------------

  @override
  Stream<List<Family>> watchFamilies() async* {
    await (_familiesLoad ??= _loadFamilies());
    yield* _families.stream();
  }

  Future<void> _loadFamilies() async {
    _families.set(await cache.families());
    if (await secrets.sessionToken() != null) {
      unawaited(refreshFamilies().then((_) {}, onError: (_) {}));
    }
  }

  /// Fetches the families list; families this account no longer belongs
  /// to are removed from the device (cache, photos and key).
  Future<List<Family>> refreshFamilies() async {
    final json = await api.getJson('/families');
    final list = json['families'];
    if (list is! List) {
      throw const FamilyException(FamilyErrorCodes.invalidResponse);
    }
    final families = <Family>[];
    for (final entry in list) {
      if (entry is Map) {
        families.add(await _parseFamily(entry.cast<String, Object?>()));
      }
    }
    final previous = await cache.families();
    final current = {for (final f in families) f.id};
    for (final old in previous) {
      if (!current.contains(old.id)) await _forgetFamily(old.id);
    }
    await _saveFamilies(families);
    return families;
  }

  Future<void> _saveFamilies(List<Family> families) async {
    await cache.saveFamilies(families);
    _families.set(List.unmodifiable(families));
    _familiesLoad ??= Future.value();
  }

  Future<void> _upsertFamily(Family family) async {
    final families = [...await cache.families()];
    final index = families.indexWhere((f) => f.id == family.id);
    if (index == -1) {
      families.add(family);
    } else {
      families[index] = family;
    }
    await _saveFamilies(families);
  }

  Future<void> _forgetFamily(String familyId) async {
    // A sync still running for this family must not write it back.
    _forgotten[familyId] = (_forgotten[familyId] ?? 0) + 1;
    await _locked(familyId, () => cache.deleteFamily(familyId));
    await secrets.deleteKey(familyId);
    _memoryValues[familyId]?.set(const []);
    final families = (await cache.families())
        .where((f) => f.id != familyId)
        .toList();
    await _saveFamilies(families);
  }

  Future<Family> _parseFamily(Map<String, Object?> json) async {
    final id = json['id'];
    if (id is! String) {
      throw const FamilyException(FamilyErrorCodes.invalidResponse);
    }
    final ring = await secrets.keyRing(id);
    var name = '';
    final encryptedName = json['encryptedName'];
    if (ring != null && encryptedName is String) {
      try {
        name = await _decryptName(encryptedName, ring);
      } on FamilyDecryptionException {
        name = '';
      }
    }
    final usage = json['usage'];
    return Family(
      id: id,
      name: name,
      ownerId: json['ownerId'] is String ? json['ownerId'] as String : '',
      role: json['role'] == 'owner' ? FamilyRole.owner : FamilyRole.member,
      memberCount: json['memberCount'] is int ? json['memberCount'] as int : 0,
      usedBytes: usage is Map && usage['usedBytes'] is int
          ? usage['usedBytes'] as int
          : 0,
      quotaBytes: usage is Map && usage['quotaBytes'] is int
          ? usage['quotaBytes'] as int
          : 0,
    );
  }

  // The name is encrypted before the server assigns the family id, so its
  // associated data cannot name the family; each family has its own key,
  // so a name still cannot be moved between families.
  Future<String> _encryptName(String name, FamilyKeyRing ring) {
    if (utf8.encode(name).length > _maxNameBytes) {
      throw const FamilyException(FamilyErrorCodes.nameTooLong);
    }
    return cipher.encryptString(
      name,
      ring: ring,
      familyId: '',
      kind: FamilyCipherKinds.familyName,
      id: '',
    );
  }

  Future<String> _decryptName(String encrypted, FamilyKeyRing ring) =>
      cipher.decryptString(
        encrypted,
        ring: ring,
        familyId: '',
        kind: FamilyCipherKinds.familyName,
        id: '',
      );

  Future<FamilyKeyRing> _ring(String familyId) async {
    final ring = await secrets.keyRing(familyId);
    if (ring == null) {
      throw const FamilyException(
        FamilyErrorCodes.familyKeyMissing,
        'This device does not have the key for this family wall. '
        'Open a new invite link from a family member.',
      );
    }
    return ring;
  }

  @override
  Future<Family> createFamily(String name) async {
    final key = FamilyKey.generate();
    final ring = await FamilyKeyRing.single(key);
    final json = await api.sendJson(
      'POST',
      '/families',
      json: {'encryptedName': await _encryptName(name, ring)},
    );
    final familyJson = json['family'];
    if (familyJson is! Map || familyJson['id'] is! String) {
      throw const FamilyException(FamilyErrorCodes.invalidResponse);
    }
    await secrets.addKey(familyJson['id'] as String, key);
    final family = await _parseFamily(familyJson.cast<String, Object?>());
    await _upsertFamily(family);
    return family;
  }

  @override
  Future<void> renameFamily(String familyId, String name) async {
    final ring = await _ring(familyId);
    final json = await api.sendJson(
      'PATCH',
      '/families/$familyId',
      json: {'encryptedName': await _encryptName(name, ring)},
      idempotent: true,
    );
    final familyJson = json['family'];
    if (familyJson is Map) {
      await _upsertFamily(
        await _parseFamily(familyJson.cast<String, Object?>()),
      );
    }
  }

  @override
  Future<void> deleteFamily(String familyId) async {
    await api.sendJson('DELETE', '/families/$familyId');
    await _forgetFamily(familyId);
  }

  @override
  Future<void> leaveFamily(
    String familyId, {
    bool deleteMyContent = false,
  }) async {
    await api.sendJson(
      'POST',
      '/families/$familyId/leave',
      json: {'deleteContent': deleteMyContent},
    );
    await _forgetFamily(familyId);
  }

  @override
  Future<List<FamilyMember>> members(String familyId) async {
    final Map<String, Object?> json;
    try {
      json = await api.getJson('/families/$familyId');
    } on FamilyException catch (error) {
      if (error.code == FamilyErrorCodes.network) {
        return (await cache.state(familyId)).members;
      }
      if (error.code == FamilyErrorCodes.familyNotFound) {
        await _forgetFamily(familyId);
      }
      rethrow;
    }
    final ring = await secrets.keyRing(familyId);
    final blocked = await cache.blocked();
    final members = <FamilyMember>[];
    final list = json['members'];
    if (list is List) {
      for (final entry in list) {
        if (entry is! Map || entry['accountId'] is! String) continue;
        final accountId = entry['accountId'] as String;
        members.add(
          FamilyMember(
            accountId: accountId,
            role: entry['role'] == 'owner'
                ? FamilyRole.owner
                : FamilyRole.member,
            displayName: await _displayName(
              familyId,
              accountId,
              entry['encryptedProfile'],
              ring,
            ),
            isBlockedByMe: blocked.contains(accountId),
          ),
        );
      }
    }
    final familyJson = json['family'];
    await _locked(familyId, () async {
      final state = await cache.state(familyId);
      await cache.saveState(
        familyId,
        state.copyWith(
          members: members,
          membersVersion:
              familyJson is Map && familyJson['membersVersion'] is int
              ? familyJson['membersVersion'] as int
              : null,
        ),
      );
    });
    if (familyJson is Map) {
      await _upsertFamily(
        await _parseFamily(familyJson.cast<String, Object?>()),
      );
    }
    return members;
  }

  Future<String> _displayName(
    String familyId,
    String accountId,
    Object? encryptedProfile,
    FamilyKeyRing? ring,
  ) async {
    if (encryptedProfile is! String || ring == null) return '';
    try {
      final profile = jsonDecode(
        await cipher.decryptString(
          encryptedProfile,
          ring: ring,
          familyId: familyId,
          kind: FamilyCipherKinds.profile,
          id: accountId,
        ),
      );
      return profile is Map && profile['displayName'] is String
          ? profile['displayName'] as String
          : '';
    } on FamilyDecryptionException {
      return '';
    } on FormatException {
      return '';
    }
  }

  @override
  Future<void> setMyDisplayName(String familyId, String displayName) async {
    final ring = await _ring(familyId);
    final accountId = (await _currentAccountId())!;
    final encrypted = await cipher.encryptString(
      jsonEncode({'displayName': displayName}),
      ring: ring,
      familyId: familyId,
      kind: FamilyCipherKinds.profile,
      id: accountId,
    );
    await api.sendJson(
      'PUT',
      '/families/$familyId/members/me/profile',
      json: {'encryptedProfile': encrypted},
      idempotent: true,
    );
    unawaited(members(familyId).then((_) {}, onError: (_) {}));
  }

  Future<String?> _currentAccountId() async {
    await (_accountLoad ??= _loadAccount());
    final id = _account.value?.id;
    if (id != null) return id;
    return (await _refreshAccount()).id;
  }

  @override
  Future<void> removeMember(
    String familyId,
    String accountId, {
    bool deleteContent = false,
  }) async {
    await api.sendJson(
      'DELETE',
      '/families/$familyId/members/$accountId',
      query: deleteContent ? const {'deleteContent': 'true'} : null,
    );
    unawaited(members(familyId).then((_) {}, onError: (_) {}));
    if (deleteContent) _syncQuietly(familyId);
  }

  // Invites -------------------------------------------------------------------

  @override
  Future<Uri> createInvite(String familyId) async {
    final ring = await _ring(familyId);
    final json = await api.sendJson(
      'POST',
      '/families/$familyId/invites',
      json: const <String, Object?>{},
    );
    final inviteUrl = json['inviteUrl'];
    if (inviteUrl is! String) {
      throw const FamilyException(FamilyErrorCodes.invalidResponse);
    }
    return FamilyInviteLink.withKey(inviteUrl, ring.currentKey);
  }

  @override
  bool isInviteLink(Uri link) => FamilyInviteLink.tryParse(link) != null;

  @override
  Future<Family> acceptInvite(Uri link) async {
    final invite = FamilyInviteLink.tryParse(link);
    if (invite == null) {
      throw const FamilyException(FamilyErrorCodes.inviteInvalid);
    }
    Map<String, Object?>? familyJson;
    try {
      // Only the token goes to the server; the key stays on the device.
      final json = await api.sendJson(
        'POST',
        '/invites/accept',
        json: {'token': invite.token},
      );
      final family = json['family'];
      if (family is Map) familyJson = family.cast<String, Object?>();
    } on FamilyApiException catch (error) {
      // Already a member (e.g. a new phone): the link still brings the key.
      if (error.code != FamilyErrorCodes.alreadyMember ||
          error.details['familyId'] != invite.familyId) {
        rethrow;
      }
      final json = await api.getJson('/families/${invite.familyId}');
      final family = json['family'];
      if (family is Map) familyJson = family.cast<String, Object?>();
    }
    if (familyJson == null || familyJson['id'] != invite.familyId) {
      throw const FamilyException(FamilyErrorCodes.inviteInvalid);
    }
    // The key must open the family's name, or the link was altered.
    final ring = await FamilyKeyRing.single(invite.key);
    final encryptedName = familyJson['encryptedName'];
    try {
      if (encryptedName is! String) throw const FamilyDecryptionException('');
      await _decryptName(encryptedName, ring);
    } on FamilyDecryptionException {
      throw const FamilyException(FamilyErrorCodes.inviteKeyInvalid);
    }
    final existing = await secrets.keyRing(invite.familyId);
    await secrets.addKey(
      invite.familyId,
      invite.key,
      makeCurrent: existing == null,
    );
    final family = await _parseFamily(familyJson);
    await _upsertFamily(family);
    _syncQuietly(invite.familyId);
    return family;
  }

  // Memories ------------------------------------------------------------------

  _Value<List<FamilyMemory>> _memoriesValue(String familyId) =>
      _memoryValues.putIfAbsent(familyId, () => _Value(const []));

  _Value<FamilySyncStatus> _statusValue(String familyId) =>
      _statusValues.putIfAbsent(familyId, () => _Value(FamilySyncStatus.idle));

  @override
  Stream<List<FamilyMemory>> watchMemories(String familyId) async* {
    final value = _memoriesValue(familyId);
    await _publish(familyId);
    yield* value.stream(
      onListen: () {
        _memoryWatchers.update(familyId, (n) => n + 1, ifAbsent: () => 1);
        _syncQuietly(familyId);
      },
      onCancel: () {
        final left = (_memoryWatchers[familyId] ?? 1) - 1;
        if (left <= 0) {
          _memoryWatchers.remove(familyId);
        } else {
          _memoryWatchers[familyId] = left;
        }
      },
    );
  }

  /// Emits the cached memories (minus blocked authors), oldest first.
  Future<void> _publish(String familyId) async {
    final blocked = await cache.blocked();
    final list =
        (await cache.memories(
            familyId,
          )).values.where((m) => !blocked.contains(m.authorId)).toList()
          ..sort((a, b) {
            final byCreated = a.createdAt.compareTo(b.createdAt);
            return byCreated != 0 ? byCreated : a.id.compareTo(b.id);
          });
    _memoriesValue(familyId).set(List.unmodifiable(list));
  }

  @override
  Stream<FamilySyncStatus> watchSyncStatus(String familyId) =>
      _statusValue(familyId).stream();

  void _syncQuietly(String familyId) {
    unawaited(sync(familyId).then((_) {}, onError: (_) {}));
  }

  /// Syncs every family whose memories are on screen (app foreground).
  Future<void> syncWatched() async {
    if (await secrets.sessionToken() == null) return;
    unawaited(_refreshAccount().then((_) {}, onError: (_) {}));
    unawaited(refreshFamilies().then((_) {}, onError: (_) {}));
    for (final familyId in _memoryWatchers.keys.toList()) {
      _syncQuietly(familyId);
    }
  }

  @override
  Future<void> sync(String familyId) {
    final running = _syncs[familyId];
    if (running != null) {
      // A write or foreground event during a sync: run once more after it
      // so nothing that changed meanwhile is missed, and answer with that.
      _syncAgain.add(familyId);
      return running.then(
        (_) => _syncs[familyId] ?? Future<void>.value(),
        onError: (_) => _syncs[familyId] ?? Future<void>.value(),
      );
    }
    return _syncs[familyId] = _sync(familyId).whenComplete(() {
      _syncs.remove(familyId);
      if (_syncAgain.remove(familyId)) _syncQuietly(familyId);
    });
  }

  Future<void> _sync(String familyId) async {
    final status = _statusValue(familyId);
    status.set(FamilySyncStatus.syncing);
    try {
      await _pullChanges(familyId);
      status.set(FamilySyncStatus.idle);
    } on FamilyException catch (error) {
      status.set(
        error.code == FamilyErrorCodes.network
            ? FamilySyncStatus.offline
            : FamilySyncStatus.error,
      );
      rethrow;
    } catch (_) {
      status.set(FamilySyncStatus.error);
      rethrow;
    }
  }

  /// Runs [action] exclusively for [familyId]'s cache, so a sync applying a
  /// page and a local write never overwrite each other.
  Future<T> _locked<T>(String familyId, Future<T> Function() action) {
    final previous = _locks[familyId] ?? Future<void>.value();
    final result = previous.then((_) => action());
    _locks[familyId] = result.then((_) {}, onError: (_) {});
    return result;
  }

  /// The sync loop: pages through `/changes` from the stored cursor,
  /// downloads and decrypts new or newer memories, applies tombstones and
  /// saves the cursor after every page.
  ///
  /// - `cursor_reset` (server history rewound, e.g. restored from backup):
  ///   start again from 0.
  /// - A sync from 0 lists every live item, so cached memories it does not
  ///   list are removed (deleted, or by a blocked author).
  /// - A changed `membersVersion` refreshes the member list.
  /// - `family_not_found` (removed from the family, or it was deleted):
  ///   the family is removed from the device.
  Future<void> _pullChanges(String familyId) async {
    final generation = _generation;
    final forgotten = _forgotten[familyId] ?? 0;
    final ring = await _ring(familyId);
    var state = await cache.state(familyId);
    var cursor = state.cursor;
    var fullResync = cursor == '0';
    var startIds = (await cache.memories(familyId)).keys.toSet();
    final seen = <String>{};
    var membersChanged = false;

    while (true) {
      final Map<String, Object?> page;
      try {
        page = await api.getJson(
          '/families/$familyId/changes',
          query: {'since': cursor, 'limit': '$_changesPageSize'},
        );
      } on FamilyException catch (error) {
        if (error.code == FamilyErrorCodes.cursorReset && cursor != '0') {
          cursor = '0';
          fullResync = true;
          startIds = (await cache.memories(familyId)).keys.toSet();
          seen.clear();
          continue;
        }
        if (error.code == FamilyErrorCodes.familyNotFound) {
          await _forgetFamily(familyId);
        }
        rethrow;
      }

      final changes = page['changes'];
      final nextCursor = page['cursor'];
      if (changes is! List || nextCursor is! String) {
        throw const FamilyException(FamilyErrorCodes.invalidResponse);
      }
      final cached = await cache.memories(familyId);
      final removals = <String>{};
      final toFetch = <String, _Change>{};
      for (final raw in changes) {
        if (raw is! Map) continue;
        final change = _Change.parse(raw.cast<String, Object?>());
        if (change == null) continue;
        if (change.kind == FamilyCipherKinds.photo) {
          // Photos never change in place; a tombstone drops the local copy.
          if (change.deleted) await _deletePhotoFile(familyId, change.id);
          continue;
        }
        if (change.kind != FamilyCipherKinds.memory) continue;
        if (change.deleted) {
          removals.add(change.id);
          toFetch.remove(change.id);
          seen.remove(change.id);
          continue;
        }
        seen.add(change.id);
        removals.remove(change.id);
        final known = cached[change.id];
        if (known == null || known.version < change.version) {
          toFetch[change.id] = change;
        }
      }

      final fetchList = toFetch.values.toList();
      final fetched = await _pool(
        fetchList,
        (change) => _fetchMemory(familyId, change, ring),
      );
      final upserts = <FamilyMemory>[];
      for (var i = 0; i < fetchList.length; i++) {
        final memory = fetched[i];
        if (memory == null) {
          removals.add(fetchList[i].id);
          seen.remove(fetchList[i].id);
        } else {
          upserts.add(memory);
        }
      }

      final membersVersion = page['membersVersion'];
      if (membersVersion is int && membersVersion != state.membersVersion) {
        membersChanged = true;
      }
      final hasMore = page['hasMore'] == true;
      cursor = nextCursor;
      final finishedResync = !hasMore && fullResync;

      // Progress is saved per page, so an interrupted sync resumes.
      await _locked(familyId, () async {
        if (generation != _generation) {
          throw const FamilyException(FamilyErrorCodes.signedOut);
        }
        if (forgotten != (_forgotten[familyId] ?? 0)) {
          throw const FamilyException(FamilyErrorCodes.familyNotFound);
        }
        final memories = Map.of(await cache.memories(familyId));
        memories.removeWhere((id, _) => removals.contains(id));
        for (final memory in upserts) {
          final existing = memories[memory.id];
          if (existing == null || existing.version < memory.version) {
            memories[memory.id] = memory;
          }
        }
        if (finishedResync) {
          // Memories written locally during this sync are not in startIds.
          memories.removeWhere(
            (id, _) => startIds.contains(id) && !seen.contains(id),
          );
          await _deleteUnreferencedPhotos(familyId, memories.values);
        }
        await cache.saveMemories(familyId, memories);
        state = (await cache.state(familyId)).copyWith(cursor: cursor);
        await cache.saveState(familyId, state);
      });
      await _publish(familyId);
      if (!hasMore) break;
    }

    if (membersChanged) {
      try {
        await members(familyId);
      } on FamilyException {
        // The member list refreshes on the next sync.
      }
    }
  }

  /// Downloads and decrypts one memory; null if it vanished meanwhile or
  /// cannot be decrypted with this device's keys.
  Future<FamilyMemory?> _fetchMemory(
    String familyId,
    _Change change,
    FamilyKeyRing ring,
  ) async {
    final FamilyHttpResponse response;
    try {
      response = await api.getBlob('/families/$familyId/memories/${change.id}');
    } on FamilyException catch (error) {
      if (error.code == FamilyErrorCodes.itemDeleted ||
          error.code == FamilyErrorCodes.itemNotFound) {
        return null;
      }
      rethrow;
    }
    final version = int.tryParse(response.headers['x-item-version'] ?? '');
    try {
      final clear = await cipher.decrypt(
        response.body,
        ring: ring,
        familyId: familyId,
        kind: FamilyCipherKinds.memory,
        id: change.id,
      );
      final record = jsonDecode(utf8.decode(clear));
      if (record is! Map) return null;
      return FamilyMemoryRecord.decode(
        record.cast<String, Object?>(),
        id: change.id,
        familyId: familyId,
        authorId: response.headers['x-author-id'] ?? change.authorId,
        version: version ?? change.version,
        createdAt: change.createdAt,
        updatedAt: change.updatedAt,
      );
    } on FamilyDecryptionException catch (error) {
      debugPrint('Family memory ${change.id} could not be decrypted: $error');
      return null;
    } on FormatException {
      return null;
    }
  }

  static Future<List<R>> _pool<T, R>(
    List<T> items,
    Future<R> Function(T item) task,
  ) async {
    final results = List<R?>.filled(items.length, null);
    var next = 0;
    Future<void> worker() async {
      while (next < items.length) {
        final index = next++;
        results[index] = await task(items[index]);
      }
    }

    await Future.wait([
      for (var i = 0; i < _downloadConcurrency && i < items.length; i++)
        worker(),
    ]);
    return results.cast<R>();
  }

  Future<void> _deletePhotoFile(String familyId, String photoId) async {
    // Not a plain id (e.g. "../x"): there is no such file in the cache.
    if (!isSafeFamilyId(familyId) || !isSafeFamilyId(photoId)) return;
    final file = await cache.photoFile(familyId, photoId);
    if (await file.exists()) await file.delete();
  }

  Future<void> _deleteUnreferencedPhotos(
    String familyId,
    Iterable<FamilyMemory> memories,
  ) async {
    final dir = await cache.photosDir(familyId);
    if (!await dir.exists()) return;
    final referenced = {for (final m in memories) ...m.photoIds};
    await for (final entity in dir.list()) {
      final name = entity.uri.pathSegments.last;
      if (entity is File &&
          name.endsWith('.jpg') &&
          !referenced.contains(name.substring(0, name.length - 4))) {
        await entity.delete();
      }
    }
  }

  @override
  Future<FamilyMemory> addMemory(
    String familyId,
    FamilyMemoryDraft draft,
  ) async {
    final ring = await _ring(familyId);
    final index = (await cache.memories(familyId)).length;
    final id = _newId();
    final newPhotoIds = await _uploadPhotos(
      familyId,
      ring,
      draft.newPhotoPaths,
    );
    final photoIds = newPhotoIds;
    final record = FamilyMemoryRecord.encode(
      title: draft.title,
      description: draft.description,
      category: draft.category,
      feeling: draft.feeling,
      occurredAt: draft.occurredAt,
      locationLabel: draft.locationLabel,
      latitude: draft.latitude,
      longitude: draft.longitude,
      coverPhotoId: _cover(photoIds, draft.coverIndex),
      photoIds: photoIds,
      // Same scatter as the personal wall.
      wallX: 150.0 + (index % 3) * 260,
      wallY: 180.0 + (index ~/ 3) * 210,
      rotation: index.isEven ? -0.035 : 0.04,
    );
    try {
      return await _putMemory(familyId, id, record, ring, baseVersion: 0);
    } on FamilyException {
      await _deletePhotosQuietly(familyId, newPhotoIds);
      rethrow;
    }
  }

  @override
  Future<FamilyMemory> updateMemory(
    FamilyMemory memory,
    FamilyMemoryDraft draft,
  ) async {
    final familyId = memory.familyId;
    final ring = await _ring(familyId);
    final kept = draft.keptPhotoIds.where(memory.photoIds.contains).toList();
    final newPhotoIds = await _uploadPhotos(
      familyId,
      ring,
      draft.newPhotoPaths,
    );
    final photoIds = [...kept, ...newPhotoIds];
    final record = FamilyMemoryRecord.encode(
      title: draft.title,
      description: draft.description,
      category: draft.category,
      feeling: draft.feeling,
      occurredAt: draft.occurredAt,
      locationLabel: draft.locationLabel,
      latitude: draft.latitude,
      longitude: draft.longitude,
      coverPhotoId: _cover(photoIds, draft.coverIndex),
      photoIds: photoIds,
      wallX: memory.wallX,
      wallY: memory.wallY,
      rotation: memory.rotation,
    );
    final FamilyMemory updated;
    try {
      updated = await _putMemory(
        familyId,
        memory.id,
        record,
        ring,
        baseVersion: memory.version,
        createdAt: memory.createdAt,
      );
    } on FamilyException {
      await _deletePhotosQuietly(familyId, newPhotoIds);
      rethrow;
    }
    final removed = memory.photoIds.where((id) => !kept.contains(id));
    await _deletePhotosQuietly(familyId, removed.toList());
    return updated;
  }

  @override
  Future<void> moveMemory(
    FamilyMemory memory,
    double wallX,
    double wallY,
  ) async {
    final ring = await _ring(memory.familyId);
    final record = {
      ...FamilyMemoryRecord.fromMemory(memory),
      'wallX': wallX,
      'wallY': wallY,
    };
    await _putMemory(
      memory.familyId,
      memory.id,
      record,
      ring,
      baseVersion: memory.version,
      createdAt: memory.createdAt,
    );
  }

  @override
  Future<void> deleteMemory(FamilyMemory memory) async {
    final familyId = memory.familyId;
    try {
      await api.sendJson('DELETE', '/families/$familyId/memories/${memory.id}');
    } on FamilyException catch (error) {
      if (error.code != FamilyErrorCodes.itemNotFound) rethrow;
    }
    await _deletePhotosQuietly(familyId, memory.photoIds);
    await _locked(familyId, () async {
      final memories = Map.of(await cache.memories(familyId))
        ..remove(memory.id);
      await cache.saveMemories(familyId, memories);
    });
    await _publish(familyId);
    _syncQuietly(familyId);
  }

  static String? _cover(List<String> photoIds, int index) {
    if (photoIds.isEmpty) return null;
    return index >= 0 && index < photoIds.length
        ? photoIds[index]
        : photoIds.first;
  }

  Future<FamilyMemory> _putMemory(
    String familyId,
    String id,
    Map<String, Object?> record,
    FamilyKeyRing ring, {
    required int baseVersion,
    DateTime? createdAt,
  }) async {
    final envelope = await cipher.encrypt(
      utf8.encode(jsonEncode(record)),
      ring: ring,
      familyId: familyId,
      kind: FamilyCipherKinds.memory,
      id: id,
    );
    final item = await api.putBlob(
      '/families/$familyId/memories/$id',
      bytes: envelope,
      baseVersion: baseVersion,
      keyId: ring.currentKeyId,
    );
    final now = _now();
    final version = item['version'] is int
        ? item['version'] as int
        : baseVersion + 1;
    final accountId = item['authorId'] is String
        ? item['authorId'] as String
        : (await _currentAccountId())!;
    final memory = FamilyMemoryRecord.decode(
      record,
      id: id,
      familyId: familyId,
      authorId: accountId,
      version: version,
      createdAt: DateTime.tryParse('${item['createdAt']}') ?? createdAt ?? now,
      updatedAt: DateTime.tryParse('${item['updatedAt']}') ?? now,
    );
    await _locked(familyId, () async {
      final memories = Map.of(await cache.memories(familyId));
      final existing = memories[id];
      if (existing == null || existing.version < memory.version) {
        memories[id] = memory;
        await cache.saveMemories(familyId, memories);
      }
    });
    await _publish(familyId);
    _syncQuietly(familyId);
    return memory;
  }

  /// Resizes, encrypts and uploads photos; keeps the decrypted JPEG in the
  /// cache so the author never downloads their own photo.
  Future<List<String>> _uploadPhotos(
    String familyId,
    FamilyKeyRing ring,
    List<String> paths,
  ) async {
    final uploaded = <String>[];
    try {
      for (final path in paths) {
        final photoId = _newId();
        final jpeg = await photos.prepare(path);
        final cipher = this.cipher;
        final envelope = await Isolate.run(
          () => cipher.encrypt(
            jpeg,
            ring: ring,
            familyId: familyId,
            kind: FamilyCipherKinds.photo,
            id: photoId,
          ),
        );
        await api.putBlob(
          '/families/$familyId/photos/$photoId',
          bytes: envelope,
          baseVersion: 0,
          keyId: ring.currentKeyId,
        );
        uploaded.add(photoId);
        await _writeAtomically(await cache.photoFile(familyId, photoId), jpeg);
      }
    } on FamilyException {
      await _deletePhotosQuietly(familyId, uploaded);
      rethrow;
    }
    return uploaded;
  }

  Future<void> _deletePhotosQuietly(
    String familyId,
    List<String> photoIds,
  ) async {
    for (final photoId in photoIds) {
      try {
        await api.sendJson('DELETE', '/families/$familyId/photos/$photoId');
      } on FamilyException {
        // An orphaned photo only costs quota; the owner can still delete.
      }
      await _deletePhotoFile(familyId, photoId);
    }
  }

  @override
  Future<File> photoFile(String familyId, String photoId) {
    final key = '$familyId/$photoId';
    return _photoLoads[key] ??= _loadPhoto(familyId, photoId).whenComplete(() {
      // A block body: returning the removed future would await itself.
      _photoLoads.remove(key);
    });
  }

  Future<File> _loadPhoto(String familyId, String photoId) async {
    final generation = _generation;
    final file = await cache.photoFile(familyId, photoId);
    if (await file.exists()) return file;
    final ring = await _ring(familyId);
    final response = await api.getBlob('/families/$familyId/photos/$photoId');
    final cipher = this.cipher;
    final body = response.body;
    final Uint8List jpeg;
    try {
      jpeg = await Isolate.run(
        () => cipher.decrypt(
          body,
          ring: ring,
          familyId: familyId,
          kind: FamilyCipherKinds.photo,
          id: photoId,
        ),
      );
    } on FamilyDecryptionException {
      throw const FamilyException(FamilyErrorCodes.photoUnreadable);
    }
    if (generation != _generation) {
      throw const FamilyException(FamilyErrorCodes.signedOut);
    }
    await _writeAtomically(file, jpeg);
    return file;
  }

  static Future<void> _writeAtomically(File file, List<int> bytes) async {
    await file.parent.create(recursive: true);
    final temp = File('${file.path}.tmp');
    await temp.writeAsBytes(bytes, flush: true);
    await temp.rename(file.path);
  }

  // Moderation ----------------------------------------------------------------

  @override
  Future<void> report({
    required String familyId,
    required FamilyReportTarget target,
    required String targetId,
    required FamilyReportReason reason,
    String? details,
  }) async {
    // The server cannot read the content, so a memory report carries its
    // decrypted text for review (photos are not sent).
    String? evidence;
    if (target == FamilyReportTarget.memory) {
      final memory = (await cache.memories(familyId))[targetId];
      if (memory != null) {
        evidence = 'Title: ${memory.title}\n\n${memory.description}';
        if (evidence.length > 10000) evidence = evidence.substring(0, 10000);
      }
    }
    await api.sendJson(
      'POST',
      '/families/$familyId/reports',
      json: {
        'targetType': target.name,
        'targetId': targetId,
        'reason': reason == FamilyReportReason.selfHarm
            ? 'self_harm'
            : reason.name,
        'details': ?details,
        'evidence': ?evidence,
      },
    );
  }

  @override
  Future<void> block(String accountId) async {
    await api.sendJson('PUT', '/blocks/$accountId', idempotent: true);
    final blocked = {...await cache.blocked(), accountId};
    await cache.saveBlocked(blocked);
    for (final family in await cache.families()) {
      // The server stops sending their items; drop what is cached.
      await _locked(family.id, () async {
        final memories = Map.of(await cache.memories(family.id))
          ..removeWhere((_, m) => m.authorId == accountId);
        await cache.saveMemories(family.id, memories);
        await _markBlocked(family.id, accountId, true);
      });
      await _publish(family.id);
    }
  }

  @override
  Future<void> unblock(String accountId) async {
    try {
      await api.sendJson('DELETE', '/blocks/$accountId');
    } on FamilyException catch (error) {
      if (error.code != 'not_blocked') rethrow;
    }
    final blocked = {...await cache.blocked()}..remove(accountId);
    await cache.saveBlocked(blocked);
    for (final family in await cache.families()) {
      // Their items come back only with a sync from the start.
      await _locked(family.id, () async {
        final state = await cache.state(family.id);
        await cache.saveState(family.id, state.copyWith(cursor: '0'));
        await _markBlocked(family.id, accountId, false);
      });
      _syncQuietly(family.id);
    }
  }

  Future<void> _markBlocked(
    String familyId,
    String accountId,
    bool blocked,
  ) async {
    final state = await cache.state(familyId);
    await cache.saveState(
      familyId,
      state.copyWith(
        members: [
          for (final m in state.members)
            m.accountId == accountId
                ? FamilyMember(
                    accountId: m.accountId,
                    role: m.role,
                    displayName: m.displayName,
                    isBlockedByMe: blocked,
                  )
                : m,
        ],
      ),
    );
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    api.http.close();
  }
}

class _Change {
  const _Change({
    required this.kind,
    required this.id,
    required this.version,
    required this.authorId,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String kind;
  final String id;
  final int version;
  final String authorId;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  static _Change? parse(Map<String, Object?> json) {
    final kind = json['kind'];
    final id = json['id'];
    final version = json['version'];
    if (kind is! String || id is! String || version is! int) return null;
    final createdAt = DateTime.tryParse('${json['createdAt']}');
    final updatedAt = DateTime.tryParse('${json['updatedAt']}');
    return _Change(
      kind: kind,
      id: id,
      version: version,
      authorId: json['authorId'] is String ? json['authorId'] as String : '',
      deleted: json['deleted'] == true,
      createdAt: createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          updatedAt ?? createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

/// A value with a stream that emits the current value on listen, then
/// every change.
class _Value<T> {
  _Value(this.value);

  T value;
  final _changes = StreamController<T>.broadcast(sync: true);

  void set(T next) {
    value = next;
    _changes.add(next);
  }

  Stream<T> stream({void Function()? onListen, void Function()? onCancel}) {
    return Stream<T>.multi((controller) {
      controller.add(value);
      final subscription = _changes.stream.listen(
        controller.add,
        onError: controller.addError,
      );
      onListen?.call();
      controller.onCancel = () {
        onCancel?.call();
        return subscription.cancel();
      };
    });
  }
}
