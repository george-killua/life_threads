// Memory detail page: localization and share progress handling.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/backup/domain/backup_models.dart';
import 'package:life_threads/features/capsule/data/memory_capsule_service.dart';
import 'package:life_threads/features/capsule/domain/memory_capsule_models.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/memories/presentation/pages/memory_detail_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

final event = MemoryEvent(
  id: 'm1',
  title: 'Picnic',
  description: 'Story',
  category: MemoryCategory.travel,
  memoryType: MemoryType.trip,
  feeling: MemoryFeeling.calm,
  occurredAt: DateTime(2024, 6, 12),
  createdAt: DateTime(2024, 6, 12),
  coverColor: const Color(0xFFD2A24A),
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: '',
);

class FakeRepo extends MemoryRepository {
  @override
  Future<MemoryState> build() async => MemoryState(
    events: [event],
    connections: const [],
    photos: const [],
    people: const [],
    wallItems: const [],
  );
}

class SlowFailingCapsuleService extends MemoryCapsuleService {
  SlowFailingCapsuleService(this.gate);
  final Completer<void> gate;
  @override
  Future<MemoryCapsuleExportResult> exportCapsule({
    required MemoryState state,
    required String memoryId,
    String? password,
  }) async {
    await gate.future;
    throw const BackupValidationException('boom');
  }
}

Widget app({
  Locale locale = const Locale('en'),
  List<Override> overrides = const [],
}) => ProviderScope(
  overrides: [
    memoryRepositoryProvider.overrideWith(FakeRepo.new),
    ...overrides,
  ],
  child: MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MemoryDetailPage(memoryId: 'm1'),
              ),
            ),
            child: const Text('HOME'),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('detail page in German must not show English date/labels', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    await tester.pumpWidget(app(locale: const Locale('de')));
    await tester.tap(find.text('HOME'));
    await tester.pumpAndSettle();
    final texts = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .toList();
    final english = texts
        .where((t) => t.contains('Jun 12, 2024') || t.contains('Calm Trip'))
        .toList();
    expect(
      english,
      isEmpty,
      reason: 'English strings rendered under de locale: $english',
    );
  });

  testWidgets(
    'back during share progress does not close the dialog or the page',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      final gate = Completer<void>();
      await tester.pumpWidget(
        app(
          overrides: [
            memoryCapsuleServiceProvider.overrideWithValue(
              SlowFailingCapsuleService(gate),
            ),
          ],
        ),
      );
      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Share Memory Capsule').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'secret-pass');
      await tester.tap(find.text('Create Secure Share'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find
                .text('Creating secure memory link...', skipOffstage: false)
                .evaluate()
                .length +
            find.byType(AlertDialog).evaluate().length,
        greaterThan(0),
        reason: 'progress dialog up',
      );
      await tester.binding.handlePopRoute(); // Android system back
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Creating secure memory link...'), findsOneWidget);
      gate.complete();
      await tester.pumpAndSettle();
      expect(find.byType(MemoryDetailPage), findsOneWidget);
      expect(find.text('Creating secure memory link...'), findsNothing);
    },
  );

  testWidgets('confirming the share password dialog must not throw', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    await tester.pumpWidget(
      app(
        overrides: [
          memoryCapsuleServiceProvider.overrideWithValue(
            SlowFailingCapsuleService(Completer<void>()),
          ),
        ],
      ),
    );
    await tester.tap(find.text('HOME'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share Memory Capsule').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'secret-pass');
    await tester.tap(find.text('Create Secure Share'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
