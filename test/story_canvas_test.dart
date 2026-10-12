import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:life_threads/core/rendering/story_canvas.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('renders a widget offscreen to a 1080x1920 PNG', (tester) async {
    final png = await tester.runAsync(() async {
      final canvas = StoryCanvas();
      try {
        return await canvas.renderPng(
          const ColoredBox(
            color: Color(0xFF00FF00),
            child: Center(child: Text('Story')),
          ),
        );
      } finally {
        canvas.dispose();
      }
    });

    final decoded = img.decodePng(png!)!;
    expect(decoded.width, 1080);
    expect(decoded.height, 1920);
    final pixel = decoded.getPixel(20, 20);
    expect([pixel.r, pixel.g, pixel.b], [0, 255, 0]);
  });

  testWidgets('waits for images to be decoded', (tester) async {
    final red = Uint8List.fromList(
      img.encodePng(
        img.Image(width: 4, height: 4)..clear(img.ColorRgb8(255, 0, 0)),
      ),
    );

    final png = await tester.runAsync(() async {
      final canvas = StoryCanvas(
        logicalSize: const Size(90, 160),
        pixelRatio: 2,
      );
      try {
        return await canvas.renderPng(
          ColoredBox(
            color: const Color(0xFF0000FF),
            child: Image.memory(red, fit: BoxFit.fill),
          ),
        );
      } finally {
        canvas.dispose();
      }
    });

    final decoded = img.decodePng(png!)!;
    expect(decoded.width, 180);
    expect(decoded.height, 320);
    final pixel = decoded.getPixel(90, 160);
    expect([pixel.r, pixel.g, pixel.b], [255, 0, 0]);
  });

  testWidgets('provides localizations and right-to-left for Arabic', (
    tester,
  ) async {
    late TextDirection direction;
    late String title;

    await tester.runAsync(() async {
      final canvas = StoryCanvas(locale: const Locale('ar'));
      try {
        await canvas.renderPng(
          Builder(
            builder: (context) {
              direction = Directionality.of(context);
              title = AppLocalizations.of(context).onThisDayTitle;
              return const SizedBox.expand();
            },
          ),
        );
      } finally {
        canvas.dispose();
      }
    });

    expect(direction, TextDirection.rtl);
    expect(title, lookupAppLocalizations(const Locale('ar')).onThisDayTitle);
  });

  testWidgets('renders several frames with one canvas', (tester) async {
    final sizes = await tester.runAsync(() async {
      final canvas = StoryCanvas(
        logicalSize: const Size(10, 20),
        pixelRatio: 1,
      );
      try {
        final first = await canvas.renderRgba(
          const ColoredBox(color: Color(0xFFFF0000)),
        );
        final second = await canvas.renderRgba(
          const ColoredBox(color: Color(0xFF0000FF)),
        );
        return [first, second];
      } finally {
        canvas.dispose();
      }
    });

    expect(sizes![0].length, 10 * 20 * 4);
    expect(sizes[0].sublist(0, 3), [255, 0, 0]);
    expect(sizes[1].sublist(0, 3), [0, 0, 255]);
  });
}
