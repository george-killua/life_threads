import 'dart:async';
import 'dart:io';

import 'package:life_threads/features/family/data/family_service.dart';
import 'package:life_threads/features/family/domain/family_models.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';

/// A value with a stream that replays the current value to new listeners.
class _Watched<T> {
  _Watched(this._value);

  T _value;
  final _controller = StreamController<T>.broadcast(sync: true);

  T get value => _value;

  set value(T next) {
    _value = next;
    _controller.add(next);
  }

  Stream<T> get stream {
    StreamSubscription<T>? subscription;
    late final StreamController<T> listener;
    listener = StreamController<T>(
      onListen: () {
        listener.add(_value);
        subscription = _controller.stream.listen(listener.add);
      },
      // Not returning the cancel future: a broadcast subscription's cancel
      // future completes outside the widget test's fake async zone, which
      // would stall `stream.first`.
      onCancel: () {
        subscription?.cancel();
      },
    );
    return listener.stream;
  }
}

class FakeFamily {
  FakeFamily({
    required this.id,
    required this.name,
    required this.ownerId,
    this.quotaBytes = 2 * 1024 * 1024 * 1024,
    this.usedBytes = 0,
    this.maxMembers = 10,
    this.ownerSubscriptionActive = true,
  });

  final String id;
  String name;
  final String ownerId;
  final int quotaBytes;
  int usedBytes;
  final int maxMembers;
  bool ownerSubscriptionActive;

  /// accountId -> display name, in join order.
  final members = <String, String>{};
  final memories = <FamilyMemory>[];
}

class FakeInvite {
  FakeInvite({required this.familyId, required this.expiresAt});

  final String familyId;
  final DateTime expiresAt;
  bool used = false;
  bool revoked = false;
}

/// An in-memory [FamilyService] that follows the server's rules: only the
/// author edits; the author or the owner deletes; the owner removes members
/// and cannot leave; terms before creating or posting; the owner's
/// subscription for creating, inviting and uploading; one-time invites
/// that expire; quotas; versions.
class FakeFamilyService implements FamilyService {
  FakeFamilyService({
    FamilyAccount? account,
    this.accountIdOnSignIn = 'me',
    this.termsVersion = '2026-10',
    this.subscriptionOnLink = true,
    this.bytesPerPhoto = 400 * 1024,
    DateTime Function()? clock,
  }) : _account = _Watched(account),
       _clock = clock ?? DateTime.now;

  /// A signed-in account with terms accepted and an active subscription.
  static FamilyAccount account({
    String id = 'me',
    bool termsAccepted = true,
    bool hasActiveSubscription = true,
    String termsVersion = '2026-10',
  }) => FamilyAccount(
    id: id,
    termsAccepted: termsAccepted,
    requiredTermsVersion: termsVersion,
    hasActiveSubscription: hasActiveSubscription,
  );

  final String accountIdOnSignIn;
  final String termsVersion;

  /// What [linkSubscription] finds on the store side.
  bool subscriptionOnLink;
  final int bytesPerPhoto;
  final DateTime Function() _clock;

  /// Thrown by the next sign-in, e.g. `FamilyException('sign_in_canceled')`.
  Object? signInError;

  /// Thrown once by the next [updateMemory], e.g. a version conflict.
  Object? nextUpdateError;

  /// Thrown once by the next [addMemory].
  Object? nextAddError;

  /// Every call by name, for assertions.
  final calls = <String>[];
  final reports = <Map<String, Object?>>[];
  final blocked = <String>{};
  final invites = <String, FakeInvite>{};
  final families = <String, FakeFamily>{};
  final _photoFiles = <String, File>{};

  final _Watched<FamilyAccount?> _account;
  late final _families = _Watched<List<Family>>(const []);
  final _memories = <String, _Watched<List<FamilyMemory>>>{};
  final _sync = <String, _Watched<FamilySyncStatus>>{};
  var _nextId = 1;

  FamilyAccount? get currentAccount => _account.value;
  String? get _myId => _account.value?.id;

  String _id(String prefix) => '$prefix${_nextId++}';

  // Test setup ---------------------------------------------------------------

