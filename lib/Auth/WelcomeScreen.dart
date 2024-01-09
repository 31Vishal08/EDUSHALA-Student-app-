import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:student/Auth/EnterMobile.dart';
import 'package:student/Auth/EnterOTP.dart';
import 'package:student/Auth/RegisterNow.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Functions.dart';

import '../Usefull/Backgrounds.dart';
import '../Usefull/Colors.dart';




final _messangerKey = GlobalKey<ScaffoldMessengerState>();


class welcomeScreen extends StatefulWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  bool isHide = false;
  final formKey = GlobalKey<FormState>();

  String f = 'e';

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        backgroundColor: secColor,
        body: SafeArea(
          child: Stack(
            children: [
              bgcircles(context, bgColor),
              Blur(context,80),

              SingleChildScrollView(
                padding: mainPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.0,),
                    Image.asset("Assets/welcome.png"),
                    SizedBox(height: 20.0,),
                    mainText("Hey! Welcome", textLight, 20.0, FontWeight.bold, 1,),
                    SizedBox(height: 10.0,),
                    mainText("Start your learning journey with edushala", textLight, 10.0, FontWeight.normal, 2,),



                  ],
                ),

              ),

              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.symmetric(horizontal: 25.0,vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: custombtnsss("Get Started", () {
                          navScreen(registerNow(), context, false);
                        }, Colors.white, mainColor, 7)),

                    SizedBox(height: 15.0,),

                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: customborderbtnsss("I already have an account", () {
                          navScreen(mobile(), context, false);
                        }, Colors.transparent, mainColor, 7)),
                  ],
                ),
              ),
              loaderss(isHide,"Please Wait",true, context)
            ],
          ),
        ),
      ),
    );
  }




}
