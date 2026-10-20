import 'dart:io';

import 'package:flutter/services.dart';

/// Loads the fonts the app shows on an iPhone so the previews do not render
/// in the flutter_test placeholder font: Avenir (the app's theme font, from
/// macOS), SF Arabic (iOS' fallback for Arabic text) and Material Icons.
Future<void> loadStoreFonts() async {
  final flutterRoot = _flutterRoot();
  await _load('MaterialIcons', [
    File(
      '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ).readAsBytesSync(),
  ]);
  await _load('Avenir', _faces('/System/Library/Fonts/Avenir.ttc'));
  await _load('SF Arabic', [
    File('/System/Library/Fonts/SFArabic.ttf').readAsBytesSync(),
  ]);
  // The fonts iOS falls back to for the other scripts of the app.
  await _load('SF Pro', [
    File('/System/Library/Fonts/SFNS.ttf').readAsBytesSync(),
  ]);
  await _load('Hiragino Sans', [
    for (final weight in ['W3', 'W6'])
      ..._faces('/System/Library/Fonts/ヒラギノ角ゴシック $weight.ttc').take(1),
  ]);
  await _load(
    'Hiragino Sans GB',
    _faces('/System/Library/Fonts/Hiragino Sans GB.ttc'),
  );
  await _load(
    'Apple SD Gothic Neo',
    _faces('/System/Library/Fonts/AppleSDGothicNeo.ttc'),
  );
  await _load(
    'Kohinoor Devanagari',
    _faces('/System/Library/Fonts/Kohinoor.ttc'),
  );
}

/// The fallback fonts after Avenir for [lang], as an iPhone picks them:
/// Chinese and Japanese share characters, so each gets its own font first.
List<String> storeFontFallback(String lang) => [
  'SF Arabic',
  'SF Pro',
  if (lang == 'zh') 'Hiragino Sans GB',
  'Hiragino Sans',
  'Apple SD Gothic Neo',
  'Hiragino Sans GB',
  'Kohinoor Devanagari',
];

Future<void> _load(String family, List<Uint8List> fonts) async {
  final loader = FontLoader(family);
  for (final font in fonts) {
    loader.addFont(Future.value(ByteData.sublistView(font)));
  }
  await loader.load();
}

String _flutterRoot() {
  final fromEnv = Platform.environment['FLUTTER_ROOT'];
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
  // .../flutter/bin/cache/dart-sdk/bin/dart
  return File(
    Platform.resolvedExecutable,
  ).parent.parent.parent.parent.parent.path;
}

/// Splits a TrueType collection into standalone fonts (upright faces only,
/// one per weight; Avenir has both "Book" and "Roman" at 400 and the app's
/// regular text is Roman). The engine only reads the first face of a .ttc.
List<Uint8List> _faces(String path) {
  final data = File(path).readAsBytesSync();
  final view = ByteData.sublistView(data);
  final count = view.getUint32(8);
  final byWeight = <int, Uint8List>{};
  for (var i = 0; i < count; i++) {
    final font = _extract(view, data, view.getUint32(12 + 4 * i));
    final fontView = ByteData.sublistView(font);
    final os2 = _table(fontView, 'OS/2');
    if (os2 == null) continue;
    final weight = fontView.getUint16(os2 + 4);
    final italic = fontView.getUint16(os2 + 62) & 1 == 1;
    if (italic) continue;
    if (byWeight.containsKey(weight) && !_name(fontView).contains('Roman')) {
      continue;
    }
    byWeight[weight] = font;
  }
  return byWeight.values.toList();
}

Uint8List _extract(ByteData view, Uint8List data, int offset) {
  final numTables = view.getUint16(offset + 4);
  final headerSize = 12 + 16 * numTables;
  var size = headerSize;
  for (var t = 0; t < numTables; t++) {
    size += (view.getUint32(offset + 12 + 16 * t + 12) + 3) & ~3;
  }
  final out = Uint8List(size);
  final outView = ByteData.sublistView(out);
  out.setRange(0, 12, data, offset);
  var cursor = headerSize;
  for (var t = 0; t < numTables; t++) {
    final record = offset + 12 + 16 * t;
    final tableOffset = view.getUint32(record + 8);
    final length = view.getUint32(record + 12);
    out.setRange(12 + 16 * t, 12 + 16 * t + 8, data, record);
    outView.setUint32(12 + 16 * t + 8, cursor);
    outView.setUint32(12 + 16 * t + 12, length);
    out.setRange(cursor, cursor + length, data, tableOffset);
    cursor += (length + 3) & ~3;
  }
  return out;
}

int? _table(ByteData font, String tag) {
  final numTables = font.getUint16(4);
  for (var t = 0; t < numTables; t++) {
    final record = 12 + 16 * t;
    final name = String.fromCharCodes([
      for (var i = 0; i < 4; i++) font.getUint8(record + i),
    ]);
    if (name == tag) return font.getUint32(record + 8);
  }
  return null;
}

/// The PostScript name (name ID 6), enough to tell Avenir's 400 faces apart.
String _name(ByteData font) {
  final table = _table(font, 'name');
  if (table == null) return '';
  final count = font.getUint16(table + 2);
  final strings = table + font.getUint16(table + 4);
  for (var r = 0; r < count; r++) {
    final record = table + 6 + 12 * r;
    if (font.getUint16(record + 6) != 6) continue;
    final length = font.getUint16(record + 8);
    final start = strings + font.getUint16(record + 10);
    final bytes = [for (var i = 0; i < length; i++) font.getUint8(start + i)];
    final utf16 = font.getUint16(record) == 3 || font.getUint16(record) == 0;
    return utf16
        ? String.fromCharCodes([
            for (var i = 0; i + 1 < bytes.length; i += 2)
              (bytes[i] << 8) | bytes[i + 1],
          ])
        : String.fromCharCodes(bytes);
  }
  return '';
}
