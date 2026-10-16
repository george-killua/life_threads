// Regression: the widget's "Take photo" (lifethreads://add?camera=1) opens the
// camera for a free user at the 30-memory limit when the memories are still
// loading (cold start from the widget).
// Expected: no camera at the limit, the Premium screen instead.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/media/data/photo_library_service.dart';
import 'package:life_threads/features/media/data/picked_memory_photo.dart';
import 'package:life_threads/features/memories/data/memory_draft_store.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/presentation/pages/add_memory_page.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'wall_drag_test.dart' show ev;

final _loaded = Completer<void>();

/// 30 memories (the free limit), loaded a moment after the page opens.
class _SlowFullRepo extends MemoryRepository {
  @override
  Future<MemoryState> build() async {
    await _loaded.future;
    return MemoryState(
      events: [
        for (var i = 0; i < PremiumEntitlement.freeMemoryLimit; i++)
          ev('m$i', Offset(i * 10, 0), DateTime(2025, 1, 1)),
      ],
      connections: const [],
      photos: const [],
      people: const [],
      wallItems: const [],
    );
  }
}

class _Free extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async =>
      const PremiumEntitlement(isPremium: false, isMockUnlocked: false);
}

class _CountingCamera extends PhotoLibraryService {
  var opened = 0;

  @override
  Future<PickedMemoryPhoto?> capturePhotoToAppStorage() async {
    opened++;
    return null;
  }
}

void main() {
  testWidgets('Take photo at the free limit does not open the camera', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final camera = _CountingCamera();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoryRepositoryProvider.overrideWith(_SlowFullRepo.new),
          premiumEntitlementProvider.overrideWith(_Free.new),
          photoLibraryServiceProvider.overrideWithValue(camera),
          memoryDraftStoreProvider.overrideWithValue(
            MemoryDraftStore(documentsPath: () async => '/documents'),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AddMemoryPage(openCamera: true),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    _loaded.complete();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(camera.opened, 0, reason: 'the camera opened at the free limit');
  });
}
