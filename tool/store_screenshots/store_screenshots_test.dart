// Renders the store screenshots from the real app screens with demo moments.
// Run with tool/store_screenshots/run.sh (see README.md there).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/router/app_router.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/media/data/picked_memory_photo.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/on_this_day/data/on_this_day_providers.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures.dart';
import 'fonts.dart';
import 'store_frame.dart';

const _momentsDir = 'store_listing_assets/store_moments';
const _outDir = 'store_listing_assets/store_screenshots';

/// Serves the demo photos from disk under [momentsPrefix]; everything else
/// comes from the app bundle.
class StoreAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.startsWith(momentsPrefix)) {
      final file = File('$_momentsDir/${key.substring(momentsPrefix.length)}');
      return ByteData.sublistView(await file.readAsBytes());
    }
    return rootBundle.load(key);
  }
}

class _StoreMemoryRepository extends MemoryRepository {
  _StoreMemoryRepository(this.lang);

  final String lang;

  @override
  Future<MemoryState> build() async => storeMemoryState(lang);
}

class _PremiumController extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async {
    return const PremiumEntitlement(isPremium: true, isMockUnlocked: false);
  }
}

typedef _Scene = ({
  String name,
  String caption,
  Future<void> Function(WidgetTester tester, AppLocalizations l10n) open,
});

final List<_Scene> _scenes = [
  (name: 'wall', caption: 'wall', open: (tester, l10n) => _go(tester, '/wall')),
  (
    name: 'memory',
    caption: 'detail',
    open: (tester, l10n) => _go(tester, '/memories/first-dance'),
  ),
  (
    name: 'story',
    caption: 'story',
    open: (tester, l10n) async {
      // A memory without a map pin, scrolled to its story, people and the
      // memories it is threaded to (the vector map does not render in tests).
      await _go(tester, '/memories/garden-dinner');
      final story = storeMemoryState(
        _lang,
      ).events.firstWhere((event) => event.id == 'garden-dinner').description;
      await tester.runAsync(() async {});
      Scrollable.ensureVisible(
        tester.element(find.text(story)),
        alignment: 0.12,
      );
      await _settle(tester);
    },
  ),
  (
    name: 'timeline',
    caption: 'timeline',
    open: (tester, l10n) => _switchMode(tester, l10n.timelineView, l10n),
  ),
  (
    name: 'add',
    caption: 'add',
    open: (tester, l10n) async {
      AppRouter.router.go(
        '/memories/new',
        extra: [
          for (final name in [
            '03_beach_sunset.jpg',
            '02_newborn.jpg',
            '01_first_dance.jpg',
          ])
            PickedMemoryPhoto(
              localPath: File('$_momentsDir/$name').absolute.path,
              capturedAt: DateTime(2025, 7, 26, 19, 40),
              width: 1200,
              height: 896,
              hasCapturedDate: true,
              hasDimensions: true,
              title: storeMemoryState(_lang).events[2].title,
            ),
        ],
      );
      await _settle(tester);
    },
  ),
];

late String _lang;

Future<void> _go(WidgetTester tester, String location) async {
  AppRouter.router.go(location);
  await _settle(tester);
}

Future<void> _switchMode(
  WidgetTester tester,
  String modeLabel,
  AppLocalizations l10n,
) async {
  await _go(tester, '/wall');
  await tester.tap(find.text(l10n.wallControls));
  await _settle(tester);
  // Only look inside the app (the store caption can say "Map" too); the view
  // row comes before the layout row, which also has "Timeline".
  await tester.tap(
    find
        .descendant(
          of: find.byType(MaterialApp),
          matching: find.text(modeLabel),
        )
        .first,
  );
  await _settle(tester);
  _log('mode switched to $modeLabel');
  await tester.tap(find.byTooltip(l10n.hideControlsTooltip));
  await _settle(tester);
}

/// The wall never settles (cards sway in the wind), so pump real time in
/// steps and let image decoding and map tiles finish in between.
Future<void> _settle(WidgetTester tester, {int rounds = 6}) async {
  for (var i = 0; i < rounds; i++) {
    _log('settle $i');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 120)),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }
}

Future<void> _precache(WidgetTester tester) async {
  // Loads started in an earlier test's fake-async zone never finish; start
  // every test from an empty cache.
  imageCache
    ..clear()
    ..clearLiveImages();
  final context = tester.element(find.byType(Navigator).first);
  await tester.runAsync(() async {
    for (final file in Directory(_momentsDir).listSync().whereType<File>()) {
      final name = file.uri.pathSegments.last;
      if (!name.endsWith('.jpg')) continue;
      await precacheImage(AssetImage('$momentsPrefix$name'), context);
      await precacheImage(FileImage(file.absolute), context);
    }
  });
}

Future<void> _capture(WidgetTester tester, StoreSize size, String path) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('store-shot')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: size.pixelRatio);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(path)..createSync(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}

