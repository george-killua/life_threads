import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';

import '../../tool/store_screenshots/fonts.dart';

/// Loads the fonts an iPhone shows (Avenir, SF Arabic, Material Icons) when
/// they exist (macOS); elsewhere the test font is used and only sizes and
/// colours are checked.
Future<bool> loadStoryFontsIfAvailable() async {
  if (!File('/System/Library/Fonts/Avenir.ttc').existsSync() ||
      !File('/System/Library/Fonts/SFArabic.ttf').existsSync()) {
    return false;
  }
  await loadStoreFonts();
  return true;
}

/// A solid-colour JPEG-sized photo on disk, like a saved memory photo.
File writeTestPhoto(
  Directory dir,
  String name,
  img.Color color, {
  int width = 400,
  int height = 300,
}) {
  final image = img.Image(width: width, height: height)..clear(color);
  // A darker band so zoom and crop show up in the samples.
  img.fillRect(
    image,
    x1: 0,
    y1: height * 2 ~/ 3,
    x2: width,
    y2: height,
    color: img.ColorRgb8(30, 30, 30),
  );
  final file = File('${dir.path}/$name.png')
    ..writeAsBytesSync(img.encodePng(image));
  return file;
}

const _palette = [
  (230, 140, 90),
  (90, 150, 210),
  (120, 180, 110),
  (220, 190, 80),
  (190, 110, 170),
  (100, 190, 190),
];

/// [count] memories with photos (and Arabic text when [arabic]).
List<MemoryEvent> storyMemories(
  Directory dir,
  int count, {
  bool arabic = false,
}) {
  const titlesEn = [
    'First dance in the kitchen',
    'Lake Hallstatt at dawn',
    'Grandma’s apricot cake',
    'The night train to Rome',
    'Our first apartment',
    'Snow day with Lina',
  ];
  const titlesAr = [
    'أول رقصة في المطبخ',
    'بحيرة هالشتات عند الفجر',
    'كعكة المشمش من جدتي',
    'القطار الليلي إلى روما',
    'شقتنا الأولى',
    'يوم الثلج مع لينا',
  ];
  return [
    for (var i = 0; i < count; i++)
      MemoryEvent(
        id: 'm$i',
        title: (arabic ? titlesAr : titlesEn)[i],
        description: arabic
            ? 'رقصنا بين الأطباق والموسيقى من الراديو القديم، وضحكنا حتى الصباح.'
            : 'We danced between the dishes to the old radio and laughed until morning.',
        category: MemoryCategory.family,
        memoryType: MemoryType.moment,
        feeling: MemoryFeeling.values[i % MemoryFeeling.values.length],
        occurredAt: DateTime(2021 + i, 3 + i, 12),
        createdAt: DateTime(2024),
        coverColor: Color.fromARGB(
          255,
          _palette[i].$1,
          _palette[i].$2,
          _palette[i].$3,
        ),
        wallPosition: Offset.zero,
        rotation: 0,
        locationLabel: arabic ? 'فيينا' : 'Vienna',
        latitude: 48.2,
        longitude: 16.37,
        coverPhotoPath: writeTestPhoto(
          dir,
          'photo$i',
          img.ColorRgb8(_palette[i].$1, _palette[i].$2, _palette[i].$3),
        ).path,
      ),
  ];
}
