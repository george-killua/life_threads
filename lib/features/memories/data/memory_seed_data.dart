import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../domain/memory_category.dart';
import '../domain/memory_connection.dart';
import '../domain/memory_event.dart';
import '../domain/memory_feeling.dart';
import '../domain/memory_type.dart';

class MemorySeedData {
  const MemorySeedData._();

  static const viennaEveningWalkPhoto =
      'assets/demo_people/vienna_evening_walk.jpg';
  static const linzRainCoffeePhoto = 'assets/demo_people/linz_rain_coffee.jpg';
  static const familyTablePhoto = 'assets/demo_people/family_table.jpg';
  static const firstLaunchNightPhoto =
      'assets/demo_people/first_launch_night.jpg';

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
        id: 'vienna-first-trip',
        title: l10n.demoViennaTitle,
        description: l10n.demoViennaDescription,
        category: MemoryCategory.travel,
        memoryType: MemoryType.trip,
        feeling: MemoryFeeling.nostalgic,
        occurredAt: DateTime(2024, 5, 21),
        createdAt: DateTime(2024, 5, 21),
        coverColor: const Color(0xFFD2A24A),
        wallPosition: const Offset(160, 150),
        rotation: -0.045,
        locationLabel: l10n.demoViennaLocation,
        latitude: 48.2082,
        longitude: 16.3738,
        coverPhotoPath: viennaEveningWalkPhoto,
      ),
      MemoryEvent(
        id: 'linz-rain-coffee',
        title: l10n.demoLinzTitle,
        description: l10n.demoLinzDescription,
        category: MemoryCategory.personal,
        memoryType: MemoryType.place,
        feeling: MemoryFeeling.calm,
        occurredAt: DateTime(2024, 11, 4),
        createdAt: DateTime(2024, 11, 4),
        coverColor: const Color(0xFF8EA7C6),
        wallPosition: const Offset(380, 350),
        rotation: 0.035,
        locationLabel: l10n.demoLinzLocation,
        latitude: 48.3069,
        longitude: 14.2858,
        coverPhotoPath: linzRainCoffeePhoto,
      ),
      MemoryEvent(
        id: 'family-table',
        title: l10n.demoFamilyTitle,
        description: l10n.demoFamilyDescription,
        category: MemoryCategory.family,
        memoryType: MemoryType.person,
        feeling: MemoryFeeling.warm,
        occurredAt: DateTime(2025, 1, 12),
        createdAt: DateTime(2025, 1, 12),
        coverColor: const Color(0xFFE59A8D),
        wallPosition: const Offset(620, 150),
        rotation: -0.025,
        locationLabel: l10n.demoHomeLocation,
        coverPhotoPath: familyTablePhoto,
      ),
      MemoryEvent(
        id: 'first-app-launch',
        title: l10n.demoLaunchTitle,
        description: l10n.demoLaunchDescription,
        category: MemoryCategory.personal,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.proud,
        occurredAt: DateTime(2025, 3, 9),
        createdAt: DateTime(2025, 3, 9),
        coverColor: const Color(0xFFA7BD92),
        wallPosition: const Offset(270, 590),
        rotation: 0.055,
        locationLabel: l10n.demoLinzLocation,
        latitude: 48.3069,
        longitude: 14.2858,
        coverPhotoPath: firstLaunchNightPhoto,
      ),
    ];
  }

  static final connections = localizedConnections(
    lookupAppLocalizations(const Locale('en')),
  );

  static List<MemoryConnection> localizedConnections(AppLocalizations l10n) {
    return [
      MemoryConnection(
        id: 'c1',
        fromEventId: 'vienna-first-trip',
        toEventId: 'linz-rain-coffee',
        label: l10n.demoConnectionQuietDays,
      ),
      MemoryConnection(
        id: 'c2',
        fromEventId: 'linz-rain-coffee',
        toEventId: 'first-app-launch',
        label: l10n.demoConnectionHomeFocus,
      ),
      MemoryConnection(
        id: 'c3',
        fromEventId: 'family-table',
        toEventId: 'first-app-launch',
        label: l10n.demoConnectionWhyItMatters,
      ),
    ];
  }

  static final eventIds = events.map((event) => event.id).toSet();

  static bool isDemoEventId(String id) => eventIds.contains(id);
}