  /// Adds a family the signed-in account belongs to.
  FakeFamily addFamily({
    String? id,
    required String name,
    String? ownerId,
    Map<String, String> members = const {},
    int quotaBytes = 2 * 1024 * 1024 * 1024,
    int usedBytes = 0,
    int maxMembers = 10,
    bool ownerSubscriptionActive = true,
  }) {
    final family = FakeFamily(
      id: id ?? _id('family-'),
      name: name,
      ownerId: ownerId ?? _myId ?? 'me',
      quotaBytes: quotaBytes,
      usedBytes: usedBytes,
      maxMembers: maxMembers,
      ownerSubscriptionActive: ownerSubscriptionActive,
    );
    family.members.addAll(members);
    families[family.id] = family;
    _emitFamilies();
    return family;
  }

  /// Puts a memory on a family wall as [authorId].
  FamilyMemory seedMemory(
    String familyId, {
    String? id,
    required String authorId,
    required String title,
    String description = '',
    List<String> photoIds = const [],
    double wallX = 0,
    double wallY = 0,
    String locationLabel = '',
    MemoryFeeling feeling = MemoryFeeling.warm,
    MemoryCategory category = MemoryCategory.family,
  }) {
    final now = DateTime(2026, 9, 1);
    final memory = FamilyMemory(
      id: id ?? _id('memory-'),
      familyId: familyId,
      authorId: authorId,
      version: 1,
      title: title,
      description: description,
      category: category,
      feeling: feeling,
      occurredAt: now,
      createdAt: now,
      updatedAt: now,
      locationLabel: locationLabel,
      photoIds: photoIds,
      coverPhotoId: photoIds.firstOrNull,
      wallX: wallX,
      wallY: wallY,
      rotation: 0,
    );
    families[familyId]!.memories.add(memory);
    _emitMemories(familyId);
    return memory;
  }

  /// A link that [acceptInvite] knows; for expired, used or full families.
  Uri addInvite(
    String familyId, {
    Duration validFor = const Duration(days: 7),
  }) {
    final token = _id('invite-');
    invites[token] = FakeInvite(
      familyId: familyId,
      expiresAt: _clock().add(validFor),
    );
    return Uri.parse(
      'https://gkcoding.dev/lifethreads/join/$token#key=secret-$familyId',
    );
  }

  /// A photo file served by [photoFile].
  void setPhotoFile(String photoId, File file) => _photoFiles[photoId] = file;

  // Account ------------------------------------------------------------------

  @override
  Stream<FamilyAccount?> watchAccount() => _account.stream;

  Future<FamilyAccount> _signIn(String method) async {
    calls.add(method);
    final error = signInError;
    if (error != null) {
      signInError = null;
      throw error;
    }
    final account = FamilyAccount(
      id: accountIdOnSignIn,
      termsAccepted: false,
      requiredTermsVersion: termsVersion,
      hasActiveSubscription: false,
    );
    _account.value = account;
    _emitFamilies();
    return account;
  }

  @override
  Future<FamilyAccount> signInWithApple() => _signIn('signInWithApple');

  @override
  Future<FamilyAccount> signInWithGoogle() => _signIn('signInWithGoogle');

  @override
  Future<void> signOut() async {
    calls.add('signOut');
    _account.value = null;
    _emitFamilies();
  }

  @override
  Future<void> deleteAccount() async {
    calls.add('deleteAccount');
    final me = _requireAccount().id;
    families.removeWhere((_, family) => family.ownerId == me);
    for (final family in families.values) {
      family.members.remove(me);
      family.memories.removeWhere((memory) => memory.authorId == me);
    }
    _account.value = null;
    _emitFamilies();
  }

  @override
  Future<FamilyAccount> acceptTerms(String version) async {
    calls.add('acceptTerms:$version');
    final account = _requireAccount();
    final next = FamilyAccount(
      id: account.id,
      termsAccepted: version == account.requiredTermsVersion,
      requiredTermsVersion: account.requiredTermsVersion,
      hasActiveSubscription: account.hasActiveSubscription,
    );
    _account.value = next;
    return next;
  }

  @override
  Future<FamilyAccount> linkSubscription() async {
    calls.add('linkSubscription');
    final account = _requireAccount();
    final next = FamilyAccount(
      id: account.id,
      termsAccepted: account.termsAccepted,
      requiredTermsVersion: account.requiredTermsVersion,
      hasActiveSubscription: subscriptionOnLink,
    );
    _account.value = next;
    return next;
  }

  FamilyAccount _requireAccount() {
    final account = _account.value;
    if (account == null) throw const FamilyException('unauthorized');
    return account;
  }

