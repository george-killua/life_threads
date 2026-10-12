import 'package:flutter/material.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/memories/domain/memory_category.dart';
import 'package:life_threads/features/memories/domain/memory_connection.dart';
import 'package:life_threads/features/memories/domain/memory_event.dart';
import 'package:life_threads/features/memories/domain/memory_feeling.dart';
import 'package:life_threads/features/memories/domain/memory_person.dart';
import 'package:life_threads/features/memories/domain/memory_type.dart';
import 'package:life_threads/features/wall/domain/wall_item.dart';

/// Photos live in store_listing_assets/store_moments/ and are served under
/// this prefix by [StoreAssetBundle]; the app treats `assets/` paths as
/// bundled images, so the previews never ship these photos in the app.
const momentsPrefix = 'assets/store_moments/';

class _Moment {
  const _Moment({
    required this.id,
    required this.photo,
    required this.title,
    required this.story,
    required this.place,
    required this.category,
    required this.type,
    required this.feeling,
    required this.date,
    required this.color,
    required this.position,
    required this.rotation,
    this.lat,
    this.lng,
  });

  final String id;
  final String photo;
  final Map<String, String> title;
  final Map<String, String> story;
  final Map<String, String> place;
  final MemoryCategory category;
  final MemoryType type;
  final MemoryFeeling feeling;
  final DateTime date;
  final Color color;
  final Offset position;
  final double rotation;
  final double? lat;
  final double? lng;
}

