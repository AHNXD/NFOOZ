// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const PrimaryColor = Color(0xFFb71c1c);
const PrimaryColorLight = Color(0xFFf05545);
const PrimaryColorDark = Color(0xFF7f0000);

const SecondaryColor = Color(0xFFb2dfdb);
const SecondaryColorLight = Color(0xFFe5ffff);
const SecondaryColorDark = Color(0xFF82ada9);

const Background = Color(0xFFfffdf7);
const TextColor = Color(0xFFffffff);

class MyTheme {
  static final ThemeData defaultTheme = _buildMyTheme();

  static ThemeData _buildMyTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      // accentColor: SecondaryColor,
      // accentColorBrightness: Brightness.dark,

      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,
      //primaryColorBrightness: Brightness.dark,

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      scaffoldBackgroundColor: Background,
      cardColor: Background,

      textTheme: base.textTheme.copyWith(
          titleLarge: base.textTheme.titleLarge!.copyWith(color: TextColor),
          bodyLarge: base.textTheme.bodyLarge!.copyWith(color: TextColor),
          bodyMedium: base.textTheme.bodyMedium!.copyWith(color: TextColor)),
    );
  }
}
