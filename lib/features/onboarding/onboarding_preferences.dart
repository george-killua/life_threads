import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingPreferencesProvider = Provider<OnboardingPreferences>((ref) {
  return const OnboardingPreferences();
});

class OnboardingPreferences {
  const OnboardingPreferences();

  static const _completedKey = 'onboarding_completed';
  static const _demoWallKey = 'demo_wall_enabled';

  Future<bool> isCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_completedKey) ?? false;
  }

  Future<bool> shouldUseDemoWall() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_demoWallKey) ?? false;
  }

  Future<void> markCompleted({required bool useDemoWall}) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_demoWallKey, useDemoWall);
    await preferences.setBool(_completedKey, true);
  }

  Future<void> disableDemoWall() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_demoWallKey, false);
  }
}
