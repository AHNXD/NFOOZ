// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nfooz_webapp/Screens/splash.dart';
import 'package:nfooz_webapp/main.dart';
import 'package:nfooz_webapp/util/Localization/language_constants.dart';
import 'package:nfooz_webapp/util/common.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:nfooz_webapp/constant.dart';
import 'package:nfooz_webapp/src/menu.dart';
import 'package:nfooz_webapp/src/web_view_stack.dart';

import '../src/navigation_controls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.showSplash});
  static String id = "/HomeScreen";
  final bool showSplash;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController controller;

  void _changeLanguage(String languageCode) async {
    lang = languageCode;
    await setLocale(languageCode);
    context.findAncestorStateOfType<MyAppState>()?.setLocale(await getLocale());
    if (user!.id == null) {
      link =
          "https://booking.nfooz.com/nfooz/pages/nfooz/booking.aspx?lang=$lang&layout=incontainer&platform=$platform";
    } else {
      link =
          "https://booking.nfooz.com/nfooz/pages/nfooz/booking.aspx?lang=$lang&layout=incontainer&platform=$platform&usr=${user!.data["guid"]}";
    }
    Navigator.pop(context);
    push(context, const HomeScreen(showSplash: false));
  }

  Splash? splash;
  bool waitDrawing = false;
  @override
  void initState() {
    super.initState();
    if (widget.showSplash) {
      waitDrawing = true;
      splash = Splash(
        setLang: _changeLanguage,
        nextRoute: () => setState(() => splash = null),
        paintNextRout: () => setState(() => waitDrawing = false),
      );
    }
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(link!),
      );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
    //_streamController.stream.
    //if(_dashboard!=null)
    //_dashboard
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Stack(
          children: [
            waitDrawing
                ? Container()
                : lang == null
                    ? Container()
                    : Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.lightGreen,
                          title: Image.asset("images/logo/nfooz-logo-white.png",
                              height: 35),
                          actions: [
                            NavigationControls(controller: controller),
                            Menu(controller: controller),
                            IconButton(
                                onPressed: () {
                                  _changeLanguage(lang == "ar" ? "en" : "ar");
                                },
                                icon: const Icon(Icons.language))
                          ],
                        ),
                        body: WebViewStack(
                          controller: controller,
                        )),
            splash ?? Container(),
          ],
        ));
  }
}
