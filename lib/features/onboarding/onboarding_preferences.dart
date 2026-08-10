import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingPreferencesProvider = Provider<OnboardingPreferences>((ref) {
  return const OnboardingPreferences();
});

final userDisplayNameProvider =
    AsyncNotifierProvider<UserDisplayNameController, String>(
      UserDisplayNameController.new,
    );

class UserDisplayNameController extends AsyncNotifier<String> {
  @override
  Future<String> build() {
    return ref.read(onboardingPreferencesProvider).getDisplayName();
  }

  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    await ref.read(onboardingPreferencesProvider).setDisplayName(trimmed);
    if (!ref.mounted) return;
    state = AsyncData(trimmed);
  }
}

class OnboardingPreferences {
  const OnboardingPreferences();

  static const _completedKey = 'onboarding_completed';
  static const _demoWallKey = 'demo_wall_enabled';
  static const _displayNameKey = 'user_display_name';

  Future<bool> isCompleted() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_completedKey) ?? false;
  }

  Future<bool> shouldUseDemoWall() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_demoWallKey) ?? false;
  }

  Future<String> getDisplayName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_displayNameKey)?.trim() ?? '';
  }

  Future<void> setDisplayName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      await preferences.remove(_displayNameKey);
    } else {
      await preferences.setString(_displayNameKey, trimmed);
    }
  }

  Future<void> markCompleted({
    required bool useDemoWall,
    required String displayName,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) {
      await preferences.remove(_displayNameKey);
    } else {
      await preferences.setString(_displayNameKey, trimmed);
    }
    await preferences.setBool(_demoWallKey, useDemoWall);
    await preferences.setBool(_completedKey, true);
  }

  Future<void> disableDemoWall() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_demoWallKey, false);
  }
}
