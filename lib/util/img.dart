import 'package:flutter/widgets.dart';
import 'package:nfooz_webapp/util/common.dart';

class NetImg {
  static NetworkImage? get(String? id, {int? w, int? h}) {
    var url =
        "$url_base/img.ashx?rowid=$id${w == null ? "" : "&w=$w"}${h == null ? "" : "&h=$h"}";
    if (id == null || id == "") {
      return null;
    } else {
      return NetworkImage(url);
    }
  }

  static Widget getHero(String? id, {int? w, int? h}) {
    return Hero(
      tag: id!,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetImg.get(id, w: w, h: h)!,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
