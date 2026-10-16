import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:life_threads/features/family/data/family_api_client.dart';
import 'package:life_threads/features/family/data/family_platform.dart';

/// An in-memory stand-in for the family API (backend/src/family/router.js)
/// with the same routes, status codes and error codes, implemented as a
/// [FamilyHttp] so the service can be tested without a network. Every
/// request is recorded for assertions.
class FakeFamilyServer implements FamilyHttp {
  static const base = 'https://family.test/api';
  static const termsVersion = '2026-10';

  final List<FamilyHttpRequest> requests = [];
  final Map<String, String> _sessions = {}; // token -> account id
  final Map<String, String> _accountsBySubject = {};
  final Set<String> accounts = {};
  final Map<String, String> terms = {};
  final Set<String> subscribed = {};
  final Map<String, FakeFamily> families = {};
  final Map<String, ({String familyId, bool used})> invites = {};
  final Set<(String, String)> blocks = {};
  int _counter = 0;
  int _clock = 0;

  /// Simulates no connection.
  bool offline = false;

  /// Caps `/changes` pages (the client asks for 200).
  int? maxPageSize;

  /// Answers the next `/changes` call with 409 `cursor_reset`.
  bool resetNextChanges = false;

  /// Rotation requests received (accepted or not).
  int rotations = 0;

  /// False: behaves like the server before key rotation (no key routes).
  bool supportsKeys = true;

  /// Drops the response of the next PUT after storing it (lost answer).
  bool loseNextPutResponse = false;

  /// Answers the next N GETs with 503.
  int failNextGets = 0;

  String _id(String prefix) =>
      '$prefix${(++_counter).toString().padLeft(20, '0')}';

  Iterable<FamilyHttpRequest> get mutations =>
      requests.where((r) => r.method != 'GET');

  @override
  void close() {}

  @override
  Future<FamilyHttpResponse> send(FamilyHttpRequest request) async {
    requests.add(request);
    if (offline) throw const SocketException('offline');
    if (request.method == 'GET' && failNextGets > 0) {
      failNextGets--;
      return _error(503, 'server_error', 'Unavailable.');
    }
    final path = request.uri.path.substring(Uri.parse(base).path.length);
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    try {
      final response = _route(request, segments);
      if (request.method == 'PUT' && loseNextPutResponse) {
        loseNextPutResponse = false;
        throw const SocketException('connection reset');
      }
      return response;
    } on _Fail catch (fail) {
      return _error(fail.status, fail.code, fail.code, fail.extra);
    }
  }

