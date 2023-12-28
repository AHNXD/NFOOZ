import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfooz_webapp/util/Localization/language_constants.dart';
import 'package:nfooz_webapp/util/common.dart';
import 'package:upgrader/upgrader.dart';

class Splash extends StatefulWidget {
  static const id = "/splash";
  final VoidCallback nextRoute;
  final Function(String lang) setLang;
  final Function() paintNextRout;
  const Splash({
    Key? key,
    required this.nextRoute,
    required this.setLang,
    required this.paintNextRout,
  }) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late int anim = 0;
  //0  pause at beginning
  //1  logo goes down
  //2  logo stop, check update
  //3  exiting

  // ignore: avoid_init_to_null
  bool? chooseLanguage = null;

  @override
  void initState() {
    super.initState();
    getLangWithNull()
        .then((value) => setState(() => chooseLanguage = value == null));
    Timer(const Duration(milliseconds: 400), _moveNext);
  }

  void _moveNext() {
    anim += 1;
    if (anim == 2) widget.paintNextRout();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Upgrader().clearSavedSettings();
    return GestureDetector(
      onTap: () {
        if (!chooseLanguage!) _moveNext();
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        padding: EdgeInsets.only(top: anim >= 3 ? 1000 : 0),
        curve: Curves.easeOut,
        onEnd: widget.nextRoute,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  anim <= 1 ? Container() : UpgradeAlert(child: Container()),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    padding: EdgeInsets.only(bottom: anim == 0 ? 800 : 0),
                    curve: Curves.bounceOut,
                    onEnd: () {
                      _moveNext();
                      if (!chooseLanguage!) {
                        Timer(const Duration(seconds: 2), _moveNext);
                      }
                    },
                    child: Image.asset(
                        "images/logo/nfooz_logo_TM_with_text.png",
                        width: 290),
                  ),
                  const Padding(padding: EdgeInsets.all(40)),
                  chooseLanguage == null
                      ? isLoading()
                      : chooseLanguage!
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              // crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                langButton("English", "en"),
                                langButton("عربي", "ar"),
                              ],
                            )
                          : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton langButton(String title, String langCode) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(150, 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0))),
        onPressed: () {
          _moveNext();
          widget.setLang(langCode);
        },
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
  }
}