final _moments = [
  _Moment(
    id: 'first-dance',
    photo: '01_first_dance.jpg',
    title: {
      'en': 'Our first dance',
      'de': 'Unser erster Tanz',
      'ar': 'رقصتنا الأولى',
    },
    story: {
      'en':
          'The band played our song and the whole barn went quiet. I stepped on your foot twice, you laughed through all of it, and for three minutes nobody else was there.',
      'de':
          'Die Band spielte unser Lied und die ganze Scheune wurde still. Ich bin dir zweimal auf den Fuß getreten, du hast die ganze Zeit gelacht – und drei Minuten lang gab es nur uns.',
      'ar':
          'عزفت الفرقة أغنيتنا فسكت المكان كلّه. دست على قدمك مرّتين وأنتِ تضحكين، ولثلاث دقائق لم يكن هناك أحد غيرنا.',
    },
    place: {'en': 'Salzburg', 'de': 'Salzburg', 'ar': 'سالزبورغ'},
    category: MemoryCategory.family,
    type: MemoryType.moment,
    feeling: MemoryFeeling.warm,
    date: DateTime(2023, 6, 17),
    color: Color(0xFFD2A24A),
    position: Offset(0, 0),
    rotation: -0.04,
    lat: 47.8095,
    lng: 13.0550,
  ),
  _Moment(
    id: 'newborn',
    photo: '02_newborn.jpg',
    title: {
      'en': 'Welcome home, Lina',
      'de': 'Willkommen daheim, Lina',
      'ar': 'أهلاً بكِ في البيت يا لينا',
    },
    story: {
      'en':
          'Her whole hand fit around one finger. The first quiet morning at home.',
      'de':
          'Ihre ganze Hand passte um einen Finger. Der erste ruhige Morgen zu Hause.',
      'ar': 'أمسكت يدها الصغيرة بإصبع واحد. أول صباح هادئ في البيت.',
    },
    place: {'en': 'Vienna', 'de': 'Wien', 'ar': 'فيينا'},
    category: MemoryCategory.family,
    type: MemoryType.person,
    feeling: MemoryFeeling.important,
    date: DateTime(2024, 9, 2),
    color: Color(0xFFE59A8D),
    position: Offset(240, 70),
    rotation: 0.035,
    lat: 48.2082,
    lng: 16.3738,
  ),
  _Moment(
    id: 'beach-sunset',
    photo: '03_beach_sunset.jpg',
    title: {
      'en': 'Summer by the sea',
      'de': 'Sommer am Meer',
      'ar': 'صيف على البحر',
    },
    story: {
      'en':
          'Barefoot until the sun went down, Lina asleep on your shoulders on the way back.',
      'de':
          'Barfuß bis die Sonne unterging, auf dem Rückweg schlief Lina auf deinen Schultern.',
      'ar': 'حفاة حتى غابت الشمس، ولينا نائمة على كتفيك في طريق العودة.',
    },
    place: {
      'en': 'Split, Croatia',
      'de': 'Split, Kroatien',
      'ar': 'سبليت، كرواتيا',
    },
    category: MemoryCategory.travel,
    type: MemoryType.trip,
    feeling: MemoryFeeling.calm,
    date: DateTime(2025, 7, 26),
    color: Color(0xFF8EA7C6),
    position: Offset(470, -10),
    rotation: -0.03,
    lat: 43.5081,
    lng: 16.4402,
  ),
  _Moment(
    id: 'grandma-kitchen',
    photo: '04_grandma_kitchen.jpg',
    title: {
      'en': "Grandma's kitchen",
      'de': 'In Omas Küche',
      'ar': 'في مطبخ جدّتي',
    },
    story: {
      'en': 'Her apricot cake, finally written down – and flour everywhere.',
      'de': 'Ihr Marillenkuchen, endlich aufgeschrieben – und überall Mehl.',
      'ar': 'كتبنا أخيراً وصفة كعكة المشمش – والطحين في كل مكان.',
    },
    place: {'en': 'Graz', 'de': 'Graz', 'ar': 'غراتس'},
    category: MemoryCategory.family,
    type: MemoryType.person,
    feeling: MemoryFeeling.nostalgic,
    date: DateTime(2025, 3, 9),
    color: Color(0xFFA7BD92),
    position: Offset(20, 330),
    rotation: 0.045,
    lat: 47.0707,
    lng: 15.4395,
  ),
  _Moment(
    id: 'graduation',
    photo: '05_graduation.jpg',
    title: {
      'en': 'Graduation day',
      'de': 'Der Tag der Sponsion',
      'ar': 'يوم التخرّج',
    },
    story: {
      'en': 'Dad cried before the caps even landed.',
      'de': 'Papa hat geweint, bevor die Hüte gelandet waren.',
      'ar': 'بكى أبي قبل أن تسقط القبعات.',
    },
    place: {'en': 'Innsbruck', 'de': 'Innsbruck', 'ar': 'إنسبروك'},
    category: MemoryCategory.personal,
    type: MemoryType.moment,
    feeling: MemoryFeeling.proud,
    date: DateTime(2022, 10, 7),
    color: Color(0xFFF2C86B),
    position: Offset(260, 390),
    rotation: -0.05,
    lat: 47.2692,
    lng: 11.4041,
  ),
  _Moment(
    id: 'first-home',
    photo: '06_first_home.jpg',
    title: {
      'en': 'Keys to our first home',
      'de': 'Schlüssel zum ersten Zuhause',
      'ar': 'مفتاح بيتنا الأول',
    },
    story: {
      'en':
          'No furniture yet, just boxes, pizza on the floor and a lot of plans.',
      'de': 'Noch keine Möbel, nur Kisten, Pizza am Boden und viele Pläne.',
      'ar': 'لا أثاث بعد، فقط صناديق وبيتزا على الأرض وأحلام كثيرة.',
    },
    place: {'en': 'Linz', 'de': 'Linz', 'ar': 'لينتس'},
    category: MemoryCategory.personal,
    type: MemoryType.place,
    feeling: MemoryFeeling.warm,
    date: DateTime(2023, 11, 18),
    color: Color(0xFFC9A27A),
    position: Offset(490, 320),
    rotation: 0.03,
    lat: 48.3069,
    lng: 14.2858,
  ),
  _Moment(
    id: 'alpine-summit',
    photo: '07_alpine_summit.jpg',
    title: {
      'en': 'Above the clouds',
      'de': 'Über den Wolken',
      'ar': 'فوق الغيوم',
    },
    story: {
      'en': 'Up at 4 a.m. for this. Worth every step.',
      'de': 'Um vier Uhr früh los – jeder Schritt hat sich gelohnt.',
      'ar': 'استيقظنا في الرابعة فجراً من أجل هذا المنظر، وكانت كل خطوة تستحق.',
    },
    place: {'en': 'Grossglockner', 'de': 'Großglockner', 'ar': 'غروسغلوكنر'},
    category: MemoryCategory.travel,
    type: MemoryType.trip,
    feeling: MemoryFeeling.proud,
    date: DateTime(2024, 8, 14),
    color: Color(0xFFB79AD6),
    position: Offset(0, 660),
    rotation: -0.035,
    lat: 47.0742,
    lng: 12.6947,
  ),
  _Moment(
    id: 'first-bike',
    photo: '08_first_bike.jpg',
    title: {
      'en': 'First ride, no hands',
      'de': 'Die erste Runde allein',
      'ar': 'أول جولة وحده',
    },
    story: {
      'en': 'Three steps, a wobble, then he was gone – and so proud.',
      'de': 'Drei Tritte, ein Wackler, dann war er weg – und so stolz.',
      'ar': 'ثلاث دفعات، ثم ترنّح قليلاً، ثم انطلق – وكان فخوراً جداً.',
    },
    place: {'en': 'Prater, Vienna', 'de': 'Prater, Wien', 'ar': 'براتر، فيينا'},
    category: MemoryCategory.family,
    type: MemoryType.moment,
    feeling: MemoryFeeling.proud,
    date: DateTime(2025, 10, 4),
    color: Color(0xFFE0A15A),
    position: Offset(250, 720),
    rotation: 0.04,
    lat: 48.2167,
    lng: 16.3958,
  ),
  _Moment(
    id: 'garden-dinner',
    photo: '09_garden_dinner.jpg',
    title: {
      'en': "Grandpa's 80th",
      'de': 'Opas 80. Geburtstag',
      'ar': 'عيد ميلاد جدّي الثمانين',
    },
    story: {
      'en':
          'Four generations at one long table, and he still told the best stories.',
      'de':
          'Vier Generationen an einem langen Tisch, und er hat immer noch die besten Geschichten erzählt.',
      'ar': 'أربعة أجيال حول طاولة واحدة، وما زال يروي أجمل القصص.',
    },
    place: {'en': 'Wachau', 'de': 'Wachau', 'ar': 'فاخاو'},
    category: MemoryCategory.family,
    type: MemoryType.moment,
    feeling: MemoryFeeling.warm,
    date: DateTime(2025, 5, 31),
    color: Color(0xFFD98C6A),
    position: Offset(480, 650),
    rotation: -0.025,
  ),
];