  FamilyHttpResponse _route(FamilyHttpRequest r, List<String> s) {
    final m = r.method;
    if (m == 'POST' && s.length == 2 && s[0] == 'auth' && s[1] != 'sign-out') {
      final idToken = _json(r)['idToken'] as String;
      final subject = '${s[1]}:$idToken';
      final isNew = !_accountsBySubject.containsKey(subject);
      final accountId = _accountsBySubject.putIfAbsent(subject, () {
        final id = _id('acc');
        accounts.add(id);
        return id;
      });
      final token = 'lts_${_id('').padRight(43, 'x')}';
      _sessions[token] = accountId;
      return _ok({
        'isNewAccount': isNew,
        'sessionToken': token,
        'account': {'id': accountId},
      }, status: isNew ? 201 : 200);
    }

    final me = _auth(r);
    if (m == 'POST' && _is(s, ['auth', 'sign-out'])) {
      _sessions.removeWhere((_, id) => id == me);
      return _ok({});
    }
    if (_is(s, ['account'])) {
      if (m == 'GET') {
        return _ok({
          'account': {
            'id': me,
            'termsVersionRequired': termsVersion,
            'termsAccepted': terms[me] == termsVersion,
          },
          'subscription': {'active': subscribed.contains(me)},
        });
      }
      if (m == 'DELETE') {
        for (final f in families.values.toList()) {
          if (f.ownerId == me) {
            families.remove(f.id);
          } else if (f.members.remove(me) != null) {
            f.memberGone(me);
            f.membersVersion++;
          }
        }
        accounts.remove(me);
        _sessions.removeWhere((_, id) => id == me);
        _accountsBySubject.removeWhere((_, id) => id == me);
        return _ok({'deleted': true});
      }
    }
    if (m == 'PUT' && _is(s, ['account', 'terms'])) {
      final version = _json(r)['version'];
      if (version != termsVersion) throw _Fail(400, 'terms_version_mismatch');
      terms[me] = termsVersion;
      return _ok({'termsVersionAccepted': version});
    }
    if (m == 'POST' && _is(s, ['account', 'subscription'])) {
      final body = _json(r);
      if (body['platform'] == 'google' && body['purchaseToken'] is String ||
          body['platform'] == 'apple' && body['transactionId'] is String) {
        subscribed.add(me);
        return _ok({
          'subscription': {'active': true},
        });
      }
      throw _Fail(400, 'invalid_purchase');
    }
    if (s.first == 'blocks' && s.length == 2) {
      if (m == 'PUT') {
        blocks.add((me, s[1]));
        return _ok({});
      }
      if (m == 'DELETE') {
        if (!blocks.remove((me, s[1]))) throw _Fail(404, 'not_blocked');
        return _ok({'resyncRequired': true});
      }
    }
    if (m == 'POST' && _is(s, ['invites', 'accept'])) {
      final token = _json(r)['token'];
      final invite = invites[token];
      if (invite == null) throw _Fail(404, 'invite_invalid');
      if (invite.used) throw _Fail(410, 'invite_used');
      final family = families[invite.familyId]!;
      if (family.members.containsKey(me)) {
        throw _Fail(409, 'already_member', {'familyId': family.id});
      }
      invites[token as String] = (familyId: family.id, used: true);
      family.members[me] = FakeMember('member');
      family.membersVersion++;
      return _ok({'family': family.toJson(me)});
    }
    if (s.first == 'families') {
      if (s.length == 1) {
        if (m == 'POST') {
          if (terms[me] != termsVersion) throw _Fail(403, 'terms_not_accepted');
          if (!subscribed.contains(me)) {
            throw _Fail(402, 'subscription_required');
          }
          final family = FakeFamily(
            id: _id('fam'),
            ownerId: me,
            encryptedName: _json(r)['encryptedName'] as String,
          )..keyId = _json(r)['keyId'] as String?;
          if (family.keyId != null) family.keyEpoch = 1;
          family.members[me] = FakeMember('owner');
          families[family.id] = family;
          return _ok({'family': family.toJson(me)}, status: 201);
        }
        return _ok({
          'families': [
            for (final f in families.values)
              if (f.members.containsKey(me)) f.toJson(me),
          ],
        });
      }
      final family = families[s[1]];
      if (family == null || !family.members.containsKey(me)) {
        throw _Fail(404, 'family_not_found');
      }
      final isOwner = family.ownerId == me;
      if (s.length == 2) {
        if (m == 'GET') {
          return _ok({
            'family': family.toJson(me),
            'members': [
              for (final e in family.members.entries)
                {
                  'accountId': e.key,
                  'role': e.value.role,
                  'encryptedProfile': e.value.profile,
                },
            ],
          });
        }
        if (!isOwner) throw _Fail(403, 'owner_only');
        if (m == 'PATCH') {
          family.encryptedName = _json(r)['encryptedName'] as String;
          return _ok({'family': family.toJson(me)});
        }
        if (m == 'DELETE') {
          families.remove(family.id);
          return _ok({'deleted': true});
        }
      }
      if (m == 'POST' && s.length == 3 && s[2] == 'leave') {
        if (isOwner) throw _Fail(409, 'owner_cannot_leave');
        family.members.remove(me);
        family.memberGone(me);
        family.membersVersion++;
        return _ok({});
      }
      if (m == 'PUT' && _is(s.sublist(2), ['members', 'me', 'profile'])) {
        family.members[me]!.profile = _json(r)['encryptedProfile'] as String;
        return _ok({});
      }
      if (m == 'DELETE' && s.length == 4 && s[2] == 'members') {
        if (!isOwner) throw _Fail(403, 'owner_only');
        if (family.members.remove(s[3]) == null) {
          throw _Fail(404, 'member_not_found');
        }
        family.memberGone(s[3]);
        family.membersVersion++;
        if (r.uri.queryParameters['deleteContent'] == 'true') {
          for (final item in family.items.values) {
            if (item.authorId == s[3] && !item.deleted) family.tombstone(item);
          }
        }
        return _ok({});
      }
      // Keys (rotation) ------------------------------------------------------
      if (!supportsKeys &&
          (s.contains('devices') || (s.length > 2 && s[2] == 'keys'))) {
        throw _Fail(404, 'not_found');
      }
      if (m == 'PUT' &&
          s.length == 6 &&
          _is(s.sublist(2, 5), ['members', 'me', 'devices'])) {
        final body = _json(r);
        family.devices['$me/${s[5]}'] = (
          publicKey: body['publicKey'] as String,
          proof: body['proof'] as String,
        );
        return _ok({});
      }
      if (m == 'GET' && s.length == 3 && s[2] == 'devices') {
        return _ok({
          'devices': [
            for (final e in family.devices.entries)
              {
                'accountId': e.key.split('/').first,
                'deviceId': e.key.split('/').last,
                'publicKey': e.value.publicKey,
                'proof': e.value.proof,
              },
          ],
        });
      }
      if (m == 'GET' &&
          s.length == 5 &&
          _is(s.sublist(2, 4), ['keys', 'current'])) {
        final keyId = family.keyId;
        if (keyId == null) throw _Fail(404, 'key_not_found');
        final sealed = family.seals['$keyId/$me/${s[4]}'];
        final chain = family.chains[keyId];
        if (sealed == null) {
          throw _Fail(404, 'key_seal_missing', {
            'keyId': keyId,
            'epoch': family.keyEpoch,
            'encryptedChain': chain,
          });
        }
        return _ok({
          'keyId': keyId,
          'epoch': family.keyEpoch,
          'encryptedChain': chain,
          'sealed': sealed,
        });
      }
      if (m == 'POST' && s.length == 3 && s[2] == 'keys') {
        if (!isOwner) throw _Fail(403, 'owner_only');
        final body = _json(r);
        rotations++;
        if (body['epoch'] != family.keyEpoch + 1) {
          throw _Fail(409, 'key_epoch_conflict', {
            'currentEpoch': family.keyEpoch,
          });
        }
        for (final d in (body['rejected'] as List? ?? const [])) {
          family.devices.remove('${d['accountId']}/${d['deviceId']}');
        }
        final seals = {
          for (final x in body['seals'] as List)
            '${x['accountId']}/${x['deviceId']}': x['sealed'] as String,
        };
        final missing = [
          for (final k in family.devices.keys)
            if (!seals.containsKey(k))
              {'accountId': k.split('/').first, 'deviceId': k.split('/').last},
        ];
        if (missing.isNotEmpty) {
          throw _Fail(409, 'seals_incomplete', {'missing': missing});
        }
        final keyId = body['keyId'] as String;
        family
          ..seals.clear()
          ..keyId = keyId
          ..keyEpoch = family.keyEpoch + 1
          ..rotationRequired = false
          ..encryptedName = body['encryptedName'] as String
          ..membersVersion += 1;
        family.chains[keyId] = body['encryptedChain'] as String;
        for (final e in seals.entries) {
          family.seals['$keyId/${e.key}'] = e.value;
        }
        invites.updateAll(
          (_, v) =>
              v.familyId == family.id ? (familyId: v.familyId, used: true) : v,
        );
        return _ok({'family': family.toJson(me)});
      }
      if (m == 'POST' && s.length == 3 && s[2] == 'invites') {
        final token = 'lti_${_id('').padRight(32, 'y')}';
        invites[token] = (familyId: family.id, used: false);
        return _ok({
          'token': token,
          'inviteUrl':
              'https://lifethreads.gkcoding.dev/family/join#t=$token&f=${family.id}',
        }, status: 201);
      }
      if (m == 'POST' && s.length == 3 && s[2] == 'reports') {
        return _ok({'reportId': _id('rep')}, status: 201);
      }
      if (m == 'GET' && s.length == 3 && s[2] == 'changes') {
        final since = int.parse(r.uri.queryParameters['since'] ?? '0');
        if (resetNextChanges || since > family.seq) {
          resetNextChanges = false;
          throw _Fail(409, 'cursor_reset');
        }
        var limit = int.parse(r.uri.queryParameters['limit'] ?? '200');
        if (maxPageSize != null && maxPageSize! < limit) limit = maxPageSize!;
        final rows =
            family.items.values
                .where(
                  (i) => i.seq > since && !blocks.contains((me, i.authorId)),
                )
                .toList()
              ..sort((a, b) => a.seq.compareTo(b.seq));
        final hasMore = rows.length > limit;
        final page = rows.take(limit).toList();
        return _ok({
          'changes': [for (final i in page) i.toJson()],
          'cursor': '${hasMore ? page.last.seq : family.seq}',
          'hasMore': hasMore,
          'membersVersion': family.membersVersion,
        });
      }
      if (s.length == 4 && (s[2] == 'memories' || s[2] == 'photos')) {
        final kind = s[2] == 'memories' ? 'memory' : 'photo';
        final key = '$kind/${s[3]}';
        final current = family.items[key];
        if (m == 'PUT') {
          if (terms[me] != termsVersion) throw _Fail(403, 'terms_not_accepted');
          if (r.headers['content-type'] != 'application/octet-stream') {
            throw _Fail(415, 'unsupported_media_type');
          }
          final base = r.headers['if-none-match'] == '*'
              ? 0
              : int.tryParse(r.headers['if-match'] ?? '');
          if (base == null) throw _Fail(428, 'version_required');
          if (current != null && current.deleted) {
            throw _Fail(410, 'item_deleted');
          }
          if (current != null && current.authorId != me) {
            throw _Fail(403, 'not_author');
          }
          if (family.keyId != null && r.headers['x-key-id'] != family.keyId) {
            throw _Fail(409, 'key_outdated', {'keyId': family.keyId});
          }
          if ((current?.version ?? 0) != base) {
            throw _Fail(412, 'version_conflict', {
              'currentVersion': current?.version ?? 0,
            });
          }
          final now = DateTime.utc(
            2026,
            10,
            12,
          ).add(Duration(seconds: ++_clock));
          final item = current ?? FakeItem(kind, s[3], me, now);
          item
            ..version = base + 1
            ..bytes = Uint8List.fromList(r.body!)
            ..keyId = r.headers['x-key-id']
            ..updatedAt = now
            ..seq = ++family.seq;
          family.items[key] = item;
          return _ok({
            'item': item.toJson(),
            'cursor': '${item.seq}',
          }, status: base == 0 ? 201 : 200);
        }
        if (current == null || blocks.contains((me, current.authorId))) {
          throw _Fail(404, 'item_not_found');
        }
        if (m == 'GET') {
          if (current.deleted) throw _Fail(410, 'item_deleted');
          return FamilyHttpResponse(
            statusCode: 200,
            headers: {
              'content-type': 'application/octet-stream',
              'x-item-version': '${current.version}',
              'x-author-id': current.authorId,
              'x-key-id': ?current.keyId,
            },
            body: current.bytes,
          );
        }
        if (m == 'DELETE') {
          if (current.deleted) throw _Fail(404, 'item_not_found');
          if (current.authorId != me && !isOwner) throw _Fail(403, 'forbidden');
          family.tombstone(current);
          return _ok({'item': current.toJson()});
        }
      }
    }
    throw _Fail(404, 'not_found');
  }

