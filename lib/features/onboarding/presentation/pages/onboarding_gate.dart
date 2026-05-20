import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wall/presentation/pages/memory_wall_page.dart';
import '../../onboarding_preferences.dart';
import 'onboarding_page.dart';

class OnboardingGate extends ConsumerWidget {
  const OnboardingGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: ref.read(onboardingPreferencesProvider).isCompleted(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data! ? const MemoryWallPage() : const OnboardingPage();
      },
    );
  }
}
