import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/logging/app_logger.dart';
import '../data/family_service.dart';
import '../domain/family_models.dart';

/// The family service, or null when this build has none. Screens read this
/// instead of [familyServiceProvider] so a missing or failing service shows
/// a message instead of crashing; nothing reads it before the user opens a
/// family feature (or a family wall was used before, see
/// [familyWallsActiveProvider]).
final familyServiceOrNullProvider = Provider<FamilyService?>((ref) {
  try {
    return ref.watch(familyServiceProvider);
  } catch (error) {
    AppLogger.event('family_service_unavailable');
    return null;
  }
});

// Streams from the service fail fast in the UI; the service retries itself.
Duration? _noRetry(int retryCount, Object error) => null;

final familyAccountProvider = StreamProvider<FamilyAccount?>((ref) {
  final service = ref.watch(familyServiceOrNullProvider);
  if (service == null) return Stream.value(null);
  return service.watchAccount();
}, retry: _noRetry);

final familiesProvider = StreamProvider<List<Family>>((ref) {
  final service = ref.watch(familyServiceOrNullProvider);
  if (service == null) return Stream.value(const []);
  return service.watchFamilies();
}, retry: _noRetry);

/// One family from [familiesProvider], or null when it is gone (left,
/// deleted, removed).
final familyProvider = Provider.family<AsyncValue<Family?>, String>((
  ref,
  familyId,
) {
  return ref
      .watch(familiesProvider)
      .whenData(
        (families) => families.where((f) => f.id == familyId).firstOrNull,
      );
});

final familyMemoriesProvider =
    StreamProvider.family<List<FamilyMemory>, String>((ref, familyId) {
      final service = ref.watch(familyServiceOrNullProvider);
      if (service == null) return Stream.value(const []);
      return service.watchMemories(familyId);
    }, retry: _noRetry);

final familySyncStatusProvider =
    StreamProvider.family<FamilySyncStatus, String>((ref, familyId) {
      final service = ref.watch(familyServiceOrNullProvider);
      if (service == null) return Stream.value(FamilySyncStatus.offline);
      return service.watchSyncStatus(familyId);
    }, retry: _noRetry);

/// Members of a family; invalidate after changing members or blocks.
final familyMembersProvider = FutureProvider.autoDispose
    .family<List<FamilyMember>, String>((ref, familyId) async {
      final service = ref.watch(familyServiceOrNullProvider);
      if (service == null) return const [];
      return service.members(familyId);
    }, retry: _noRetry);

/// A decrypted family photo as a local file.
final familyPhotoProvider = FutureProvider.autoDispose
    .family<File, ({String familyId, String photoId})>((ref, photo) {
      final service = ref.watch(familyServiceOrNullProvider);
      if (service == null) {
        throw const FamilyException('service_unavailable');
      }
      return service.photoFile(photo.familyId, photo.photoId);
    }, retry: _noRetry);

/// Opens the system share sheet; replaced in tests.
final familyShareSheetProvider =
    Provider<Future<ShareResult> Function(ShareParams params)>(
      (ref) => SharePlus.instance.share,
    );

/// Whether this device has used family walls (signed in for them). Until
/// then the personal wall never touches the family service, so it shows no
/// wall switcher and makes no network calls.
final familyWallsActiveProvider =
    AsyncNotifierProvider<FamilyWallsActiveController, bool>(
      FamilyWallsActiveController.new,
    );

class FamilyWallsActiveController extends AsyncNotifier<bool> {
  static const _key = 'family_walls_active';

  @override
  Future<bool> build() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getBool(_key) ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> setActive(bool active) async {
    state = AsyncData(active);
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(_key, active);
    } catch (_) {
      // Only a hint for the wall header; the next sign-in sets it again.
    }
  }
}

/// The family walls the wall switcher offers: empty unless family walls
/// were used on this device.
final switchableFamiliesProvider = Provider<List<Family>>((ref) {
  final active = ref.watch(familyWallsActiveProvider).asData?.value ?? false;
  if (!active) return const [];
  return ref.watch(familiesProvider).asData?.value ?? const [];
});
