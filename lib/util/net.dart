import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class Net {
  static Future<dynamic> getJson(String url, {Object? body}) async {
    // print(url);
    try {
      var uri = Uri.parse(url);
      var headers = {"Accept": "applications/json"};
      http.Response response;
      if (body == null) {
        response = await http.get(uri, headers: headers);
      } else
      // response = await http.post(
      //   uri,
      //   headers: {
      //     "Accept": "applications/json",
      //     "Content-Type": "application/octet-stream"
      //   },
      //   body: body,
      // );
      {
        headers.addAll({"Content-Type": "application/octet-stream"});
        var request = http.Request("GET", uri)
          ..headers.addAll(headers)
          ..bodyBytes = body as Uint8List;

        response = await http.Response.fromStream(await request.send());
      }
      var s = response.body;
      if (response.statusCode != 200) throw Exception("err:$s");
      if (s == "") return "";
      var j = json.decode(s);
      var er = j['errors'];
      if (er != null) throw Exception(er);
      var data = j['data'];
      if (data == null) {
        //throw Exception("no-data");
        return j;
      } else {
        return data;
      }
    } catch (e) {
      throw Exception('$e'.replaceAll("Exception: ", ""));
    }
  }

  static Future<List<dynamic>> getJsonList(String url) async {
    var js = await Net.getJson(url);
    return List<dynamic>.generate(js.length, (i) => js[i]);
  }
}