  // Families -----------------------------------------------------------------

  List<Family> _visibleFamilies() {
    final me = _myId;
    if (me == null) return const [];
    return [
      for (final family in families.values)
        if (family.ownerId == me || family.members.containsKey(me))
          _toFamily(family, me),
    ];
  }

  Family _toFamily(FakeFamily family, String me) => Family(
    id: family.id,
    name: family.name,
    ownerId: family.ownerId,
    role: family.ownerId == me ? FamilyRole.owner : FamilyRole.member,
    memberCount: _memberIds(family).length,
    usedBytes: family.usedBytes,
    quotaBytes: family.quotaBytes,
  );

  Set<String> _memberIds(FakeFamily family) => {
    family.ownerId,
    ...family.members.keys,
  };

  void _emitFamilies() => _families.value = _visibleFamilies();

  FakeFamily _familyFor(String familyId) {
    final me = _requireAccount().id;
    final family = families[familyId];
    if (family == null || !_memberIds(family).contains(me)) {
      throw const FamilyException('not_found');
    }
    return family;
  }

  @override
  Stream<List<Family>> watchFamilies() => _families.stream;

  @override
  Future<Family> createFamily(String name) async {
    calls.add('createFamily:$name');
    final account = _requireAccount();
    if (!account.termsAccepted) {
      throw const FamilyException('terms_not_accepted');
    }
    if (!account.hasActiveSubscription) {
      throw const FamilyException('subscription_required');
    }
    final family = addFamily(name: name, ownerId: account.id);
    family.members[account.id] = '';
    _emitFamilies();
    return _toFamily(family, account.id);
  }

  @override
  Future<void> renameFamily(String familyId, String name) async {
    calls.add('renameFamily:$name');
    final family = _familyFor(familyId);
    if (family.ownerId != _myId) throw const FamilyException('forbidden');
    family.name = name;
    _emitFamilies();
  }

  @override
  Future<void> deleteFamily(String familyId) async {
    calls.add('deleteFamily');
    final family = _familyFor(familyId);
    if (family.ownerId != _myId) throw const FamilyException('forbidden');
    families.remove(familyId);
    _emitFamilies();
  }

  @override
  Future<void> leaveFamily(
    String familyId, {
    bool deleteMyContent = false,
  }) async {
    calls.add('leaveFamily:$deleteMyContent');
    final family = _familyFor(familyId);
    final me = _myId!;
    if (family.ownerId == me) {
      throw const FamilyException('owner_cannot_leave');
    }
    family.members.remove(me);
    if (deleteMyContent) {
      family.memories.removeWhere((memory) => memory.authorId == me);
    }
    _emitFamilies();
    _emitMemories(familyId);
  }

  @override
  Future<List<FamilyMember>> members(String familyId) async {
    final family = _familyFor(familyId);
    return [
      for (final id in _memberIds(family))
        FamilyMember(
          accountId: id,
          role: id == family.ownerId ? FamilyRole.owner : FamilyRole.member,
          displayName: family.members[id] ?? '',
          isBlockedByMe: blocked.contains(id),
        ),
    ];
  }

  @override
  Future<void> setMyDisplayName(String familyId, String displayName) async {
    calls.add('setMyDisplayName:$displayName');
    final family = _familyFor(familyId);
    family.members[_myId!] = displayName;
  }

  @override
  Future<void> removeMember(
    String familyId,
    String accountId, {
    bool deleteContent = false,
  }) async {
    calls.add('removeMember:$accountId:$deleteContent');
    final family = _familyFor(familyId);
    if (family.ownerId != _myId || accountId == family.ownerId) {
      throw const FamilyException('forbidden');
    }
    family.members.remove(accountId);
    if (deleteContent) {
      family.memories.removeWhere((memory) => memory.authorId == accountId);
    }
    _emitFamilies();
    _emitMemories(familyId);
  }

  // Invites ------------------------------------------------------------------

  @override
  Future<Uri> createInvite(String familyId) async {
    calls.add('createInvite');
    final family = _familyFor(familyId);
    if (!family.ownerSubscriptionActive) {
      throw const FamilyException('subscription_required');
    }
    return addInvite(familyId);
  }

  @override
  bool isInviteLink(Uri link) =>
      link.host == 'gkcoding.dev' && link.path.startsWith('/lifethreads/join/');

