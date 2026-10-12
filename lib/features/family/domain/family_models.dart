import '../../memories/domain/memory_category.dart';
import '../../memories/domain/memory_feeling.dart';

/// The signed-in LifeThreads account used for family walls. Personal walls
/// never need one.
class FamilyAccount {
  const FamilyAccount({
    required this.id,
    required this.termsAccepted,
    required this.requiredTermsVersion,
    required this.hasActiveSubscription,
  });

  final String id;

  /// Terms must be accepted before creating a family wall or posting.
  final bool termsAccepted;
  final String requiredTermsVersion;

  /// The server-verified Premium subscription (needed to own a family wall).
  final bool hasActiveSubscription;
}

enum FamilyRole { owner, member }

class Family {
  const Family({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.role,
    required this.memberCount,
    required this.usedBytes,
    required this.quotaBytes,
  });

  final String id;

  /// Decrypted on the device; the server only has ciphertext.
  final String name;
  final String ownerId;
  final FamilyRole role;
  final int memberCount;
  final int usedBytes;
  final int quotaBytes;
}

class FamilyMember {
  const FamilyMember({
    required this.accountId,
    required this.role,
    required this.displayName,
    required this.isBlockedByMe,
  });

  final String accountId;
  final FamilyRole role;

  /// The name the member chose for this family (encrypted on the server).
  final String displayName;
  final bool isBlockedByMe;
}

/// A memory on a family wall, decrypted. Photos are referenced by id and
/// fetched (and decrypted) separately.
class FamilyMemory {
  const FamilyMemory({
    required this.id,
    required this.familyId,
    required this.authorId,
    required this.version,
    required this.title,
    required this.description,
    required this.category,
    required this.feeling,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.locationLabel,
    required this.photoIds,
    required this.wallX,
    required this.wallY,
    required this.rotation,
    this.latitude,
    this.longitude,
    this.coverPhotoId,
  });

  final String id;
  final String familyId;
  final String authorId;
  final int version;
  final String title;
  final String description;
  final MemoryCategory category;
  final MemoryFeeling feeling;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String locationLabel;
  final double? latitude;
  final double? longitude;
  final String? coverPhotoId;
  final List<String> photoIds;
  final double wallX;
  final double wallY;
  final double rotation;
}

/// What a member fills in to add or edit a family memory. Photo files are
/// local files (e.g. from the picker); they are resized, encrypted and
/// uploaded by the service.
class FamilyMemoryDraft {
  const FamilyMemoryDraft({
    required this.title,
    required this.description,
    required this.category,
    required this.feeling,
    required this.occurredAt,
    required this.locationLabel,
    this.latitude,
    this.longitude,
    this.newPhotoPaths = const [],
    this.keptPhotoIds = const [],
    this.coverIndex = 0,
  });

  final String title;
  final String description;
  final MemoryCategory category;
  final MemoryFeeling feeling;
  final DateTime occurredAt;
  final String locationLabel;
  final double? latitude;
  final double? longitude;
  final List<String> newPhotoPaths;

  /// When editing: existing photos to keep.
  final List<String> keptPhotoIds;

  /// Index into kept photos followed by new photos.
  final int coverIndex;
}

enum FamilyReportReason {
  spam,
  harassment,
  hate,
  sexual,
  violence,
  selfHarm,
  illegal,
  privacy,
  other,
}

enum FamilyReportTarget { memory, photo, member }

enum FamilySyncStatus { idle, syncing, offline, error }

/// A user-facing failure from the family service. [code] matches the
/// server's error codes (e.g. `subscription_required`, `invite_expired`,
/// `quota_exceeded`, `terms_not_accepted`, `family_full`).
class FamilyException implements Exception {
  const FamilyException(this.code, [this.message]);

  final String code;
  final String? message;

  @override
  String toString() => message ?? code;
}
