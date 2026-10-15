import '../memories/data/memory_repository.dart';
import '../memories/domain/memory_event.dart';

/// The memories matching [query]: in the title, the story, the place, the
/// names of the people in them, or the year. Newest first.
List<MemoryEvent> searchMemories(MemoryState state, String query) {
  final words = _fold(query).split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  if (words.isEmpty) return const [];
  final results = state.events.where((event) {
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

/// Lower case without accents, so "grossglockner" finds "Großglockner" and
/// "cafe" finds "Café".
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
  };
  final lower = text.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(map[char] ?? char);
  }
  return buffer.toString();
}
