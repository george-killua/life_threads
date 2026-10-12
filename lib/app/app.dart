import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/locale_controller.dart';
import '../features/capsule/presentation/widgets/memory_capsule_deep_link_listener.dart';
import '../features/family/presentation/widgets/family_invite_link_listener.dart';
import '../features/on_this_day/data/on_this_day_scheduler.dart';
import '../features/premium/data/premium_billing_controller.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class LifeThreadsApp extends ConsumerWidget {
  const LifeThreadsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).asData?.value;
    // Keep the store listener alive for the whole app session: purchases can
    // be delivered at any time (approved pending payments, interrupted
    // checkouts) and must be acknowledged even if the upgrade page is closed.
    ref.listen(premiumBillingProvider, (_, _) {});
    // Reschedules On this day reminders as settings and memories change.
    ref.listen(onThisDaySchedulerProvider, (_, _) {});

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LifeThreads',
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.dark,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: AppRouter.router,
      builder: (context, child) => MemoryCapsuleDeepLinkListener(
        child: FamilyInviteLinkListener(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
