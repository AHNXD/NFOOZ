import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localization.dart';

Future<void> setLocale(String languageCode) async {
  var prefs = await SharedPreferences.getInstance();
  await prefs.setString('language_code', languageCode);
}

Future<Locale> getLocale() async {
  var languageCode = await getLang();
  return Locale(languageCode, languageCode == 'en' ? 'US' : 'AE');
}

String? getTranslated(BuildContext context, String key) {
  return ApplicationLocalization.of(context)!.translate(key);
}

Future<String> getLang() async => await getLangWithNull() ?? "en";

Future<String?> getLangWithNull() async {
  var prefs = await SharedPreferences.getInstance();
  var languageCode = prefs.getString('language_code');
  return languageCode;
}
