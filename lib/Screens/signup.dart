// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:nfooz_webapp/constant.dart';
import 'package:nfooz_webapp/util/common.dart';
import 'package:nfooz_webapp/util/net.dart';
import 'dart:io';

class SignupPage extends StatefulWidget {
  static const id = "/signup";
  final String title;
  final String doneText;

  final bool checkAccOnly;
  final Function(String username, String password)? loginFunc;
  const SignupPage(
      {super.key,
      required this.title,
      required this.doneText,
      required this.checkAccOnly,
      this.loginFunc});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  int currentStep = 0;
  bool complete = false;
  String? userid;
  late Object? _selectedChannel = "mobile";
  final _fEMail = TextEditingController();
  final _fMobile = TextEditingController();
  final _fOTP = TextEditingController();
  final _fFullName = TextEditingController();
  Object? _selectedGender;
  final _fLoginID = TextEditingController();
  final _fPassword1 = TextEditingController();
  final _fPassword2 = TextEditingController();
  dynamic usr;
  // InputDecoration fMobile;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getData(String url) async {
    setState(() => busy = true);
    try {
      return await Net.getJson(url);
    } catch (e) {
      showError((e as dynamic).message);
    } finally {
      setState(() => busy = false);
    }
  }

  bool busy = false;
  Future next() async {
    if (!_formKeys[currentStep].currentState!.validate()) return;
    if (currentStep == 0) {
      if (_fMobile.text != "" || _fEMail.text != "") {
        var params =
            'lang=$lang&email=${_fEMail.text}&mobile=${_fMobile.text}&checkAccOnly=${widget.checkAccOnly ? '1' : '0'}&platform=${Platform.operatingSystem}';
        var js = await getData("$url_svc_root/RegistrationRequestOTP?$params");
        userid = js[0]['userid'].toString();
        usr = null;
        goTo(1);
      }
    } else if (currentStep == 1) {
      if (_fOTP.text != "") {
        if (usr != null) {
          goTo(2);
        } else {
          var js = await getData(
              "$url_svc_root/RegistrationCheckOTP?lang=$lang&userid=$userid&otp=${_fOTP.text}");
          usr = js[0];
          userid = usr['userid'].toString();
          _fLoginID.text = usr['user_name'];
          _fFullName.text = usr['full_name'];
          _selectedGender = usr['gender'];
          // usr['email']
          // usr['mobile']
          // usr['prefered_lang']
          goTo(2);
        }
      }
    } else if (currentStep == 2) {
      if (_fFullName.text != "") goTo(3);
    } else if (currentStep == 3) {
      if (_fLoginID.text != "" &&
          _fPassword1.text != "" &&
          _fPassword2.text != "") {
        var params =
            'lang=$lang&userid=$userid&fullname=${_fFullName.text}&gender=$_selectedGender&loginid=${_fLoginID.text}&password=${_fPassword1.text}';
        await getData("$url_svc_root/RegistrationFinal?$params");
        complete = true;
        goTo(4);
      }
    }
    // setState(() => complete = true);
    // currentStep + 1 != steps.length
    //     ? goTo(currentStep + 1)
    //     : setState(() => complete = true);
  }

  showError(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  // StepperType stepperType = StepperType.horizontal;
  // switchStepType() {
  //   setState(() => stepperType == StepperType.horizontal
  //       ? stepperType = StepperType.vertical
  //       : stepperType = StepperType.horizontal);
  // }
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

// Scaffold
  @override
  Widget build(BuildContext context) {
    List<Step> steps = createSteps();
    //steps[0].content=Text("data");
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Stack(
          children: [
            Column(
              children: [
                // complete
                //     ? Expanded(
                //         child: Center(
                //           child: AlertDialog(
                //             title: new Text("Profile Created"),
                //             content: new Text(_fEMail.text //.children[0],
                //                 ),
                //             actions: [
                //               new TextButton(
                //                 child: new Text("Close"),
                //                 onPressed: () {
                //                   setState(() => complete = false);
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //       ):
                Expanded(
                  child: Stepper(
                    // type: stepperType,
                    steps: steps,
                    currentStep: currentStep,
                    onStepTapped: (step) =>
                        complete ? (step) => goTo(step) : null,
                    //onStepTapped: (step) => goTo(step),
                    onStepContinue: busy || complete ? null : next,
                    onStepCancel:
                        busy || complete || currentStep == 0 ? null : cancel,
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: details.onStepContinue == null
                                  ? null
                                  : ElevatedButton(
                                      onPressed: details.onStepContinue,
                                      child: Text(
                                          lang == 'ar' ? 'التالي' : "Next"),
                                    )),
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: details.onStepCancel == null
                                  ? null
                                  : ElevatedButton(
                                      onPressed: details.onStepCancel,
                                      child: Text(
                                          lang == 'ar' ? 'السابق' : 'Back'),
                                    )),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            busy ? isLoading() : Container()
          ],
        )
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.list),
        //   onPressed: switchStepType,
        // ),
        );
  }

  List<Step> createSteps() {
    final passwordValidator = MultiValidator([
      RequiredValidator(
          errorText:
              lang == "ar" ? "يجب إدخال كلمة سر" : 'password is required'),
      MinLengthValidator(6,
          errorText: lang == "ar"
              ? "يجب أن تكون كلمة السر 6 أحرف على الأقل"
              : 'password must be at least 6 digits long'),
      // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      //     errorText: lang == "ar"
      //         ? ""
      //         : 'passwords must have at least one special character'),
    ]);
    List<Step> steps = [
      Step(
          isActive: currentStep == 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          title: Text(lang == "ar"
              ? "قنوات الإتصال و الإشعارات"
              : "Notification Channels"),
          subtitle: Text(
              lang == "ar" ? "يرجى إدخال البيانات" : "Please provide info"),
          content: Form(
              key: _formKeys[0],
              child: Column(
                children: [
                  DropdownButtonFormField(
                    value: _selectedChannel,
                    onChanged: complete
                        ? null
                        : (value) => setState(() => _selectedChannel = value),
                    validator: (value) => value == null
                        ? lang == 'ar'
                            ? 'يرجى الاختيار'
                            : 'Please select'
                        : null,
                    items: [
                      DropdownMenuItem<String>(
                          value: "email",
                          child: Text(
                              lang == 'ar' ? "البريد الإلكتروني" : "EMail")),
                      DropdownMenuItem<String>(
                          value: "mobile",
                          child: Text(lang == 'ar' ? "الموبايل" : "Mobile")),
                    ],
                    decoration: InputDecoration(
                        labelText: lang == 'ar' ? "القناة" : 'Channel'),
                  ),
                  _selectedChannel == "email"
                      ? TextFormField(
                          readOnly: complete,
                          controller: _fEMail,
                          decoration: InputDecoration(
                              labelText: lang == 'ar'
                                  ? 'البريد الإلكتروني'
                                  : 'Email Address'),
                          validator: EmailValidator(
                              errorText: lang == 'ar'
                                  ? 'يرجى إدخال بريد إلكتروني صحيح'
                                  : 'Please enter valid email'),
                        )
                      : TextFormField(
                          readOnly: complete,
                          controller: _fMobile,
                          // filter
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              labelText:
                                  lang == 'ar' ? "رقم الموبايل" : 'Mobile'),
                          validator: (value) => (value!.isEmpty ||
                                  !RegExp(r'^[0-9]+$').hasMatch(value))
                              ? lang == 'ar'
                                  ? 'يرجى إدخال رقم موبايل صحيح'
                                  : 'Please enter valid mobile'
                              : null,
                        ),
                  // Container(
                  //   padding: EdgeInsets.only(top: 10),
                  //   width: double.infinity,
                  //   child: new Text("OR"),
                  // ),
                ],
              ))),
      Step(
          isActive: currentStep == 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          title: Text(lang == "ar"
              ? "التأكد من رقم الموبايل أو البريد الإلكتروني"
              : "Validate Email or Mobile"),
          subtitle: Text(lang == 'ar'
              ? "يرجى إدخال الرقم الذي تم إرساله لكم الآن"
              : "Please enter OTP number sent to you"),
          content: Form(
              key: _formKeys[1],
              child: Column(
                children: [
                  TextFormField(
                    readOnly: complete,
                    controller: _fOTP,
                    decoration: InputDecoration(
                        labelText: lang == "ar" ? "الرمز المرسل" : "OTP"),
                    validator: (value) => value!.isEmpty
                        ? lang == "ar"
                            ? "يرجى إدخال نص"
                            : "Please enter some text"
                        : null,
                  ),
                ],
              ))),
      Step(
          isActive: currentStep == 2,
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          title: Text(lang == 'ar' ? 'البيانات الشخصية' : 'Account Info'),
          subtitle: Text(lang == 'ar' ? "اسمك" : "Your Name"),
          content: Form(
              key: _formKeys[2],
              child: Column(
                children: [
                  TextFormField(
                    readOnly: complete,
                    controller: _fFullName,
                    decoration: InputDecoration(
                        labelText: lang == 'ar' ? 'الاسم الكامل' : 'Full Name'),
                    validator: (value) => value!.isEmpty
                        ? lang == 'ar'
                            ? 'يرجى إدخال نص'
                            : 'Please enter some text'
                        : null,
                  ),
                  DropdownButtonFormField(
                    value: _selectedGender,
                    onChanged: complete
                        ? null
                        : (value) => setState(() => _selectedGender = value),
                    validator: (value) => value == null
                        ? lang == 'ar'
                            ? 'يرجى الاختيار'
                            : 'Please select'
                        : null,
                    items: [
                      DropdownMenuItem<String>(
                          value: "1",
                          child: Text(lang == 'ar' ? 'ذكر' : "Male")),
                      DropdownMenuItem<String>(
                          value: "2",
                          child: Text(lang == 'ar' ? 'أنثى' : "Female")),
                    ],
                    decoration: InputDecoration(
                        labelText: lang == 'ar' ? 'الجنس' : 'Gender'),
                  ),
                ],
              ))),
      Step(
          isActive: currentStep == 3,
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          title: Text(lang == 'ar' ? 'بيانات الدخول' : 'Login Info'),
          subtitle: Text(
              lang == 'ar' ? 'اسم الدخول و كلمة السر' : "User Name & Password"),
          content: Form(
              key: _formKeys[3],
              child: Column(
                children: [
                  //CircleAvatar(backgroundColor: Colors.red),
                  TextFormField(
                    readOnly: complete,
                    controller: _fLoginID,
                    decoration: InputDecoration(
                        labelText: lang == 'ar' ? 'اسم الدخول' : 'User Name'),
                    validator: (value) => value!.isEmpty
                        ? lang == 'ar'
                            ? 'يرجى إدخال نص'
                            : 'Please enter some text'
                        : null,
                  ),
                  TextFormField(
                    readOnly: complete,
                    obscureText: true,
                    controller: _fPassword1,
                    decoration: InputDecoration(
                        labelText: lang == 'ar' ? 'كلمة السر' : 'Password'),
                    validator: passwordValidator,
                  ),
                  TextFormField(
                    readOnly: complete,
                    obscureText: true,
                    controller: _fPassword2,
                    decoration: InputDecoration(
                        labelText: lang == 'ar'
                            ? 'تأكيد كلمة السر'
                            : 'Confirm Password'),
                    validator: (val) => MatchValidator(
                            errorText: lang == 'ar'
                                ? 'كلمات السر غير متطابقة'
                                : 'passwords do not match')
                        .validateMatch(val!, _fPassword1.text),
                  ),
                ],
              ))),
      Step(
          isActive: currentStep == 4,
          state: currentStep >= 4 ? StepState.complete : StepState.indexed,
          title: Text(lang == 'ar' ? 'تم' : 'Done'),
          subtitle: currentStep == 4 ? Text(widget.doneText) : null,
          content: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.thumb_up,
                  color: Colors.white,
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(lang == 'ar'
                      ? 'تهانينا، إبدأ'
                      : "Congratulations, Let's Start"),
                ),
                onPressed: () {
                  if (widget.loginFunc != null) {
                    widget.loginFunc!(_fLoginID.text, _fPassword1.text);
                  }
                  Navigator.pop(context);
                },
              ),
              Container(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: SvgPicture.asset(
                  "images/nfooz_congrat.svg",
                  width: 200,
                ),
              ),
            ],
          )),
    ];
    return steps;
  }
}