  @override
  Future<Family> acceptInvite(Uri link) async {
    calls.add('acceptInvite');
    final me = _requireAccount().id;
    if (!isInviteLink(link)) throw const FamilyException('invite_invalid');
    final invite = invites[link.pathSegments.last];
    if (invite == null) throw const FamilyException('invite_invalid');
    final family = families[invite.familyId];
    if (family == null) throw const FamilyException('invite_invalid');
    if (invite.revoked) throw const FamilyException('invite_revoked');
    // Already a member (e.g. a new phone): the link restores the key.
    if (_memberIds(family).contains(me)) return _toFamily(family, me);
    if (invite.used) throw const FamilyException('invite_used');
    if (_clock().isAfter(invite.expiresAt)) {
      throw const FamilyException('invite_expired');
    }
    if (_memberIds(family).length >= family.maxMembers) {
      throw const FamilyException('family_full');
    }
    invite.used = true;
    family.members[me] = '';
    _emitFamilies();
    return _toFamily(family, me);
  }

  // Memories -----------------------------------------------------------------

  _Watched<List<FamilyMemory>> _memoriesOf(String familyId) =>
      _memories.putIfAbsent(
        familyId,
        () => _Watched(List.of(families[familyId]?.memories ?? const [])),
      );

  void _emitMemories(String familyId) {
    _memoriesOf(familyId).value = List.of(
      families[familyId]?.memories ?? const [],
    );
  }

  @override
  Stream<List<FamilyMemory>> watchMemories(String familyId) =>
      _memoriesOf(familyId).stream;

  @override
  Stream<FamilySyncStatus> watchSyncStatus(String familyId) =>
      _sync.putIfAbsent(familyId, () => _Watched(FamilySyncStatus.idle)).stream;

  @override
  Future<void> sync(String familyId) async {
    calls.add('sync');
    _emitMemories(familyId);
  }

  void _checkPosting(FakeFamily family, int newPhotos) {
    final account = _requireAccount();
    if (!account.termsAccepted) {
      throw const FamilyException('terms_not_accepted');
    }
    if (!family.ownerSubscriptionActive) {
      throw const FamilyException('subscription_required');
    }
    if (family.usedBytes + newPhotos * bytesPerPhoto > family.quotaBytes) {
      throw const FamilyException('quota_exceeded');
    }
  }

  @override
  Future<FamilyMemory> addMemory(
    String familyId,
    FamilyMemoryDraft draft,
  ) async {
    calls.add('addMemory:${draft.title}');
    final error = nextAddError;
    if (error != null) {
      nextAddError = null;
      throw error;
    }
    final family = _familyFor(familyId);
    _checkPosting(family, draft.newPhotoPaths.length);
    family.usedBytes += draft.newPhotoPaths.length * bytesPerPhoto;
    final photoIds = [
      for (var i = 0; i < draft.newPhotoPaths.length; i++) _id('photo-'),
    ];
    final now = _clock();
    final memory = FamilyMemory(
      id: _id('memory-'),
      familyId: familyId,
      authorId: _myId!,
      version: 1,
      title: draft.title,
      description: draft.description,
      category: draft.category,
      feeling: draft.feeling,
      occurredAt: draft.occurredAt,
      createdAt: now,
      updatedAt: now,
      locationLabel: draft.locationLabel,
      latitude: draft.latitude,
      longitude: draft.longitude,
      photoIds: photoIds,
      coverPhotoId: photoIds.firstOrNull,
      wallX: family.memories.length * 240.0,
      wallY: 0,
      rotation: 0,
    );
    family.memories.add(memory);
    _emitFamilies();
    _emitMemories(familyId);
    return memory;
  }

