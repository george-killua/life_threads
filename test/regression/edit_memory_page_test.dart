// Edit memory page and people editor.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_photo.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/memories/presentation/pages/edit_memory_page.dart';
import 'package:life_threads/features/memories/presentation/widgets/memory_people_editor.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

MemoryEvent _event({
  String? cover,
  String label = "Grandma's house",
  double? lat = 48.3069,
  double? lng = 14.2858,
}) => MemoryEvent(
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
  locationLabel: label,
  latitude: lat,
  longitude: lng,
  coverPhotoPath: cover,
);

MemoryPhoto _photo(String path) => MemoryPhoto(
  id: path,
  eventId: 'm1',
  localPath: path,
  capturedAt: DateTime(2024, 11, 4),
  width: 10,
  height: 10,
);

class FakeEditRepo extends MemoryRepository {
  FakeEditRepo(this.initial, {this.fail = false});
  final MemoryState initial;
  final bool fail;
  Map<String, Object?>? saved;
  @override
  Future<MemoryState> build() async => initial;
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
  }) async {
    if (fail) throw StateError('database is locked');
    saved = {
      'locationLabel': locationLabel,
      'latitude': latitude,
      'longitude': longitude,
      'cover': coverPhotoPath,
    };
  }
}

late FakeEditRepo repo;

Future<void> _pumpEdit(
  WidgetTester tester,
  MemoryState s, {
  bool fail = false,
}) async {
  tester.view.physicalSize = const Size(1200, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  repo = FakeEditRepo(s, fail: fail);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [memoryRepositoryProvider.overrideWith(() => repo)],
      child: MaterialApp.router(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          initialLocation: '/',
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
}

Future<void> _tapSave(WidgetTester tester) async {
  await tester.tap(find.text('Save memory'));
  await tester.pump();
  await tester.pump();
}

MemoryState _state(MemoryEvent e, [List<MemoryPhoto> photos = const []]) =>
    MemoryState(
      events: [e],
      connections: const [],
      photos: photos,
      people: const [],
      wallItems: const [],
    );

void main() {
  testWidgets('saving an untouched edit keeps the location label and '
      'coordinates', (tester) async {
    await _pumpEdit(tester, _state(_event()));
    await _tapSave(tester);
    expect(repo.saved!['locationLabel'], "Grandma's house");
    expect(repo.saved!['latitude'], 48.3069);
  });

  testWidgets('saving an untouched edit keeps a cover that is not one '
      'of the gallery rows (demo / asset cover)', (tester) async {
    const cover = 'assets/demo_people/linz_rain_coffee.jpg';
    await _pumpEdit(tester, _state(_event(cover: cover)));
    await _tapSave(tester);
    expect(repo.saved!['cover'], cover);
  });

  testWidgets('clearing the cover (X) and saving leaves no cover', (
    tester,
  ) async {
    await _pumpEdit(
      tester,
      _state(_event(cover: '/x/b.jpg'), [
        _photo('/x/a.jpg'),
        _photo('/x/b.jpg'),
      ]),
    );
    await tester.tap(find.byIcon(Icons.close_rounded).first);
    await tester.pumpAndSettle();
    await _tapSave(tester);
    expect(repo.saved!['cover'], isNull);
  });

  testWidgets('a failed save re-enables the Save button', (tester) async {
    await _pumpEdit(tester, _state(_event()), fail: true);
    await _tapSave(tester);
    expect(tester.takeException(), isNull);
    expect(
      find.text('Could not save this memory. Please try again.'),
      findsOneWidget,
    );
    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('Save memory'),
        matching: find.bySubtype<ButtonStyleButton>(),
      ),
    );
    expect(
      button.onPressed,
      isNotNull,
      reason: 'Save stuck disabled (spinner)',
    );
  });

  testWidgets('saving the person dialog does not use disposed '
      'controllers during the dialog exit animation', (tester) async {
    var people = <MemoryPersonDraft>[];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => MemoryPeopleEditor(
              people: people,
              onChanged: (p) => setState(() => people = p),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Add person'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Anna');
    await tester.enterText(find.byType(TextField).at(1), 'Sister');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(people.single.name, 'Anna');
  });
}
