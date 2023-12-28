import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:nfooz_webapp/Screens/HomeScreen.dart';
import 'package:nfooz_webapp/Screens/app_user.dart';
import 'package:nfooz_webapp/Screens/login.dart';
import 'package:nfooz_webapp/Screens/signup.dart';
import 'package:nfooz_webapp/constant.dart';
import 'package:nfooz_webapp/themes/hex_color.dart';
import 'package:nfooz_webapp/util/Localization/language_constants.dart';

import 'util/Localization/app_localization.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  platform = Platform.operatingSystem;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    getLang().then((value) => lang = value);
    user = User();
    user!.setData();
    super.initState();
  }

  Locale _locale = const Locale("en", "US");
  void setLocale(Locale locale) {
    _locale = locale;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NFOOZ",
      theme: ThemeData(
        primarySwatch: HexColor.colorNfoozPrimary,
        secondaryHeaderColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.white,
        brightness: Brightness.light,
      ),
      locale: _locale,
      supportedLocales: const [Locale("en", "US"), Locale("ar", "AE")],
      localizationsDelegates: const [
        ApplicationLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: const HomeScreen(showSplash: true),
      routes: {
        HomeScreen.id: (context) => const HomeScreen(showSplash: true),
        Login.id: (context) => const Login(),
        SignupPage.id: (context) => const SignupPage(
              title: '',
              doneText: '',
              checkAccOnly: true,
            ),
      },
    );
  }
}