  String _auth(FamilyHttpRequest r) {
    final header = r.headers['authorization'] ?? '';
    final token = header.startsWith('Bearer ') ? header.substring(7) : '';
    final id = _sessions[token];
    if (id == null) throw _Fail(401, 'unauthorized');
    return id;
  }

  static bool _is(List<String> s, List<String> expected) =>
      s.length == expected.length &&
      Iterable.generate(s.length).every((i) => s[i] == expected[i]);

  static Map<String, Object?> _json(FamilyHttpRequest r) =>
      r.body == null || r.body!.isEmpty
      ? {}
      : (jsonDecode(utf8.decode(r.body!)) as Map).cast<String, Object?>();

  static FamilyHttpResponse _ok(
    Map<String, Object?> json, {
    int status = 200,
  }) => FamilyHttpResponse(
    statusCode: status,
    headers: const {'content-type': 'application/json'},
    body: utf8.encode(jsonEncode({'success': true, ...json})),
  );

  static FamilyHttpResponse _error(
    int status,
    String code,
    String message, [
    Map<String, Object?> extra = const {},
  ]) => FamilyHttpResponse(
    statusCode: status,
    headers: const {'content-type': 'application/json'},
    body: utf8.encode(
      jsonEncode({
        'success': false,
        'code': code,
        'message': message,
        ...extra,
      }),
    ),
  );
}

