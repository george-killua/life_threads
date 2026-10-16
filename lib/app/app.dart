import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/locale_controller.dart';
import '../core/widgets/dismiss_keyboard_on_tap.dart';
import '../features/app_lock/app_lock_gate.dart';
import '../features/capsule/presentation/widgets/memory_capsule_deep_link_listener.dart';
import '../features/family/presentation/widgets/family_invite_link_listener.dart';
import '../features/home_widget/data/home_widget_sync.dart';
import '../features/home_widget/presentation/home_widget_link_listener.dart';
import '../features/memories/data/memory_repository.dart';
import '../features/on_this_day/data/on_this_day_scheduler.dart';
import '../features/premium/data/premium_billing_controller.dart';
import '../features/wall/data/wall_theme_controller.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

class LifeThreadsApp extends ConsumerWidget {
  const LifeThreadsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).asData?.value;
    final wallTheme = ref.watch(effectiveWallThemeProvider);
    // Set before any screen builds, so AppColors match the theme below.
    AppColors.use(ThemePalette.of(wallTheme));
    ref.listen(effectiveWallThemeProvider, (previous, next) {
      if (previous?.id == next.id) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) _refreshAll(context);
      });
    });
    // The demo wall speaks the app's language, also after a change.
    ref.listen(localeControllerProvider, (previous, next) {
      final before = previous?.asData?.value;
      if (!next.hasValue || before == next.value) return;
      ref
          .read(memoryRepositoryProvider.notifier)
          .localizeDemoWall(
            next.value ?? WidgetsBinding.instance.platformDispatcher.locale,
          )
          .ignore();
    });
    // Keep the store listener alive for the whole app session: purchases can
    // be delivered at any time (approved pending payments, interrupted
    // checkouts) and must be acknowledged even if the upgrade page is closed.
    ref.listen(premiumBillingProvider, (_, _) {});
    // Reschedules On this day reminders as settings and memories change.
    ref.listen(onThisDaySchedulerProvider, (_, _) {});
    // Keeps the home screen widget's memories current.
    ref.listen(homeWidgetSyncProvider, (_, _) {});

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LifeThreads',
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.forWall(wallTheme),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: AppRouter.router,
      // Text grows with the phone's text size up to twice the normal size:
      // every screen is laid out to stay readable there, without splitting
      // words.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 2,
        // A tap outside a text field closes the keyboard.
        child: DismissKeyboardOnTap(
          child: AppLockGate(
            child: MemoryCapsuleDeepLinkListener(
              child: FamilyInviteLinkListener(
                child: HomeWidgetLinkListener(
                  child: child ?? const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rebuilds and repaints every screen below [context], so widgets and
/// painters that read [AppColors] pick up a new wall theme. Unlike replacing
/// the tree, this keeps scroll positions, text fields and open pages.
void _refreshAll(BuildContext context) {
  void visit(Element element) {
    element.markNeedsBuild();
    if (element is RenderObjectElement) element.renderObject.markNeedsPaint();
    element.visitChildren(visit);
  }

  (context as Element).visitChildren(visit);
}
