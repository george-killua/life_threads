import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_threads/app/router/route_names.dart';
import 'package:life_threads/features/look_back/data/look_back_providers.dart';
import 'package:life_threads/features/look_back/domain/month_look_back.dart';
import 'package:life_threads/features/look_back/presentation/look_back_wall_card.dart';
import 'package:life_threads/features/look_back/presentation/month_look_back_page.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_person.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_notifications.dart';
import 'package:life_threads/features/year_thread/data/year_thread_providers.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/on_this_day_fakes.dart';

MemoryPerson _person(String eventId, String name) => MemoryPerson(
  id: '$eventId-$name',
  eventId: eventId,
  name: name,
  relationship: 'Friend',
);

final _events = [
  memory('aug', DateTime(2026, 8, 30)),
  memory(
    'sep-late',
    DateTime(2026, 9, 28),
  ).copyWith(locationLabel: 'Split, Croatia', latitude: 43.5, longitude: 16.4),
  memory('sep-early', DateTime(2026, 9, 2)),
  memory('sep-hidden', DateTime(2026, 9, 10)).copyWith(hidden: true),
  memory('oct', DateTime(2026, 10, 3)),
];

final _state = MemoryState(
  events: _events,
  connections: const [],
  photos: const [],
  people: [
    _person('sep-early', 'Mia'),
    _person('sep-late', 'mia'),
    _person('sep-late', 'Ben'),
    _person('sep-hidden', 'Secret'),
    _person('aug', 'Ana'),
  ],
  wallItems: const [],
);

class _Repo extends MemoryRepository {
  @override
  Future<MemoryState> build() async => _state;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('MonthLookBack', () {
    test('collects a month: memories in order, people, places', () {
      final september = MonthLookBack.of(2026, 9, _state);
      expect(september.memories.map((e) => e.id), ['sep-early', 'sep-late']);
      // Mia is in two memories; the hidden memory's people stay out.
      expect(september.people, ['Mia', 'Ben']);
      expect(september.places, ['Split, Croatia']);
      expect(MonthLookBack.of(2026, 7, _state).isEmpty, isTrue);
    });

    test('the card month is the one before, in the first week', () {
      expect(MonthLookBack.cardMonth(DateTime(2026, 10, 1)), (
        year: 2026,
        month: 9,
      ));
      expect(MonthLookBack.cardMonth(DateTime(2026, 10, 7, 23)), (
        year: 2026,
        month: 9,
      ));
      expect(MonthLookBack.cardMonth(DateTime(2026, 10, 8)), isNull);
      expect(MonthLookBack.cardMonth(DateTime(2027, 1, 3)), (
        year: 2026,
        month: 12,
      ));
    });
  });

  test('notification payload round trip', () {
    final payload = LocalOnThisDayNotifications.lookBackPayloadFor(2026, 9);
    expect(LocalOnThisDayNotifications.lookBackFromPayload(payload), (
      year: 2026,
      month: 9,
    ));
    expect(LocalOnThisDayNotifications.memoryIdFromPayload(payload), isNull);
    expect(
      LocalOnThisDayNotifications.lookBackFromPayload(
        LocalOnThisDayNotifications.payloadFor('x'),
      ),
      isNull,
    );
  });

  ProviderContainer container(DateTime now) {
    final c = ProviderContainer(
      overrides: [
        memoryRepositoryProvider.overrideWith(_Repo.new),
        lookBackClockProvider.overrideWithValue(() => now),
        yearThreadClockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<MonthLookBack?> card(ProviderContainer c) async {
    await c.read(memoryRepositoryProvider.future);
    await c.read(lookBackCardDismissalProvider.future);
    return c.read(lookBackWallCardProvider);
  }

  test('wall card: first week only, until dismissed', () async {
    final early = container(DateTime(2026, 10, 2));
    expect((await card(early))?.month, 9);

    await early.read(lookBackCardDismissalProvider.notifier).dismiss(2026, 9);
    expect(early.read(lookBackWallCardProvider), isNull);

    expect(await card(container(DateTime(2026, 10, 9))), isNull);
    // July has no memories.
    expect(await card(container(DateTime(2026, 8, 1))), isNull);
  });

  Widget app(Widget child) => ProviderScope(
    overrides: [
      memoryRepositoryProvider.overrideWith(_Repo.new),
      lookBackClockProvider.overrideWithValue(() => DateTime(2026, 10, 2)),
      yearThreadClockProvider.overrideWithValue(() => DateTime(2026, 10, 2)),
    ],
    child: MaterialApp.router(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(body: Center(child: child)),
          ),
          GoRoute(
            path: RouteNames.lookBack,
            builder: (_, state) => MonthLookBackPage(
              year: int.tryParse(state.uri.queryParameters['year'] ?? ''),
              month: int.tryParse(state.uri.queryParameters['month'] ?? ''),
            ),
          ),
        ],
      ),
    ),
  );

  testWidgets('the card opens the month; arrows move between months', (
    tester,
  ) async {
    await tester.pumpWidget(app(const LookBackWallCard()));
    await tester.pumpAndSettle();
    expect(find.text('Your month in memories'), findsOneWidget);
    expect(find.text('September: 2 memories'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('look-back-wall-card')));
    await tester.pumpAndSettle();
    expect(find.text('Your September 2026'), findsOneWidget);
    expect(find.text('2 memories'), findsOneWidget);
    expect(find.text('2 people'), findsOneWidget);
    expect(find.text('Memory sep-early'), findsOneWidget);
    expect(find.text('Memory sep-hidden'), findsNothing);
    expect(find.text('Mia'), findsOneWidget);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();
    expect(find.text('Your August 2026'), findsOneWidget);
    expect(find.text('Memory aug'), findsOneWidget);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing saved from July 2026 yet.'), findsOneWidget);
    expect(find.text('Add a memory'), findsOneWidget);
  });

  testWidgets('no month after the current one', (tester) async {
    await tester.pumpWidget(app(const SizedBox()));
    GoRouter.of(
      tester.element(find.byType(SizedBox).first),
    ).push(RouteNames.lookBackFor(2026, 10));
    await tester.pumpAndSettle();
    expect(find.text('Your October 2026'), findsOneWidget);
    final next = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.chevron_right_rounded),
        matching: find.byType(IconButton),
      ),
    );
    expect(next.onPressed, isNull);
  });
}
