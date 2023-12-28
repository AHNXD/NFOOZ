// ignore_for_file: constant_identifier_names, overridden_fields, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const String url_base = "https://booking.nfooz.com/nfooz";
const String url_svc_root = "$url_base/webservices/webservice.asmx";
const String url_book = "$url_base/pages/nfooz/booking.aspx";

class MyField extends Container {
  @override
  final Widget child;
  MyField(this.child, {super.key}) : super(child: child, color: Colors.white);
}

Future<dynamic> push(BuildContext c, Widget w) {
  return Navigator.push(c, MaterialPageRoute(builder: (c) => w));
}

Future<dynamic> popAndPush(BuildContext c, Widget w) {
  Navigator.pop(c);
  return push(c, w);
}

Container isLoading() {
  return Container(
    child: const Center(
      child: CircularProgressIndicator(backgroundColor: Colors.white),
    ),
  );
}

// todayDate(String jsonDate) =>
//     DateFormat('dd-MM-yyyy').format(DateFormat("yyyy-MM-dd").parse(jsonDate));

void launcher(String url) async {
  // if (await canLaunch(url)) {
  await launchUrlString(url);
  // } else {
  //   throw 'Could not launch $url';
  // }
}
