import 'package:flutter/material.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/wall/domain/wall_item.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

/// The store screenshots show the app's demo wall (MemorySeedData): the
/// same moments, threads, people and photos (assets/demo_moments/) that new
/// users can preview in the app.
const momentsPrefix = 'assets/demo_moments/';

MemoryState storeMemoryState(String lang) {
  final l10n = lookupAppLocalizations(Locale(lang));
  return MemoryState(
    events: MemorySeedData.localizedEvents(l10n),
    connections: MemorySeedData.localizedConnections(l10n),
    photos: const [],
    people: MemorySeedData.localizedPeople(l10n),
    wallItems: const <WallItem>[],
  );
}

/// Store captions: (tag, headline, subtitle) per language, in listing order.
const storeCaptions = {
  'wall': {
    'en': (
      'Your memory wall',
      'Your most beautiful moments, on one wall',
      'Photos, places and stories, connected by the threads of your life.',
    ),
    'de': (
      'Deine Erinnerungswand',
      'Deine schönsten Momente an einer Wand',
      'Fotos, Orte und Geschichten – verbunden durch die Fäden deines Lebens.',
    ),
    'ar': (
      'جدار ذكرياتك',
      'أجمل لحظاتك على جدار واحد',
      'صور وأماكن وقصص تربطها خيوط حياتك.',
    ),
  },
  'detail': {
    'en': (
      'Every chapter',
      'Relive every moment',
      'Open a memory and step right back into it.',
    ),
    'de': (
      'Jedes Kapitel',
      'Erlebe jeden Moment noch einmal',
      'Öffne eine Erinnerung und sei wieder mittendrin.',
    ),
    'ar': ('كل فصل', 'عِش كل لحظة من جديد', 'افتح ذكرى وعُد إليها كأنها الآن.'),
  },
  'story': {
    'en': (
      'The whole story',
      'Keep the story behind the photo',
      'What happened, who was there and how it felt.',
    ),
    'de': (
      'Die ganze Geschichte',
      'Die Geschichte hinter dem Foto',
      'Was passiert ist, wer dabei war und wie es sich angefühlt hat.',
    ),
    'ar': (
      'القصة كاملة',
      'احفظ القصة وراء الصورة',
      'ماذا حدث، ومن كان هناك، وكيف كان الشعور.',
    ),
  },
  'timeline': {
    'en': (
      'Timeline',
      'Your life, year by year',
      'Switch from the wall to a timeline whenever you like.',
    ),
    'de': (
      'Zeitleiste',
      'Dein Leben, Jahr für Jahr',
      'Wechsle jederzeit von der Wand zur Zeitleiste.',
    ),
    'ar': (
      'الخط الزمني',
      'حياتك سنةً بعد سنة',
      'انتقل من الجدار إلى الخط الزمني متى شئت.',
    ),
  },
  'add': {
    'en': (
      'Capture',
      'Save a moment in seconds',
      'Add photos, a date, a place and the feeling – before it fades.',
    ),
    'de': (
      'Festhalten',
      'Halte einen Moment in Sekunden fest',
      'Fotos, Datum, Ort und Gefühl – bevor es verblasst.',
    ),
    'ar': (
      'احفظ',
      'احفظ لحظتك في ثوانٍ',
      'أضف الصور والتاريخ والمكان والشعور قبل أن يبهت.',
    ),
  },
};
