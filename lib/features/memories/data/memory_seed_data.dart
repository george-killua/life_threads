import 'package:flutter/material.dart';

import '../domain/memory_category.dart';
import '../domain/memory_connection.dart';
import '../domain/memory_event.dart';
import '../domain/memory_feeling.dart';
import '../domain/memory_type.dart';

class MemorySeedData {
  const MemorySeedData._();

  static final events = <MemoryEvent>[
    MemoryEvent(
      id: 'vienna-first-trip',
      title: 'Vienna evening walk',
      description:
          'A quiet evening in Vienna, the kind of moment that stays warm because nothing needed to be perfect.',
      category: MemoryCategory.travel,
      memoryType: MemoryType.trip,
      feeling: MemoryFeeling.nostalgic,
      occurredAt: DateTime(2024, 5, 21),
      createdAt: DateTime(2024, 5, 21),
      coverColor: const Color(0xFFD2A24A),
      wallPosition: const Offset(160, 150),
      rotation: -0.045,
      locationLabel: 'Vienna, Austria',
      latitude: 48.2082,
      longitude: 16.3738,
    ),
    MemoryEvent(
      id: 'linz-rain-coffee',
      title: 'Rain and coffee',
      description:
          'A slow Linz afternoon with coffee, rain on the windows, and one photo that feels like home.',
      category: MemoryCategory.personal,
      memoryType: MemoryType.place,
      feeling: MemoryFeeling.calm,
      occurredAt: DateTime(2024, 11, 4),
      createdAt: DateTime(2024, 11, 4),
      coverColor: const Color(0xFF8EA7C6),
      wallPosition: const Offset(380, 350),
      rotation: 0.035,
      locationLabel: 'Linz, Austria',
      latitude: 48.3069,
      longitude: 14.2858,
    ),
    MemoryEvent(
      id: 'family-table',
      title: 'Family table',
      description:
          'Food, noise, small jokes, and the feeling that this is what should be remembered.',
      category: MemoryCategory.family,
      memoryType: MemoryType.person,
      feeling: MemoryFeeling.warm,
      occurredAt: DateTime(2025, 1, 12),
      createdAt: DateTime(2025, 1, 12),
      coverColor: const Color(0xFFE59A8D),
      wallPosition: const Offset(620, 150),
      rotation: -0.025,
      locationLabel: 'Home',
    ),
    MemoryEvent(
      id: 'first-app-launch',
      title: 'First launch night',
      description:
          'The night an idea finally became something real on a screen.',
      category: MemoryCategory.personal,
      memoryType: MemoryType.moment,
      feeling: MemoryFeeling.proud,
      occurredAt: DateTime(2025, 3, 9),
      createdAt: DateTime(2025, 3, 9),
      coverColor: const Color(0xFFA7BD92),
      wallPosition: const Offset(270, 590),
      rotation: 0.055,
      locationLabel: 'Linz, Austria',
      latitude: 48.3069,
      longitude: 14.2858,
    ),
  ];

  static const connections = <MemoryConnection>[
    MemoryConnection(
      id: 'c1',
      fromEventId: 'vienna-first-trip',
      toEventId: 'linz-rain-coffee',
      label: 'quiet days',
    ),
    MemoryConnection(
      id: 'c2',
      fromEventId: 'linz-rain-coffee',
      toEventId: 'first-app-launch',
      label: 'home focus',
    ),
    MemoryConnection(
      id: 'c3',
      fromEventId: 'family-table',
      toEventId: 'first-app-launch',
      label: 'why it matters',
    ),
  ];
}
