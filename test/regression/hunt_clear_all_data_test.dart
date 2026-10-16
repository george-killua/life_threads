// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// Clear all data.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_draft_store.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Directory docs;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    docs = await Directory.systemTemp.createTemp('x1_docs_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => docs.path,
        );
  });
  tearDown(() async {
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  test('X1-01 clearAllData ("permanently removes all local data") must also '
      'drop the unsaved Add-memory draft', () async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final c = ProviderContainer();
    addTearDown(c.dispose);
    c.listen(memoryRepositoryProvider, (_, _) {});
    await c.read(memoryRepositoryProvider.future);

    final drafts = c.read(memoryDraftStoreProvider);
    await drafts.save(
      MemoryDraft(
        savedAt: DateTime(2026, 10, 1),
        title: 'Private diary entry',
        people: const [
          MemoryPersonDraft(
            name: 'Anna',
            relationship: 'sister',
            phone: '+49 000',
            email: 'anna@example.com',
          ),
        ],
      ),
    );
    expect(await drafts.load(), isNotNull, reason: 'precondition');

    await c.read(memoryRepositoryProvider.notifier).clearAllData();

    final after = await drafts.load();
    expect(
      after?.title,
      isNull,
      reason:
          'draft (title, people, phone, email) survives Clear All and '
          'is offered again on the next "Add memory"',
    );
  });
}
