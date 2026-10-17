/// Keeps objectionable words off family walls (App Review guideline 1.2:
/// apps with user content must filter objectionable material before it is
/// posted). Family walls are end-to-end encrypted, so the server can't look;
/// the check runs on the device, on the text before it is encrypted: memory
/// titles, stories and places, the wall's name and the member's display name.
///
/// It matches whole words (so "grape", "Scunthorpe", "Niger" or "كسر" pass),
/// a few stems anywhere in the text even when spaced out or with repeated
/// letters ("f u c k", "fuuuck"), and a few threatening phrases. Letters are
/// lowercased, accents and Arabic vowel marks dropped, Arabic letter forms
/// unified and common digit/symbol swaps undone ("sh1t" -> "shit").
/// Report and block on the wall cover what a word list can't.
abstract final class FamilyContentFilter {
  /// Whole words, in English, German and Arabic.
  static const _words = [
    // English
    'bitch', 'bitches', 'whore', 'whores', 'slut', 'sluts', 'nigger',
    'niggers', 'nigga', 'niggas', 'faggot', 'faggots', 'retard', 'retards',
    'kike', 'spic', 'chink', 'tranny', 'rape', 'raped', 'rapes', 'raping',
    'rapist', 'porn', 'porno', 'kys', 'cunt', 'cunts', 'dickhead', 'twat',
    'wanker',
    // German
    'hure', 'huren', 'schlampe', 'schlampen', 'nutte', 'nutten', 'fick',
    'ficken', 'fickt', 'gefickt', 'arschloch', 'missgeburt', 'kanake',
    'kanaken', 'neger', 'spast', 'spasti', 'wixer', 'wichser', 'fotze',
    'vergewaltigt', 'vergewaltigen', 'vergewaltigung',
    // Arabic
    'عاهرة', 'شرموطة', 'شرموط', 'شراميط', 'قحبة', 'قحاب', 'منيوك', 'منيوكة',
    'منايك', 'نياكة', 'متناك', 'كس', 'كسمك', 'كسختك', 'زب', 'زبي',
    'خول', 'عرص', 'معرص', 'ديوث', 'اقتلك', 'سأقتلك',
  ];

  /// Stems found anywhere, also with spaces, dots or repeated letters in
  /// between. Only stems that don't occur inside ordinary words.
  static const _stems = [
    'fuck',
    'motherfuck',
    'childporn',
    'kinderporn',
    'hurensohn',
    'wichser',
    'fotze',
    'schwuchtel',
    'vergewaltig',
    'شرموط',
    'قحبة',
    'منيوك',
  ];

  /// Threats and slurs that are only objectionable as a phrase.
  static const _phrases = [
    'kill yourself',
    'kill urself',
    'i will kill you',
    'ill kill you',
    'gonna kill you',
    'go die',
    'heil hitler',
    'sieg heil',
    'fick dich',
    'fick deine mutter',
    'bring dich um',
    'ich bringe dich um',
    'ich bring dich um',
    'stirb',
    'ابن الكلب',
    'ابن الشرموطة',
    'يلعن ابوك',
    'يلعن امك',
    'راح اقتلك',
  ];

  static final _wordSet = {for (final w in _words) _normalize(w)};
  static final _stemList = [for (final s in _stems) _squash(_normalize(s))];
  static final _phraseList = [
    for (final p in _phrases) _tokens(_normalize(p)).join(' '),
  ];

  /// Whether every given text may be posted.
  static bool allows(Iterable<String?> texts) =>
      texts.every((text) => text == null || !_blocked(text));

  static bool _blocked(String text) {
    final normalized = _normalize(text);
    final tokens = _tokens(normalized);
    for (final token in tokens) {
      if (_variants(token).any(_wordSet.contains)) return true;
    }
    final joined = ' ${tokens.join(' ')} ';
    for (final phrase in _phraseList) {
      if (joined.contains(' $phrase ')) return true;
    }
    final squashed = _squash(normalized);
    return _stemList.any(squashed.contains);
  }

  /// Lowercase, without accents or Arabic vowel marks, Arabic letter forms
  /// unified, digit and symbol look-alikes turned back into letters.
  static String _normalize(String text) {
    final out = StringBuffer();
    for (final rune in text.toLowerCase().runes) {
      final char = String.fromCharCode(rune);
      // Arabic vowel marks, tatweel and the superscript alef.
      if ((rune >= 0x064B && rune <= 0x065F) ||
          rune == 0x0640 ||
          rune == 0x0670) {
        continue;
      }
      out.write(_fold[char] ?? char);
    }
    return out.toString();
  }

  static const _fold = {
    'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'è': 'e',
    'é': 'e', 'ê': 'e', 'ë': 'e', 'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ù': 'u', 'ú': 'u',
    'û': 'u', 'ü': 'u', 'ß': 'ss', 'ç': 'c', 'ñ': 'n', '0': 'o', '1': 'i',
    '3': 'e', '4': 'a', '5': 's', '7': 't', '@': 'a', r'$': 's',
    '*': 'u',
    // Arabic: alef forms, alef maqsura, teh marbuta.
    'أ': 'ا', 'إ': 'ا', 'آ': 'ا', 'ٱ': 'ا', 'ى': 'ي', 'ة': 'ه',
  };

  static final _separators = RegExp(r'[^\p{L}]+', unicode: true);

  static List<String> _tokens(String normalized) =>
      normalized.split(_separators).where((t) => t.isNotEmpty).toList();

  /// Letters only, runs of the same letter collapsed ("f.u.u.c.k" -> "fuck").
  static String _squash(String normalized) {
    final out = StringBuffer();
    String? last;
    for (final rune in normalized.runes) {
      final char = String.fromCharCode(rune);
      if (_separators.hasMatch(char) || char == last) continue;
      out.write(char);
      last = char;
    }
    return out.toString();
  }

  /// The word as written, and for Arabic without the attached "و", "ف", "ب",
  /// "ل" and "ال" in front ("والشرموطة" -> "شرموطه"); at least three letters
  /// must remain, so two-letter words only match on their own.
  static Iterable<String> _variants(String word) sync* {
    final normalized = _normalize(word);
    yield normalized;
    for (final prefix in const [
      'وال', 'فال', 'بال', 'لل', 'ال', 'و', 'ف', 'ب', 'ل', //
    ]) {
      if (normalized.startsWith(prefix) &&
          normalized.length - prefix.length >= 3) {
        yield normalized.substring(prefix.length);
      }
    }
  }
}