  @override
  Future<FamilyMemory> updateMemory(
    FamilyMemory memory,
    FamilyMemoryDraft draft,
  ) async {
    calls.add('updateMemory:${memory.version}:${draft.title}');
    final error = nextUpdateError;
    if (error != null) {
      nextUpdateError = null;
      throw error;
    }
    final family = _familyFor(memory.familyId);
    final index = family.memories.indexWhere((m) => m.id == memory.id);
    if (index < 0) throw const FamilyException('not_found');
    final stored = family.memories[index];
    if (stored.authorId != _myId) throw const FamilyException('not_author');
    if (stored.version != memory.version) {
      throw const FamilyException('version_conflict');
    }
    _checkPosting(family, draft.newPhotoPaths.length);
    family.usedBytes += draft.newPhotoPaths.length * bytesPerPhoto;
    final photoIds = [
      ...draft.keptPhotoIds,
      for (var i = 0; i < draft.newPhotoPaths.length; i++) _id('photo-'),
    ];
    final updated = FamilyMemory(
      id: stored.id,
      familyId: stored.familyId,
      authorId: stored.authorId,
      version: stored.version + 1,
      title: draft.title,
      description: draft.description,
      category: draft.category,
      feeling: draft.feeling,
      occurredAt: draft.occurredAt,
      createdAt: stored.createdAt,
      updatedAt: _clock(),
      locationLabel: draft.locationLabel,
      latitude: draft.latitude,
      longitude: draft.longitude,
      photoIds: photoIds,
      coverPhotoId: photoIds.isEmpty
          ? null
          : photoIds[draft.coverIndex.clamp(0, photoIds.length - 1)],
      wallX: stored.wallX,
      wallY: stored.wallY,
      rotation: stored.rotation,
    );
    family.memories[index] = updated;
    _emitMemories(memory.familyId);
    return updated;
  }

  /// Simulates someone else's device editing [memoryId] (bumps the version).
  void bumpVersion(String familyId, String memoryId, {String? title}) {
    final family = families[familyId]!;
    final index = family.memories.indexWhere((m) => m.id == memoryId);
    final stored = family.memories[index];
    family.memories[index] = FamilyMemory(
      id: stored.id,
      familyId: stored.familyId,
      authorId: stored.authorId,
      version: stored.version + 1,
      title: title ?? stored.title,
      description: stored.description,
      category: stored.category,
      feeling: stored.feeling,
      occurredAt: stored.occurredAt,
      createdAt: stored.createdAt,
      updatedAt: stored.updatedAt,
      locationLabel: stored.locationLabel,
      photoIds: stored.photoIds,
      coverPhotoId: stored.coverPhotoId,
      wallX: stored.wallX,
      wallY: stored.wallY,
      rotation: stored.rotation,
    );
  }

  @override
  Future<void> moveMemory(
    FamilyMemory memory,
    double wallX,
    double wallY,
  ) async {
    calls.add('moveMemory:${memory.id}');
    final family = _familyFor(memory.familyId);
    if (memory.authorId != _myId) throw const FamilyException('not_author');
    final index = family.memories.indexWhere((m) => m.id == memory.id);
    final stored = family.memories[index];
    family.memories[index] = FamilyMemory(
      id: stored.id,
      familyId: stored.familyId,
      authorId: stored.authorId,
      version: stored.version + 1,
      title: stored.title,
      description: stored.description,
      category: stored.category,
      feeling: stored.feeling,
      occurredAt: stored.occurredAt,
      createdAt: stored.createdAt,
      updatedAt: stored.updatedAt,
      locationLabel: stored.locationLabel,
      photoIds: stored.photoIds,
      coverPhotoId: stored.coverPhotoId,
      wallX: wallX,
      wallY: wallY,
      rotation: stored.rotation,
    );
    _emitMemories(memory.familyId);
  }

  @override
  Future<void> deleteMemory(FamilyMemory memory) async {
    calls.add('deleteMemory:${memory.id}');
    final family = _familyFor(memory.familyId);
    final me = _myId;
    if (memory.authorId != me && family.ownerId != me) {
      throw const FamilyException('forbidden');
    }
    family.memories.removeWhere((m) => m.id == memory.id);
    _emitMemories(memory.familyId);
  }

  @override
  Future<File> photoFile(String familyId, String photoId) async {
    final file = _photoFiles[photoId];
    if (file == null) throw const FamilyException('not_found');
    return file;
  }

  // Moderation ---------------------------------------------------------------

  @override
  Future<void> report({
    required String familyId,
    required FamilyReportTarget target,
    required String targetId,
    required FamilyReportReason reason,
    String? details,
  }) async {
    calls.add('report:${target.name}:$targetId:${reason.name}');
    _familyFor(familyId);
    reports.add({
      'familyId': familyId,
      'target': target,
      'targetId': targetId,
      'reason': reason,
      'details': details,
    });
  }

  @override
  Future<void> block(String accountId) async {
    calls.add('block:$accountId');
    blocked.add(accountId);
  }

  @override
  Future<void> unblock(String accountId) async {
    calls.add('unblock:$accountId');
    blocked.remove(accountId);
  }
}
