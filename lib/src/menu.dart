// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nfooz_webapp/Screens/HomeScreen.dart';
import 'package:nfooz_webapp/Screens/login.dart';
import 'package:nfooz_webapp/constant.dart';
import 'package:nfooz_webapp/util/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum _MenuOptions {
  //navigationDelegate,
  //userAgent,
  //javascriptChannel,
  listCookies,
  clearCookies,
  addCookie,
  setCookie,
  removeCookie,
  signInOrUp,
  signOut,
}

class Menu extends StatefulWidget {
  const Menu({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final cookieManager = WebViewCookieManager();

  Future<void> _onListCookies(WebViewController controller) async {
    final String cookies = await controller
        .runJavaScriptReturningResult('document.cookie') as String;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cookies.isNotEmpty ? cookies : 'There are no cookies.'),
      ),
    );
  }

  Future<void> _onClearCookies() async {
    final hadCookies = await cookieManager.clearCookies();
    String message = 'Done';
    if (!hadCookies) {
      message = 'There were no cookies to clear.';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> _onAddCookie(WebViewController controller) async {
    await controller.runJavaScript('''var date = new Date();
  date.setTime(date.getTime()+(30*24*60*60*1000));
  document.cookie = "FirstName=John; expires=" + date.toGMTString();''');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie added.'),
      ),
    );
  }

  Future<void> _onSetCookie(WebViewController controller) async {
    await cookieManager.setCookie(
      const WebViewCookie(name: 'foo', value: 'bar', domain: 'flutter.dev'),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie is set.'),
      ),
    );
  }

  Future<void> _onRemoveCookie(WebViewController controller) async {
    await controller.runJavaScript(
        'document.cookie="FirstName=John; expires=Thu, 01 Jan 1970 00:00:00 UTC" ');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Custom cookie removed.'),
      ),
    );
  }

  Future<void> _signInOrUp(WebViewController controller) async {
    _onClearCookies();
    await Navigator.pushNamed(context, Login.id);
    Navigator.pop(context);
    push(context, const HomeScreen(showSplash: false));
    controller.reload();
  }

  Future<void> _signOut(WebViewController controller) async {
    _onClearCookies();
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_json");
    link =
        "https://booking.nfooz.com/nfooz/pages/nfooz/booking.aspx?lang=$lang&layout=incontainer&platform=$platform";
    Navigator.pop(context);
    push(context, const HomeScreen(showSplash: false));
    controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuOptions>(
      onSelected: (value) async {
        switch (value) {
          /*case _MenuOptions.navigationDelegate:
            await widget.controller
                .loadRequest(Uri.parse('https://youtube.com'));
            break;
          case _MenuOptions.userAgent:
            final userAgent = await widget.controller
                .runJavaScriptReturningResult('navigator.userAgent');
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$userAgent'),
            ));
            break;
          case _MenuOptions.javascriptChannel:
            await widget.controller.runJavaScript('''
                  var req = new XMLHttpRequest();
                  req.open('GET', "https://api.ipify.org/?format=json");
                  req.onload = function() {
                    if (req.status == 200) {
                      let response = JSON.parse(req.responseText);
                      SnackBar.postMessage("IP Address: " + response.ip);
                    } else {
                      SnackBar.postMessage("Error: " + req.status);
                    }
                  }
                  req.send();''');
            break;*/
          case _MenuOptions.clearCookies:
            await _onClearCookies();
            break;
          case _MenuOptions.listCookies:
            await _onListCookies(widget.controller);
            break;
          case _MenuOptions.addCookie:
            await _onAddCookie(widget.controller);
            break;
          case _MenuOptions.setCookie:
            await _onSetCookie(widget.controller);
            break;
          case _MenuOptions.removeCookie:
            await _onRemoveCookie(widget.controller);
            break;
          case _MenuOptions.signInOrUp:
            await _signInOrUp(widget.controller);
            break;
          case _MenuOptions.signOut:
            await _signOut(widget.controller);
            break;
        }
      },
      itemBuilder: (context) => [
        /*const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.navigationDelegate,
          child: Text('Navigate to YouTube'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.userAgent,
          child: Text('Show user-agent'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.javascriptChannel,
          child: Text('Lookup IP Address'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.listCookies,
          child: Text('List cookies'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.addCookie,
          child: Text('Add cookie'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.setCookie,
          child: Text('Set cookie'),
        ),
        const PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.removeCookie,
          child: Text('Remove cookie'),
        ),*/
        PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.signInOrUp,
          child: Text(lang == "en" ? 'Sign in or up' : 'تسجيل دخول'),
        ),
        PopupMenuItem<_MenuOptions>(
          value: _MenuOptions.signOut,
          child: Text(lang == "en" ? 'Sign Out' : 'تسجيل خروج'),
        ),
      ],
    );
  }
}
