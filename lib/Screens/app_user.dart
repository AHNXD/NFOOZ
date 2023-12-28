import 'dart:convert';

import 'package:nfooz_webapp/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String? id;
  dynamic data;

  void setData() async {
    Map<String, dynamic>? json = await User.getUserInformation();
    if (json != null) {
      id = json['id'].toString();
      data = json;
      link =
          "https://booking.nfooz.com/nfooz/pages/nfooz/booking.aspx?lang=$lang&layout=incontainer&platform=$platform&usr=${data["guid"]}";
    } else {
      id = null;
    }
  }

  static Future<Map<String, dynamic>?> getUserInformation() async {
    var prefs = await SharedPreferences.getInstance();
    String? strData = prefs.getString("user_json");
    if (strData == null || strData == "") {
      return null;
    } else {
      return jsonDecode(strData);
    }
  }

  static void saveUserInformation(userData) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_json", jsonEncode(userData));
  }
}
