import 'package:flutter/material.dart';
import 'package:nfooz_webapp/constant.dart';
import 'package:nfooz_webapp/themes/hex_color.dart';
import 'package:nfooz_webapp/Screens/signup.dart';
import 'package:nfooz_webapp/util/common.dart';
import 'package:nfooz_webapp/util/Localization/language_constants.dart';
import 'package:nfooz_webapp/util/net.dart';
import 'app_user.dart';

class Login extends StatefulWidget {
  static const id = "/login";
  final VoidCallback? refresh;
  const Login({Key? key, this.refresh}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  actionLogin(String username, String password) {
    String url =
        '$url_svc_root/Authenticate?lang=en&username=$username&password=$password';
    Net.getJsonList(url).then((js) {
      var userData = js[0];
      User.saveUserInformation(userData);
      if (widget.refresh != null) widget.refresh!();
      link =
          "https://booking.nfooz.com/nfooz/pages/nfooz/booking.aspx?lang=$lang&layout=incontainer&platform=$platform&usr=${userData["guid"]}";
      Navigator.pop(context);
    }).catchError((e) => showBottomSheet(context, e.message));
  }

  static showBottomSheet(BuildContext context, String msg) {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) => Container(
              height: 100,
              color: HexColor.colorNfoozPrimary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg, //getTranslated(context, "messages_authentication_error")!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      // color: HexColor.colorMaroon,
                      child: Text(
                        getTranslated(context, "ok_")!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
            ));
  }

  final editingController = TextEditingController();
  final passwordEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, 'LOGIN')!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 3,
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    MyField(
                      TextFormField(
                        controller: editingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: Icon(
                            Icons.person,
                            color: HexColor.colorNfoozGreen,
                          ),
                          border: const OutlineInputBorder(),
                          labelText: getTranslated(context, 'sign_in_username'),
                        ),
                        maxLines: 1,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter some text' : null,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    ),
                    MyField(TextFormField(
                      controller: passwordEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: HexColor.colorNfoozGreen,
                        ),
                        border: const OutlineInputBorder(),
                        labelText: getTranslated(context, 'sign_in_password'),
                      ),
                      maxLines: 1,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter some text' : null,
                    )),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        GestureDetector(
                            onTap: () =>
                                popAndPush(context, forgetPassword(context)),
                            child: Text(
                                getTranslated(context, 'forgot_password')!))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 35.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(getTranslated(context, 'LOGIN')!),
                        onPressed: () => formKey.currentState!.validate()
                            ? actionLogin(
                                editingController.text,
                                passwordEditingController.text,
                              )
                            : null,
                        // elevation: 4.0,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
                        // color: HexColor.colorPrimary,
                        // textColor: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                    ),
                    SizedBox(
                      height: 35.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(getTranslated(context, 'sign_up_button')!),
                        onPressed: () => popAndPush(context, signUp(context)),
                        // elevation: 4.0,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
                        // color: HexColor.colorMaroon,
                        // textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // GestureDetector(
                    //   child: Center(
                    //     child: Text(
                    //       'ar_login_skip',
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUp(BuildContext context) {
    // return MyWebView(
    //   selectedUrl: "http://nfooz.ae/csa/pages/awd/default.aspx?lang=" +
    //       appLang! +
    //       "&form=mobile",
    //   title: getTranslated(context, 'sign_up_header'),
    // );
    return SignupPage(
      title: lang == 'ar' ? "إنشاء حساب جديد" : 'Create an account',
      doneText: lang == 'ar' ? "تم إنشاء الحساب" : "Account Created",
      checkAccOnly: false,
      loginFunc: actionLogin,
    );
  }

  Widget forgetPassword(BuildContext context) {
    // String url =
    //     appLang == "en" ? Const.FORGOT_PASSWORD_ENG : Const.FORGOT_PASSWORD_AR;
    // push(
    //   context,
    //   MyWebView(
    //     selectedUrl: url,
    //     title: getTranslated(context, 'sign_up_header'),
    //   ),
    // );
    return SignupPage(
      title: lang == "ar" ? "تغيير كلمة السر" : 'Reset Password',
      doneText: lang == "ar" ? "تم التحديث" : "Password has been Reset",
      checkAccOnly: true,
      //loginFunc: actionLogin,
    );
  }
}
