import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../domain/memory_category.dart';
import '../domain/memory_connection.dart';
import '../domain/memory_event.dart';
import '../domain/memory_feeling.dart';
import '../domain/memory_person.dart';
import '../domain/memory_type.dart';

/// The demo wall new users can preview: the nine moments, threads and people
/// shown in the store screenshots (tool/store_screenshots uses this data
/// too). Photos are bundled in assets/demo_moments/.
class MemorySeedData {
  const MemorySeedData._();

  static const _photos = 'assets/demo_moments';

  static final events = localizedEvents(
    lookupAppLocalizations(const Locale('en')),
  );

  static AppLocalizations localizationsForLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.any(
      (supported) => supported.languageCode == locale.languageCode,
    )) {
      return lookupAppLocalizations(const Locale('en'));
    }
    return lookupAppLocalizations(locale);
  }

  static List<MemoryEvent> localizedEvents(AppLocalizations l10n) {
    return [
      MemoryEvent(
        id: 'demo-first-dance',
        title: l10n.demoFirstDanceTitle,
        description: l10n.demoFirstDanceStory,
        category: MemoryCategory.family,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime(2023, 6, 17),
        createdAt: DateTime(2023, 6, 17),
        coverColor: const Color(0xFFD2A24A),
        wallPosition: const Offset(0, 0),
        rotation: -0.04,
        locationLabel: l10n.demoFirstDancePlace,
        latitude: 47.8095,
        longitude: 13.0550,
        coverPhotoPath: '$_photos/first_dance.jpg',
      ),
      MemoryEvent(
        id: 'demo-newborn',
        title: l10n.demoNewbornTitle,
        description: l10n.demoNewbornStory,
        category: MemoryCategory.family,
        memoryType: MemoryType.person,
        feeling: MemoryFeeling.important,
        occurredAt: DateTime(2024, 9, 2),
        createdAt: DateTime(2024, 9, 2),
        coverColor: const Color(0xFFE59A8D),
        wallPosition: const Offset(240, 70),
        rotation: 0.035,
        locationLabel: l10n.demoNewbornPlace,
        latitude: 48.2082,
        longitude: 16.3738,
        coverPhotoPath: '$_photos/newborn.jpg',
      ),
      MemoryEvent(
        id: 'demo-beach-sunset',
        title: l10n.demoBeachSunsetTitle,
        description: l10n.demoBeachSunsetStory,
        category: MemoryCategory.travel,
        memoryType: MemoryType.trip,
        feeling: MemoryFeeling.calm,
        occurredAt: DateTime(2025, 7, 26),
        createdAt: DateTime(2025, 7, 26),
        coverColor: const Color(0xFF8EA7C6),
        wallPosition: const Offset(470, -10),
        rotation: -0.03,
        locationLabel: l10n.demoBeachSunsetPlace,
        latitude: 43.5081,
        longitude: 16.4402,
        coverPhotoPath: '$_photos/beach_sunset.jpg',
      ),
      MemoryEvent(
        id: 'demo-grandma-kitchen',
        title: l10n.demoGrandmaKitchenTitle,
        description: l10n.demoGrandmaKitchenStory,
        category: MemoryCategory.family,
        memoryType: MemoryType.person,
        feeling: MemoryFeeling.nostalgic,
        occurredAt: DateTime(2025, 3, 9),
        createdAt: DateTime(2025, 3, 9),
        coverColor: const Color(0xFFA7BD92),
        wallPosition: const Offset(20, 330),
        rotation: 0.045,
        locationLabel: l10n.demoGrandmaKitchenPlace,
        latitude: 47.0707,
        longitude: 15.4395,
        coverPhotoPath: '$_photos/grandma_kitchen.jpg',
      ),
      MemoryEvent(
        id: 'demo-graduation',
        title: l10n.demoGraduationTitle,
        description: l10n.demoGraduationStory,
        category: MemoryCategory.personal,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.proud,
        occurredAt: DateTime(2022, 10, 7),
        createdAt: DateTime(2022, 10, 7),
        coverColor: const Color(0xFFF2C86B),
        wallPosition: const Offset(260, 390),
        rotation: -0.05,
        locationLabel: l10n.demoGraduationPlace,
        latitude: 47.2692,
        longitude: 11.4041,
        coverPhotoPath: '$_photos/graduation.jpg',
      ),
      MemoryEvent(
        id: 'demo-first-home',
        title: l10n.demoFirstHomeTitle,
        description: l10n.demoFirstHomeStory,
        category: MemoryCategory.personal,
        memoryType: MemoryType.place,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime(2023, 11, 18),
        createdAt: DateTime(2023, 11, 18),
        coverColor: const Color(0xFFC9A27A),
        wallPosition: const Offset(490, 320),
        rotation: 0.03,
        locationLabel: l10n.demoFirstHomePlace,
        latitude: 48.3069,
        longitude: 14.2858,
        coverPhotoPath: '$_photos/first_home.jpg',
      ),
      MemoryEvent(
        id: 'demo-alpine-summit',
        title: l10n.demoAlpineSummitTitle,
        description: l10n.demoAlpineSummitStory,
        category: MemoryCategory.travel,
        memoryType: MemoryType.trip,
        feeling: MemoryFeeling.proud,
        occurredAt: DateTime(2024, 8, 14),
        createdAt: DateTime(2024, 8, 14),
        coverColor: const Color(0xFFB79AD6),
        wallPosition: const Offset(0, 660),
        rotation: -0.035,
        locationLabel: l10n.demoAlpineSummitPlace,
        latitude: 47.0742,
        longitude: 12.6947,
        coverPhotoPath: '$_photos/alpine_summit.jpg',
      ),
      MemoryEvent(
        id: 'demo-first-bike',
        title: l10n.demoFirstBikeTitle,
        description: l10n.demoFirstBikeStory,
        category: MemoryCategory.family,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.proud,
        occurredAt: DateTime(2025, 10, 4),
        createdAt: DateTime(2025, 10, 4),
        coverColor: const Color(0xFFE0A15A),
        wallPosition: const Offset(250, 720),
        rotation: 0.04,
        locationLabel: l10n.demoFirstBikePlace,
        latitude: 48.2167,
        longitude: 16.3958,
        coverPhotoPath: '$_photos/first_bike.jpg',
      ),
      MemoryEvent(
        id: 'demo-garden-dinner',
        title: l10n.demoGardenDinnerTitle,
        description: l10n.demoGardenDinnerStory,
        category: MemoryCategory.family,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime(2025, 5, 31),
        createdAt: DateTime(2025, 5, 31),
        coverColor: const Color(0xFFD98C6A),
        wallPosition: const Offset(480, 650),
        rotation: -0.025,
        locationLabel: l10n.demoGardenDinnerPlace,
        coverPhotoPath: '$_photos/garden_dinner.jpg',
      ),
    ];
  }

  static List<MemoryConnection> localizedConnections(AppLocalizations l10n) {
    return [
      MemoryConnection(
        id: 'demo-thread-0',
        fromEventId: 'demo-first-dance',
        toEventId: 'demo-first-home',
        label: l10n.demoThreadFirstDanceToFirstHome,
      ),
      MemoryConnection(
        id: 'demo-thread-1',
        fromEventId: 'demo-first-home',
        toEventId: 'demo-newborn',
        label: l10n.demoThreadFirstHomeToNewborn,
      ),
      MemoryConnection(
        id: 'demo-thread-2',
        fromEventId: 'demo-newborn',
        toEventId: 'demo-beach-sunset',
        label: l10n.demoThreadNewbornToBeachSunset,
      ),
      MemoryConnection(
        id: 'demo-thread-3',
        fromEventId: 'demo-grandma-kitchen',
        toEventId: 'demo-garden-dinner',
        label: l10n.demoThreadGrandmaKitchenToGardenDinner,
      ),
      MemoryConnection(
        id: 'demo-thread-4',
        fromEventId: 'demo-graduation',
        toEventId: 'demo-first-home',
        label: l10n.demoThreadGraduationToFirstHome,
      ),
      MemoryConnection(
        id: 'demo-thread-5',
        fromEventId: 'demo-alpine-summit',
        toEventId: 'demo-first-bike',
        label: l10n.demoThreadAlpineSummitToFirstBike,
      ),
      MemoryConnection(
        id: 'demo-thread-6',
        fromEventId: 'demo-first-bike',
        toEventId: 'demo-garden-dinner',
        label: l10n.demoThreadFirstBikeToGardenDinner,
      ),
    ];
  }

  static List<MemoryPerson> localizedPeople(AppLocalizations l10n) {
    return [
      MemoryPerson(
        id: 'demo-person-0',
        eventId: 'demo-garden-dinner',
        name: 'Opa Karl',
        relationship: l10n.demoRelationGrandpa,
      ),
      MemoryPerson(
        id: 'demo-person-1',
        eventId: 'demo-garden-dinner',
        name: 'Oma Rosa',
        relationship: l10n.demoRelationGrandma,
      ),
      MemoryPerson(
        id: 'demo-person-2',
        eventId: 'demo-garden-dinner',
        name: 'Lina',
        relationship: l10n.demoRelationDaughter,
      ),
      MemoryPerson(
        id: 'demo-person-3',
        eventId: 'demo-garden-dinner',
        name: 'Sarah',
        relationship: l10n.demoRelationWife,
      ),
      MemoryPerson(
        id: 'demo-person-4',
        eventId: 'demo-first-dance',
        name: 'Sarah',
        relationship: l10n.demoRelationWife,
      ),
      MemoryPerson(
        id: 'demo-person-5',
        eventId: 'demo-first-dance',
        name: 'Jonas',
        relationship: l10n.demoRelationBestMan,
      ),
      MemoryPerson(
        id: 'demo-person-6',
        eventId: 'demo-first-dance',
        name: 'Mama',
        relationship: l10n.demoRelationMother,
      ),
    ];
  }

  static final eventIds = events.map((event) => event.id).toSet();

  /// The demo wall before 0.1.9 (four moments). Installs that still show it
  /// get the new demo wall, and "Clear demo" removes it too.
  static const legacyEventIds = {
    'vienna-first-trip',
    'linz-rain-coffee',
    'family-table',
    'first-app-launch',
  };

  static bool isDemoEventId(String id) =>
      eventIds.contains(id) || legacyEventIds.contains(id);
}