class _Fail implements Exception {
  _Fail(this.status, this.code, [this.extra = const {}]);

  final int status;
  final String code;
  final Map<String, Object?> extra;
}

class FakeMember {
  FakeMember(this.role);

  final String role;
  String? profile;
}

class FakeFamily {
  FakeFamily({
    required this.id,
    required this.ownerId,
    required this.encryptedName,
  });

  final String id;
  final String ownerId;
  String encryptedName;
  int seq = 0;
  int membersVersion = 1;
  final Map<String, FakeMember> members = {};
  final Map<String, FakeItem> items = {};

  // Key rotation: what members' apps encrypted, never keys in the clear.
  String? keyId;
  int keyEpoch = 0;
  bool rotationRequired = false;
  final Map<String, ({String publicKey, String proof})> devices = {};
  final Map<String, String> chains = {};
  final Map<String, String> seals = {};

  /// A member left or was removed: their devices get no future keys and the
  /// owner's app rotates.
  void memberGone(String accountId) {
    devices.removeWhere((k, _) => k.startsWith('$accountId/'));
    seals.removeWhere((k, _) => k.split('/')[1] == accountId);
    rotationRequired = true;
  }

  void tombstone(FakeItem item) {
    item
      ..deleted = true
      ..bytes = Uint8List(0)
      ..version += 1
      ..seq = ++seq;
  }

