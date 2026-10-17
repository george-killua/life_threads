import 'package:flutter/widgets.dart';

/// The Terms of Use and Privacy Policy on gkcoding.dev, in the app's
/// language: German and Arabic have their own pages, every other language
/// opens the English one (which also links the others).
abstract final class LegalLinks {
  static Uri terms(BuildContext context) =>
      termsFor(Localizations.localeOf(context));

  static Uri privacy(BuildContext context) =>
      privacyFor(Localizations.localeOf(context));

  static Uri termsFor(Locale locale) => _page('terms', locale);

  static Uri privacyFor(Locale locale) => _page('privacy', locale);

  static Uri _page(String page, Locale locale) {
    final language = switch (locale.languageCode) {
      'de' => 'de/',
      'ar' => 'ar/',
      _ => '',
    };
    return Uri.parse('https://gkcoding.dev/lifethreads/$page/$language');
  }
}
