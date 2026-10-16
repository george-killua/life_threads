// Regression tests from the 2026-10-16 whole-codebase bug hunt:
// edit memory (FakeEditRepo setup from edit_memory_page_test.dart).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/place_names.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_photo.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/memories/presentation/pages/edit_memory_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

MemoryEvent _event({double? lat, double? lng}) => MemoryEvent(
  id: 'm1',
  title: 'Rainy coffee',
  description: 'Story',
  category: MemoryCategory.personal,
  memoryType: MemoryType.moment,
  feeling: MemoryFeeling.warm,
  occurredAt: DateTime(2024, 11, 4),
  createdAt: DateTime(2024, 11, 4),
  coverColor: Colors.blue,
  wallPosition: Offset.zero,
  rotation: 0,
  locationLabel: "Grandma's house",
  latitude: lat,
  longitude: lng,
);

MemoryState _state(
  List<MemoryEvent> events, [
  List<MemoryPhoto> p = const [],
]) => MemoryState(
  events: events,
  connections: const [],
  photos: p,
  people: const [],
  wallItems: const [],
);

class _Repo extends MemoryRepository {
  _Repo(this.initial);
  final MemoryState initial;
  String? savedLabel;
  @override
  Future<MemoryState> build() async => initial;
  void replace(MemoryState s) => state = AsyncData(s);
  @override
  Future<void> updateMemory({
    required String id,
    required String title,
    required String description,
    required MemoryCategory category,
    required MemoryType memoryType,
    required MemoryFeeling feeling,
    required DateTime occurredAt,
    required String locationLabel,
    double? latitude,
    double? longitude,
    String? coverPhotoPath,
    List<MemoryPhotoDraft>? photos,
    List<MemoryPersonDraft>? people,
  }) async => savedLabel = locationLabel;
}

class _Lookup implements PlaceNameLookup {
  @override
  Future<String?> nameFor(double latitude, double longitude, Locale l) async =>
      'Linz, Austria';
}

Future<_Repo> _pumpEdit(WidgetTester tester, MemoryState s) async {
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final repo = _Repo(s);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        memoryRepositoryProvider.overrideWith(() => repo),
        placeNameLookupProvider.overrideWithValue(_Lookup()),
      ],
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(body: Text('WALL')),
            ),
            GoRoute(
              path: '/edit',
              builder: (_, _) => const EditMemoryPage(memoryId: 'm1'),
            ),
          ],
        )..push('/edit'),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

void main() {
  testWidgets('M2-03 memory removed while editing: Save does not throw', (
    tester,
  ) async {
    final repo = await _pumpEdit(tester, _state([_event()]));
    await tester.enterText(find.byType(TextFormField).first, 'Edited');
    await tester.pump();
    // e.g. a family-wall sync or another screen deleted it meanwhile.
    repo.replace(_state(const []));
    await tester.pump();
    expect(find.text('Memory not found'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('top-bar-save')));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('M2-04 a named place without coordinates survives an edit '
      'when a photo has GPS', (tester) async {
    final photo = MemoryPhoto(
      id: 'p1',
      eventId: 'm1',
      localPath: '/x/a.jpg',
      capturedAt: DateTime(2024, 11, 4),
      width: 10,
      height: 10,
      latitude: 48.3,
      longitude: 14.28,
    );
    final repo = await _pumpEdit(tester, _state([_event()], [photo]));
    await tester.enterText(find.byType(TextFormField).first, 'Typo fixed');
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('top-bar-save')));
    await tester.pumpAndSettle();
    expect(repo.savedLabel, "Grandma's house");
  });
}
