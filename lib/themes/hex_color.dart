import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw const FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  static Map<int, Color> mycolor = {
    50: const Color.fromRGBO(255, 92, 87, .1),
    100: const Color.fromRGBO(255, 92, 87, .2),
    200: const Color.fromRGBO(255, 92, 87, .3),
    300: const Color.fromRGBO(255, 92, 87, .4),
    400: const Color.fromRGBO(255, 92, 87, .5),
    500: const Color.fromRGBO(255, 92, 87, .6),
    600: const Color.fromRGBO(255, 92, 87, .7),
    700: const Color.fromRGBO(255, 92, 87, .8),
    800: const Color.fromRGBO(255, 92, 87, .9),
    900: const Color.fromRGBO(255, 92, 87, 1),
  };

  //static MaterialColor colorNfoozPrimary = MaterialColor(0xFF84AD4E, mycolor);
  static MaterialColor colorNfoozPrimary = MaterialColor(0xFFa1D55E, mycolor);
  //static MaterialColor colorNfoozGreen = MaterialColor(0xFF159124, mycolor);
  static MaterialColor colorNfoozGreen = MaterialColor(0xFFa1D55E, mycolor);
  static MaterialColor colorAccent = MaterialColor(0xFFAF890D, mycolor);
  static MaterialColor colorFacebook = MaterialColor(0xFF3E5C9A, mycolor);
  static MaterialColor colorYoutube = MaterialColor(0xFFFF0000, mycolor);
  static MaterialColor colorInstagram = MaterialColor(0xFFD65059, mycolor);
  static MaterialColor colorTwitter = MaterialColor(0xFF159124, mycolor);
}
