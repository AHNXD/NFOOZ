import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationLocalization {
  ApplicationLocalization(this.locale);

  final Locale locale;
  static ApplicationLocalization? of(BuildContext context) {
    return Localizations.of<ApplicationLocalization>(
        context, ApplicationLocalization);
  }

  late Map<String, String> _localizedValues;

  Future<void> load() async {
    String jsonStringValues =
        await rootBundle.loadString('i18n/${locale.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedValues[key] ?? "??";
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<ApplicationLocalization> delegate =
      _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<ApplicationLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<ApplicationLocalization> load(Locale locale) async {
    ApplicationLocalization localization = ApplicationLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<ApplicationLocalization> old) =>
      false;
}
