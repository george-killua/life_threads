import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/wall/presentation/widgets/memory_card.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

var existsCalls = 0;

class _CountingFile implements File {
  _CountingFile(this.path);
  @override
  final String path;
  @override
  bool existsSync() {
    existsCalls++;
    return false;
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

void main() {
  testWidgets('wind animation frames do not stat the photo file each frame', (
    tester,
  ) async {
    final event = MemoryEvent(
      id: 'm',
      title: 'm',
      description: '',
      category: MemoryCategory.family,
      memoryType: MemoryType.moment,
      feeling: MemoryFeeling.warm,
      occurredAt: DateTime(2024),
      createdAt: DateTime(2024),
      coverColor: Colors.amber,
      wallPosition: const Offset(10, 10),
      rotation: 0,
      locationLabel: '',
      coverPhotoPath: '/data/user/photos/m.jpg',
    );
    Widget card(double wind) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Stack(
        children: [
          MemoryCard(
            event: event,
            windValue: wind,
            isDragging: false,
            hasConnection: false,
            onTap: () {},
            onLongPress: () {},
            onEdit: () {},
            onConnect: () {},
            onPointerDown: () {},
            onPointerUp: () {},
            onDragStart: () {},
            onDragUpdate: (_) {},
            onDragEnd: () {},
          ),
        ],
      ),
    );
    await IOOverrides.runZoned(() async {
      for (var f = 0; f < 60; f++) {
        await tester.pumpWidget(card(f / 60)); // one second of wind frames
      }
    }, createFile: (p) => _CountingFile(p));
    expect(
      existsCalls,
      lessThanOrEqualTo(1),
      reason: 'existsSync called $existsCalls times in 60 frames',
    );
  });
}