/// The app theme plus the Arabic fallback iOS adds by itself. Button labels
/// with their own text style have no family and fall back to the system font
/// on a phone; flutter_test has none, so they get Avenir here.
ThemeData _storeTheme(ThemeData theme) {
  const fallback = ['SF Arabic'];
  TextStyle? withFont(TextStyle? style) =>
      style?.copyWith(fontFamily: 'Avenir', fontFamilyFallback: fallback);
  ButtonStyle? buttonFont(ButtonStyle? style) => style?.copyWith(
    textStyle: WidgetStatePropertyAll(
      withFont(style.textStyle?.resolve({})) ??
          const TextStyle(fontFamily: 'Avenir', fontFamilyFallback: fallback),
    ),
  );
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamilyFallback: fallback),
    primaryTextTheme: theme.primaryTextTheme.apply(
      fontFamilyFallback: fallback,
    ),
    appBarTheme: theme.appBarTheme.copyWith(
      titleTextStyle: withFont(theme.appBarTheme.titleTextStyle),
    ),
    floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
      extendedTextStyle: withFont(
        theme.floatingActionButtonTheme.extendedTextStyle,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: buttonFont(theme.filledButtonTheme.style),
    ),
    textButtonTheme: TextButtonThemeData(
      style: buttonFont(theme.textButtonTheme.style),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: buttonFont(theme.outlinedButtonTheme.style),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: buttonFont(theme.elevatedButtonTheme.style),
    ),
  );
}

void _log(String message) {
  if (Platform.environment['STORE_DEBUG'] == '1') {
    stderr.writeln(
      '[store] ${DateTime.now().toIso8601String().substring(11, 19)} $message',
    );
  }
}

List<String> _listEnv(String name, List<String> all) {
  final value = Platform.environment[name];
  if (value == null || value.isEmpty) return all;
  return value.split(',');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Map tiles come from the network; flutter_test blocks HTTP by default.
  HttpOverrides.global = null;

  final langs = _listEnv('STORE_LANGS', ['en', 'de', 'ar']);
  final sizes = _listEnv('STORE_SIZES', [for (final s in storeSizes) s.name]);
  final scenes = _listEnv('STORE_SCENES', [for (final s in _scenes) s.name]);

  setUpAll(() async {
    await loadStoreFonts();
    // Map tiles are cached in the temporary directory.
    final temp = await Directory.systemTemp.createTemp('store_screenshots_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => temp.path,
        );
  });

  for (final size in storeSizes.where((s) => sizes.contains(s.name))) {
    for (final lang in langs) {
      for (final (index, scene) in _scenes.indexed) {
        if (!scenes.contains(scene.name)) continue;
        testWidgets('${size.name} $lang ${scene.name}', (tester) async {
          _lang = lang;
          // A test, but outside test/ (it must not run in CI).
          // ignore: invalid_use_of_visible_for_testing_member
          SharedPreferences.setMockInitialValues({
            'onboarding_completed': true,
            'user_display_name': '',
            // Just backed up: no reminder banner on the wall.
            'backup_last_saved_at': DateTime.now().millisecondsSinceEpoch,
          });
          tester.view.physicalSize = size.pixels;
          tester.view.devicePixelRatio = size.pixelRatio;
          addTearDown(tester.view.reset);

          final l10n = lookupAppLocalizations(Locale(lang));
          final (tag, headline, subtitle) =
              storeCaptions[scene.caption]![lang]!;
          final storeTheme = _storeTheme(AppTheme.dark);

          await tester.pumpWidget(
            DefaultAssetBundle(
              bundle: StoreAssetBundle(),
              child: RepaintBoundary(
                key: const ValueKey('store-shot'),
                child: MediaQuery(
                  data: MediaQueryData(size: size.pixels / size.pixelRatio),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: 'Avenir',
                        fontFamilyFallback: ['SF Arabic'],
                      ),
                      child: StoreFrame(
                        size: size,
                        tag: tag,
                        headline: headline,
                        subtitle: subtitle,
                        rtl: lang == 'ar',
                        glowRight: index.isOdd,
                        screen: MediaQuery(
                          data: MediaQueryData(
                            size: size.screen,
                            devicePixelRatio: size.pixelRatio,
                            padding: size.safeArea,
                            viewPadding: size.safeArea,
                          ),
                          child: ProviderScope(
                            overrides: [
                              memoryRepositoryProvider.overrideWith(
                                () => _StoreMemoryRepository(lang),
                              ),
                              premiumEntitlementProvider.overrideWith(
                                _PremiumController.new,
                              ),
                              // Same wall card and memory hero on any run
                              // date (no On this day memory).
                              onThisDayMatchesProvider.overrideWithValue(
                                const [],
                              ),
                            ],
                            child: MaterialApp.router(
                              debugShowCheckedModeBanner: false,
                              theme: storeTheme,
                              locale: Locale(lang),
                              supportedLocales:
                                  AppLocalizations.supportedLocales,
                              localizationsDelegates:
                                  AppLocalizations.localizationsDelegates,
                              routerConfig: AppRouter.router,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          _log('pumped');
          AppRouter.router.go('/wall');
          await tester.pump();
          await _precache(tester);
          _log('precached');
          await scene.open(tester, l10n);
          _log('opened');
          await _settle(tester, rounds: 4);
          _log('settled');

          await _capture(
            tester,
            size,
            '$_outDir/${size.name}/$lang/${(index + 1).toString().padLeft(2, '0')}-${scene.name}.png',
          );
          // Map tiles leave retry timers behind; let them run out.
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump(const Duration(minutes: 2));
        });
      }
    }
  }
}
