// Renders the App Review screenshot of the Premium subscription: the
// Premium page as a new user sees it on an iPhone 6.9" (1320×2868), with the
// price, the Subscribe button, the renewal terms and the Terms / Privacy
// links. No store caption or device frame.
//
//   flutter test tool/store_screenshots/review_screenshot_test.dart
//
// Output: store_listing_assets/app_review/premium_<lang>_<part>.png
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/app/theme/app_theme.dart';
import 'package:life_threads/features/memories/data/memory_repository.dart';
import 'package:life_threads/features/premium/data/premium_billing_controller.dart';
import 'package:life_threads/features/premium/data/premium_entitlement_controller.dart';
import 'package:life_threads/features/premium/domain/premium_entitlement.dart';
import 'package:life_threads/features/premium/domain/premium_purchase_state.dart';
import 'package:life_threads/features/premium/presentation/pages/upgrade_page.dart';
import 'package:life_threads/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fixtures.dart';
import 'fonts.dart';
import 'store_frame.dart';

const _outDir = 'store_listing_assets/app_review';

class _DemoMemories extends MemoryRepository {
  _DemoMemories(this.lang);

  final String lang;

  @override
  Future<MemoryState> build() async => storeMemoryState(lang);
}

class _FreeUser extends PremiumEntitlementController {
  @override
  Future<PremiumEntitlement> build() async =>
      const PremiumEntitlement(isPremium: false, isMockUnlocked: false);
}

/// The product as the App Store returns it, without talking to a store.
class _ReadyStore extends PremiumBillingController {
  @override
  PremiumPurchaseState build() => const PremiumPurchaseState(
    status: PremiumPurchaseStatus.ready,
    productId: 'lifethreads_premium_monthly',
    price: '€2.99',
    canBuy: true,
  );
}

ThemeData _withStoreFonts(ThemeData theme) {
  const fallback = ['SF Arabic'];
  ButtonStyle? font(ButtonStyle? style) => style?.copyWith(
    textStyle: WidgetStatePropertyAll(
      (style.textStyle?.resolve({}) ?? const TextStyle()).copyWith(
        fontFamily: 'Avenir',
        fontFamilyFallback: fallback,
      ),
    ),
  );
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamilyFallback: fallback),
    filledButtonTheme: FilledButtonThemeData(
      style: font(theme.filledButtonTheme.style),
    ),
    textButtonTheme: TextButtonThemeData(
      style: font(theme.textButtonTheme.style ?? TextButton.styleFrom()),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: font(
        theme.outlinedButtonTheme.style ?? OutlinedButton.styleFrom(),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final size = storeSizes.firstWhere((s) => s.name == 'ios-6.9');

  setUpAll(() async {
    await loadStoreFonts();
    // Release builds have no debug unlock button.
    // A test, but outside test/ (it must not run in CI).
    // ignore: invalid_use_of_visible_for_testing_member
    UpgradePage.showDebugUnlock = false;
  });

  for (final lang in ['en', 'de', 'ar']) {
    testWidgets('premium $lang', (tester) async {
      // A test, but outside test/ (it must not run in CI).
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({'onboarding_completed': true});
      tester.view.physicalSize = size.pixels;
      tester.view.devicePixelRatio = size.pixels.width / size.screen.width;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        RepaintBoundary(
          key: const ValueKey('review-shot'),
          child: ProviderScope(
            overrides: [
              memoryRepositoryProvider.overrideWith(() => _DemoMemories(lang)),
              premiumEntitlementProvider.overrideWith(_FreeUser.new),
              premiumBillingProvider.overrideWith(_ReadyStore.new),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: _withStoreFonts(AppTheme.dark),
              locale: Locale(lang),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(padding: size.safeArea, viewPadding: size.safeArea),
                child: child!,
              ),
              home: const UpgradePage(),
            ),
          ),
        ),
      );
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 80)),
        );
        await tester.pump(const Duration(milliseconds: 300));
      }
      await _capture(tester, '$_outDir/premium_${lang}_1_top.png');

      // The subscription offer with price, renewal terms and legal links.
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('premium-privacy')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 160));
      await tester.pump(const Duration(milliseconds: 600));
      await _capture(tester, '$_outDir/premium_${lang}_2_offer.png');
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  }
}

Future<void> _capture(WidgetTester tester, String path) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(const ValueKey('review-shot')),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(
      pixelRatio: tester.view.devicePixelRatio,
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(path)..createSync(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
    image.dispose();
  });
}
