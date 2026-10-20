import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/display/presentation/pages/wall_display_scanner_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';

import 'support/story_fixtures.dart';

/// Set SCANNER_SAMPLES_DIR to keep the rendered screens for a look.
final _samplesDir = Platform.environment['SCANNER_SAMPLES_DIR'];

void main() {
  setUpAll(() async {
    await loadStoryFontsIfAvailable();
  });

  for (final locale in const [Locale('en'), Locale('de'), Locale('ar')]) {
    for (final scale in [1.0, 1.35]) {
      testWidgets('the scanner explains where the QR code is: '
          '${locale.languageCode} ${scale}x', (tester) async {
        // The camera plugin isn't there in tests: it answers "unsupported".
        for (final channel in const ['method', 'event', 'deviceOrientation']) {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
                MethodChannel(
                  'dev.steenbakker.mobile_scanner/scanner/$channel',
                ),
                (call) async => null,
              );
        }
        tester.view.physicalSize = const Size(375, 667) * 3;
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        final boundary = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: boundary,
            child: MaterialApp(
              locale: locale,
              theme: AppTheme.dark.copyWith(
                textTheme: AppTheme.dark.textTheme.apply(
                  fontFamilyFallback: ['SF Arabic'],
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: const WallDisplayScannerPage(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        // Errors from the missing camera are not layout problems.
        final error = tester.takeException();
        expect(
          error == null || '$error'.contains('overflowed') == false,
          isTrue,
          reason: '$error',
        );

        final l10n = lookupAppLocalizations(locale);
        expect(find.text(l10n.scannerHintTitle), findsOneWidget);
        expect(
          find.text(l10n.scannerStep2('lifethreads.gkcoding.dev/display')),
          findsOneWidget,
        );
        // The send label is never cut off (with large text it may wrap).
        expect(find.byKey(const ValueKey('display-copy-link')), findsOneWidget);
        for (final key in ['display-share-link']) {
          final button = find.byKey(ValueKey(key));
          expect(button, findsOneWidget);
          final label = find.descendant(
            of: button,
            matching: find.byType(Text),
          );
          final paragraph = tester.renderObject<RenderParagraph>(label);
          expect(paragraph.didExceedMaxLines, isFalse, reason: key);
        }

        final samples = _samplesDir;
        if (samples != null) {
          final image = await tester.runAsync(() async {
            final render =
                boundary.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            final image = await render.toImage(pixelRatio: 1);
            return image.toByteData(format: ui.ImageByteFormat.png);
          });
          Directory(samples).createSync(recursive: true);
          File(
            '$samples/scanner_${locale.languageCode}_$scale.png',
          ).writeAsBytesSync(image!.buffer.asUint8List());
        }
      });
    }
  }
}
