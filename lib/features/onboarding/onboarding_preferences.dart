import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingPreferencesProvider = Provider<OnboardingPreferences>((ref) {
  return const OnboardingPreferences();
});

class OnboardingPreferences {
  const OnboardingPreferences();

  static const _completedKey = 'onboarding_completed';

  Future<bool> isCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_completedKey) ?? false;
  }

  Future<void> markCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_completedKey, true);
  }
}
