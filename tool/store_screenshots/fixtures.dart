import 'package:flutter/material.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/memories/domain/memory_connection.dart';
import 'package:life_threads/features/memories/domain/memory_person.dart';
import 'package:life_threads/features/wall/domain/wall_item.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

/// The store screenshots show the app's demo wall (MemorySeedData): the
/// same moments, threads, people and photos (assets/demo_moments/) that new
/// users can preview in the app.
const momentsPrefix = 'assets/demo_moments/';

/// The demo memories under their own ids (`store-…`): with the demo ids the
/// wall would show its "Demo wall preview – clear demo" banner.
String storeId(String demoId) => demoId.replaceFirst('demo-', 'store-');

MemoryState storeMemoryState(String lang) {
  final l10n = lookupAppLocalizations(Locale(lang));
  return MemoryState(
    events: [
      for (final event in MemorySeedData.localizedEvents(l10n))
        event.copyWith(id: storeId(event.id)),
    ],
    connections: [
      for (final c in MemorySeedData.localizedConnections(l10n))
        MemoryConnection(
          id: c.id,
          fromEventId: storeId(c.fromEventId),
          toEventId: storeId(c.toEventId),
          label: c.label,
        ),
    ],
    photos: const [],
    people: [
      for (final p in MemorySeedData.localizedPeople(l10n))
        MemoryPerson(
          id: p.id,
          eventId: storeId(p.eventId),
          name: p.name,
          relationship: p.relationship,
        ),
    ],
    wallItems: const <WallItem>[],
  );
}

/// Store captions: (tag, headline, subtitle) per language, in listing order.
const storeCaptions = {
  'wall': {
    'en': (
      'Your memory wall',
      'Your life, pinned to one wall',
      'Photos, places and stories, connected by the threads of your life.',
    ),
    'de': (
      'Deine Erinnerungswand',
      'Dein Leben an einer Wand',
      'Fotos, Orte und Geschichten – verbunden durch die Fäden deines Lebens.',
    ),
    'ar': (
      'جدار ذكرياتك',
      'حياتك على جدار واحد',
      'صور وأماكن وقصص تربطها خيوط حياتك.',
    ),
  },
  'stories': {
    'en': (
      'Stories with music',
      'Turn memories into stories',
      'Story images and short films with music, ready to share.',
    ),
    'de': (
      'Storys mit Musik',
      'Mach Erinnerungen zu Storys',
      'Story-Bilder und kurze Filme mit Musik, bereit zum Teilen.',
    ),
    'ar': (
      'قصص مع موسيقى',
      'حوّل ذكرياتك إلى قصص',
      'صور قصص وأفلام قصيرة مع موسيقى، جاهزة للمشاركة.',
    ),
  },
  'family': {
    'en': (
      'Family walls',
      'One wall for the whole family',
      'End-to-end encrypted. Family members join free.',
    ),
    'de': (
      'Familienwände',
      'Eine Wand für die ganze Familie',
      'Ende-zu-Ende-verschlüsselt. Familienmitglieder treten kostenlos bei.',
    ),
    'ar': (
      'جدران العائلة',
      'جدار واحد للعائلة كلها',
      'مشفّر من طرف إلى طرف. ينضم أفراد العائلة مجاناً.',
    ),
  },
  'year': {
    'en': (
      'Thread of the Year',
      'Your year as a short film',
      'The moments that mattered, in order, with music.',
    ),
    'de': (
      'Faden des Jahres',
      'Dein Jahr als kurzer Film',
      'Die Momente, die gezählt haben, der Reihe nach, mit Musik.',
    ),
    'ar': (
      'خيط السنة',
      'سنتك كفيلم قصير',
      'اللحظات التي صنعت الفرق، بالترتيب، مع موسيقى.',
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
      'Private by design',
      'Your life, year by year',
      'Stays on your phone: no account, no ads, no tracking.',
    ),
    'de': (
      'Privat von Anfang an',
      'Dein Leben, Jahr für Jahr',
      'Bleibt auf deinem Handy: kein Konto, keine Werbung, kein Tracking.',
    ),
    'ar': (
      'الخصوصية أولاً',
      'حياتك سنةً بعد سنة',
      'تبقى على هاتفك: لا حساب، لا إعلانات، لا تتبّع.',
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
