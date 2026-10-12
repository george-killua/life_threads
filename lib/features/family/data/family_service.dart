import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/family_models.dart';

/// Everything the family wall screens need: account, families, invites,
/// end-to-end encrypted memories and photos, and moderation. Talks to the
/// family API on lifethreads.gkcoding.dev; each family's key stays on the
/// device (secure storage) and travels only inside invite links.
final familyServiceProvider = Provider<FamilyService>(
  (ref) => throw UnimplementedError('FamilyService is not implemented yet.'),
);

abstract interface class FamilyService {
  // Account ------------------------------------------------------------------

  /// Emits the signed-in account, or null when signed out.
  Stream<FamilyAccount?> watchAccount();

  Future<FamilyAccount> signInWithApple();
  Future<FamilyAccount> signInWithGoogle();
  Future<void> signOut();

  /// Deletes the account and everything it owns on the server, and the
  /// local family data and keys.
  Future<void> deleteAccount();

  Future<FamilyAccount> acceptTerms(String version);

  /// Sends the store purchase of the Premium subscription to the server so
  /// it can verify it; required before creating a family wall.
  Future<FamilyAccount> linkSubscription();

  // Families -----------------------------------------------------------------

  Stream<List<Family>> watchFamilies();
  Future<Family> createFamily(String name);
  Future<void> renameFamily(String familyId, String name);
  Future<void> deleteFamily(String familyId);
  Future<void> leaveFamily(String familyId, {bool deleteMyContent = false});
  Future<List<FamilyMember>> members(String familyId);
  Future<void> setMyDisplayName(String familyId, String displayName);
  Future<void> removeMember(
    String familyId,
    String accountId, {
    bool deleteContent = false,
  });

  // Invites ------------------------------------------------------------------

  /// A link that carries the invite token and the family key (in the URL
  /// fragment, which never reaches the server).
  Future<Uri> createInvite(String familyId);

  /// Whether [link] is a family invite link this app can accept.
  bool isInviteLink(Uri link);

  /// Joins the family in [link] and stores its key.
  Future<Family> acceptInvite(Uri link);

  // Memories -----------------------------------------------------------------

  /// The family's memories from the local cache, updated as sync runs.
  Stream<List<FamilyMemory>> watchMemories(String familyId);

  Stream<FamilySyncStatus> watchSyncStatus(String familyId);

  /// Fetches changes since the last sync.
  Future<void> sync(String familyId);

  Future<FamilyMemory> addMemory(String familyId, FamilyMemoryDraft draft);

  /// Only the author can edit. Throws `version_conflict` when someone else
  /// changed it first; sync and retry.
  Future<FamilyMemory> updateMemory(
    FamilyMemory memory,
    FamilyMemoryDraft draft,
  );

  /// Moves a card on the family wall (author only).
  Future<void> moveMemory(FamilyMemory memory, double wallX, double wallY);

  /// The author or the family owner can delete.
  Future<void> deleteMemory(FamilyMemory memory);

  /// The decrypted photo as a cached local file.
  Future<File> photoFile(String familyId, String photoId);

  // Moderation ---------------------------------------------------------------

  Future<void> report({
    required String familyId,
    required FamilyReportTarget target,
    required String targetId,
    required FamilyReportReason reason,
    String? details,
  });

  Future<void> block(String accountId);
  Future<void> unblock(String accountId);
}
