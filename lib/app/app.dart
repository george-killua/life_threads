import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/locale_controller.dart';
import '../features/capsule/presentation/widgets/memory_capsule_deep_link_listener.dart';
import '../l10n/generated/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class LifeThreadsApp extends ConsumerWidget {
  const LifeThreadsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider).asData?.value;

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
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
