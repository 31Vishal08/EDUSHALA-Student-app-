import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:student/Auth/EnterMobile.dart';
import 'package:student/Auth/EnterOTP.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Functions.dart';

import '../Usefull/Colors.dart';




final _messangerKey = GlobalKey<ScaffoldMessengerState>();


class registerNow extends StatefulWidget {
  const registerNow({Key? key}) : super(key: key);

  @override
  State<registerNow> createState() => _registerNowState();
}

class _registerNowState extends State<registerNow> {
  bool isHide = false;
  final formKey = GlobalKey<FormState>();
  String phone = "";

  Color btnbg = bgColor;
  Color btntext = mainColor;
  PhoneNumber number = PhoneNumber(dialCode: "+91", isoCode: "IN");

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              bgcircles(context, secColor),
              Blur(context, 80),
              SingleChildScrollView(
                padding: mainPadding,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Iconsax.arrow_left,color: textColor,)),
                        Spacer(),
                      ],
                    ),



                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        mainTextFAQS("Let's Get Started", textColor, 20.0,
                            FontWeight.w700, 2),
                        Spacer(),
                      ],
                    ),

                    SizedBox(height: 50.0,),
                    Image.asset("Assets/signup.png", width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.90,),

                    SizedBox(height: 30.0,),
                    Row(
                      children: [
                        Spacer(),
                        onlymainText(
                            "Register Now", mainColor, 19.0, FontWeight.normal,
                            2),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: [
                        Spacer(),
                        mainText(
                            "To proceed, please provide your mobile number\n"
                                "You’ll receive 6 digit code to verify next",
                            textLight, 6.0, FontWeight.normal, 2),
                        Spacer(),
                      ],
                    ),

                    SizedBox(height: 30.0,),

                    Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: (
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  color: lightWhite,
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                        color: lightWhite,
                                        width: 0.0,
                                      )
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 2.0),
                                    child: InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber n) {
                                        print(n.toString());
                                        phone = n.phoneNumber.toString();
                                        btnChanger(n.phoneNumber
                                            .toString()
                                            .length - n.dialCode
                                            .toString()
                                            .length);
                                      },
                                      textStyle: TextStyle(
                                        fontFamily: 'mons',
                                        fontSize: 15.0,
                                        color: textColor,
                                      ),

                                      selectorConfig: SelectorConfig(
                                          selectorType: PhoneInputSelectorType
                                              .BOTTOM_SHEET
                                      ),
                                      initialValue: number,

                                      maxLength: 12,
                                      keyboardType: TextInputType.number,
                                      cursorColor: mainColor,

                                      selectorTextStyle: TextStyle(
                                        fontFamily: 'mons',
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),

                                      inputDecoration: InputDecoration(
                                        filled: true,
                                        fillColor: lightWhite,
                                        hintText: "Mobile Number",
                                        // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                        hintStyle: TextStyle(
                                            fontFamily: 'mons',
                                            color: Colors.grey
                                        ),
                                        labelStyle: TextStyle(
                                            fontFamily: 'mons',
                                            color: secColor
                                        ),

                                        errorStyle: TextStyle(
                                            fontFamily: 'mons',
                                            color: errorColor
                                        ),
                                        border: InputBorder.none,

                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return ("Please Enter a Number");
                                        }
                                        else if (value.length < 10) {
                                          return ("Number should be 10 digits long");
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: 40.0,),
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 50.0,
                                  margin: EdgeInsets.fromLTRB(
                                      10, 40.0, 10.0, 0.0),
                                  child: custombtnsss("Continue", () {
                                    LoginwithMobile();
                                  }, secColor, bgColor, 30.0),),
                                Row(
                                  children: [
                                    Spacer(),
                                    onlymainText(
                                        "Already an user?", textLight, 12.0,
                                        FontWeight.normal, 1),
                                    TextButton(onPressed: () {
                                      navScreen(mobile(), context, false);
                                    },
                                      child: onlymainText(
                                          "Login", mainColor, 12.0,
                                          FontWeight.bold, 1),),
                                    Spacer(),
                                  ],
                                ),

                              ],
                            )
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              loaderss(isHide, "Please Wait", true, context)
            ],
          ),
        ),
      ),
    );
  }

  Future LoginwithMobile() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isHide = true;
      });
      print("Batman" + phone);
      final app_sign = await SmsAutoFill().getAppSignature;
      print(app_sign);

      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: _onVerificationCompleted,
          verificationFailed: _onVerificationFailed,
          codeSent: _onCodeSent,
          codeAutoRetrievalTimeout: _onCodeTimeout);
    }
  }


  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      // this.otpCode.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try {
        UserCredential credential =
        await user!.linkWithCredential(authCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'provider-already-linked') {
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isHide = false;
      });
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    print(exception.code);
    if (exception.code == 'invalid-phone-number') {
      setState(() {
        isHide = false;
      });
      Snacker("Please Enter an Valid Phone Number", _messangerKey);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    print("Bhij Gaya");
    verificationId = verificationId;
    print(forceResendingToken);
    Snacker("OTP send Successfully", _messangerKey);
    setState(() {
      isHide = false;
    });
    navScreen(otp(number: phone, vId: verificationId,), context, false);
  }

  _onCodeTimeout(String timeout) {
    return null;
  }


  void btnChanger(int a) {
    if (a == 0) {
      setState(() {
        btnbg = bgColor;
        btntext = mainColor;
      });
    }
    else if (a < 10) {
      setState(() {
        btnbg = bgColor;
        btntext = mainColor;
      });
    }
    else if (a == 10) {
      setState(() {
        btnbg = mainColor;
        btntext = bgColor;
      });
    }
  }


}