  Map<String, Object?> toJson(String me) => {
    'id': id,
    'encryptedName': encryptedName,
    'ownerId': ownerId,
    'role': members[me]?.role ?? 'member',
    'cursor': '$seq',
    'membersVersion': membersVersion,
    'keyId': keyId,
    'keyEpoch': keyEpoch,
    'rotationRequired': rotationRequired,
    'memberCount': members.length,
    'usage': {
      'usedBytes': items.values.fold<int>(0, (sum, i) => sum + i.bytes.length),
      'quotaBytes': 2147483648,
    },
  };
}

class FakeItem {
  FakeItem(this.kind, this.id, this.authorId, this.createdAt)
    : updatedAt = createdAt;

  final String kind;
  final String id;
  final String authorId;
  final DateTime createdAt;
  DateTime updatedAt;
  int version = 0;
  int seq = 0;
  bool deleted = false;
  String? keyId;
  Uint8List bytes = Uint8List(0);

  Map<String, Object?> toJson() => {
    'kind': kind,
    'id': id,
    'version': version,
    'size': bytes.length,
    'authorId': authorId,
    'keyId': keyId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'deleted': deleted,
  };
}

/// Sign-in that returns a fixed "ID token" (the fake server uses it as the
/// account subject).
class FakeIdentity implements FamilyIdentityProvider {
  FakeIdentity(this.subject);

  String subject;
  int signOuts = 0;

  @override
  Future<FamilyIdentityToken> signInWithApple() async =>
      FamilyIdentityToken(idToken: subject, nonce: 'nonce');

  @override
  Future<FamilyIdentityToken> signInWithGoogle() async =>
      FamilyIdentityToken(idToken: subject);

  @override
  Future<void> signOut() async => signOuts++;
}

class FakePurchases implements FamilyPurchaseSource {
  FakePurchases([this.purchase]);

  FamilyStorePurchase? purchase;

  @override
  Future<FamilyStorePurchase?> premiumPurchase() async => purchase;
}
