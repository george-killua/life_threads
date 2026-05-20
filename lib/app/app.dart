import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

class LifeThreadsApp extends StatelessWidget {
  const LifeThreadsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LifeThreads',
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
