import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeControllerProvider =
    AsyncNotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends AsyncNotifier<Locale?> {
  static const _selectedLocaleKey = 'selected_locale_code';

  @override
  Future<Locale?> build() async {
    final preferences = await SharedPreferences.getInstance();
    final code = preferences.getString(_selectedLocaleKey);
    if (code == null || code.isEmpty) return null;
    return Locale(code);
  }

  Future<void> useSystemLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_selectedLocaleKey);
    state = const AsyncData(null);
  }

  Future<void> selectLocale(Locale locale) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_selectedLocaleKey, locale.languageCode);
    state = AsyncData(locale);
  }
}
