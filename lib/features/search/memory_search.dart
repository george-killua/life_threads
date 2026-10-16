import '../memories/data/memory_repository.dart';
import '../memories/domain/memory_event.dart';

/// The memories matching [query]: in the title, the story, the place, the
/// names of the people in them, or the year. Newest first.
List<MemoryEvent> searchMemories(MemoryState state, String query) {
  final words = _fold(query).split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  if (words.isEmpty) return const [];
  final results = state.visibleEvents.where((event) {
    final haystack = _fold(
      [
        event.title,
        event.description,
        event.locationLabel,
        '${event.occurredAt.year}',
        for (final person in state.peopleForEvent(event.id)) person.name,
      ].join(' '),
    );
    // Every word must appear somewhere ("split 2025").
    return words.every(haystack.contains);
  }).toList()..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  return results;
}

/// What to suggest before anything is typed: the most frequent places
/// (their town), people and the years of one's own memories.
List<String> searchSuggestions(MemoryState state) {
  final places = <String, int>{};
  final people = <String, int>{};
  final years = <int>{};
  for (final event in state.visibleEvents) {
    years.add(event.occurredAt.year);
    final town = event.locationLabel.split(',').first.trim();
    if (town.isNotEmpty && !RegExp(r'^-?\d').hasMatch(town)) {
      places.update(town, (n) => n + 1, ifAbsent: () => 1);
    }
    for (final person in state.peopleForEvent(event.id)) {
      final name = person.name.trim();
      if (name.isNotEmpty) people.update(name, (n) => n + 1, ifAbsent: () => 1);
    }
  }
  List<String> top(Map<String, int> counts, int n) =>
      (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
          .take(n)
          .map((e) => e.key)
          .toList();
  return [
    ...top(places, 3),
    ...top(people, 3),
    ...(years.toList()..sort((a, b) => b.compareTo(a)))
        .take(2)
        .map((y) => '$y'),
  ];
}

/// Lower case without accents, so "grossglockner" finds "Großglockner" and
/// "cafe" finds "Café". Arabic is folded the way people type it: one alef
/// for أ إ آ ٱ, ي for ى, ه for ة, and no vowel marks or tatweel, so
/// "احمد" finds "أحمد".
String _fold(String text) {
  const map = {
    'ä': 'a',
    'à': 'a',
    'á': 'a',
    'â': 'a',
    'ã': 'a',
    'å': 'a',
    'ö': 'o',
    'ò': 'o',
    'ó': 'o',
    'ô': 'o',
    'õ': 'o',
    'ü': 'u',
    'ù': 'u',
    'ú': 'u',
    'û': 'u',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ç': 'c',
    'ñ': 'n',
    'ß': 'ss',
    'أ': 'ا',
    'إ': 'ا',
    'آ': 'ا',
    'ٱ': 'ا',
    'ى': 'ي',
    'ة': 'ه',
  };
  final lower = text.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    // Arabic vowel marks (U+064B–U+065F, U+0670) and tatweel (U+0640).
    if ((rune >= 0x064B && rune <= 0x065F) ||
        rune == 0x0670 ||
        rune == 0x0640) {
      continue;
    }
    final char = String.fromCharCode(rune);
    buffer.write(map[char] ?? char);
  }
  return buffer.toString();
}