const _threads = [
  (
    'first-dance',
    'first-home',
    {'en': 'Our story', 'de': 'Unsere Geschichte', 'ar': 'قصّتنا'},
  ),
  (
    'first-home',
    'newborn',
    {'en': 'Then came Lina', 'de': 'Dann kam Lina', 'ar': 'ثم جاءت لينا'},
  ),
  (
    'newborn',
    'beach-sunset',
    {'en': 'Her first summer', 'de': 'Ihr erster Sommer', 'ar': 'صيفها الأول'},
  ),
  (
    'grandma-kitchen',
    'garden-dinner',
    {'en': 'Family', 'de': 'Familie', 'ar': 'العائلة'},
  ),
  (
    'graduation',
    'first-home',
    {'en': 'New chapter', 'de': 'Neues Kapitel', 'ar': 'فصل جديد'},
  ),
  (
    'alpine-summit',
    'first-bike',
    {
      'en': 'Little adventures',
      'de': 'Kleine Abenteuer',
      'ar': 'مغامرات صغيرة',
    },
  ),
  (
    'first-bike',
    'garden-dinner',
    {'en': 'Grandpa watched', 'de': 'Opa hat zugeschaut', 'ar': 'وجدّي يتفرّج'},
  ),
];

const _people = {
  'garden-dinner': [
    ('Opa Karl', {'en': 'Grandpa', 'de': 'Opa', 'ar': 'جدّي'}),
    ('Oma Rosa', {'en': 'Grandma', 'de': 'Oma', 'ar': 'جدّتي'}),
    ('Lina', {'en': 'Daughter', 'de': 'Tochter', 'ar': 'ابنتي'}),
    ('Sarah', {'en': 'Wife', 'de': 'Ehefrau', 'ar': 'زوجتي'}),
  ],
  'first-dance': [
    ('Sarah', {'en': 'Wife', 'de': 'Ehefrau', 'ar': 'زوجتي'}),
    ('Jonas', {'en': 'Best man', 'de': 'Trauzeuge', 'ar': 'الإشبين'}),
    ('Mama', {'en': 'Mother', 'de': 'Mutter', 'ar': 'أمي'}),
  ],
};

MemoryState storeMemoryState(String lang) {
  return MemoryState(
    events: [
      for (final m in _moments)
        MemoryEvent(
          id: m.id,
          title: m.title[lang]!,
          description: m.story[lang]!,
          category: m.category,
          memoryType: m.type,
          feeling: m.feeling,
          occurredAt: m.date,
          createdAt: m.date,
          coverColor: m.color,
          wallPosition: m.position,
          rotation: m.rotation,
          locationLabel: m.place[lang]!,
          latitude: m.lat,
          longitude: m.lng,
          coverPhotoPath: '$momentsPrefix${m.photo}',
        ),
    ],
    connections: [
      for (final (i, (from, to, label)) in _threads.indexed)
        MemoryConnection(
          id: 'thread-$i',
          fromEventId: from,
          toEventId: to,
          label: label[lang]!,
        ),
    ],
    photos: const [],
    people: [
      for (final entry in _people.entries)
        for (final (i, (name, relationship)) in entry.value.indexed)
          MemoryPerson(
            id: '${entry.key}-person-$i',
            eventId: entry.key,
            name: name,
            relationship: relationship[lang]!,
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
