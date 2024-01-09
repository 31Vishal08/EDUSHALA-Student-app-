import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:student/Usefull/ImpCards.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../Auth/EnterMobile.dart';
import '../Auth/RegisterNow.dart';
import '../Usefull/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Usefull/Functions.dart';

// import '../routes/app_routes.dart';

class onBoardingCarousal extends StatefulWidget {
  const onBoardingCarousal({Key? key}) : super(key: key);

  @override
  State<onBoardingCarousal> createState() => _onBoardingCarousalState();
}

class _onBoardingCarousalState extends State<onBoardingCarousal> {
  bool isHide = false;
  final _introKey = GlobalKey<IntroductionScreenState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String device = "";
  bool doChange = true;

  @override
  void initState() {
    changer();
  }

  changer() {
    if (doChange) {
      Timer.periodic(Duration(seconds: 2), (timer) {
        _introKey.currentState!.next();
        if (_introKey.currentState!.getCurrentPage() == 4) {
          setState(() {
            doChange = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // bgcircles(context, secColor),
            // Blurr(context, 100),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    Expanded(
                      child: IntroductionScreen(
                        key: _introKey,
                        globalBackgroundColor: Colors.transparent,
                        pages: [
                          PageViewModel(

                            bodyWidget: Column(
                              children: [

                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Image Container (Centered)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 150.0,top: 20),
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Color(0xFFFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.1),
                                              blurRadius: 13.0,
                                              offset: Offset(0.0, 0.0),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          "Assets/books.png",
                                          width: 50.0,
                                          height: 50.0,
                                        ),
                                      ),
                                    ),
                                    // Text Container (Overlapping 25%)
                                    Positioned(
                                      left: 75.0,
                                      top: 5.0,
                                      right: 68.0, // Adjust the right position to overlap 25%
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(17.0),
                                          border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                          color: Color(0xFF00C2FF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.25),
                                              blurRadius: 4.0,
                                              offset: Offset(0.0, 4.0),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "Academics",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    //

                                  ],
                                ),





                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Image Container (Centered)
                                    Padding(
                                      padding:  EdgeInsets.only(left: 150.0,bottom: 48),
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Color(0xFFFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.1),
                                              blurRadius: 13.0,
                                              offset: Offset(0.0, 0.0),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          "Assets/young.png",
                                          width: 50.0,
                                          height: 50.0,
                                        ),
                                      ),
                                    ),
                                    // Text Container (Overlapping 25%)
                                    Positioned(
                                      left: 40.0,
                                      top: 80.0,
                                      right: 59.0, // Adjust the right position to overlap 25%
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(17.0),
                                          border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                          color: Color(0xFF00C2FF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.25),
                                              blurRadius: 4.0,
                                              offset: Offset(0.0, 4.0),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "Competitive Exam",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // SizedBox(height: 150,),

                                  ],
                                ),






                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Image Container (Centered)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 150.0,top: 50),
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Color(0xFFFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.1),
                                              blurRadius: 13.0,
                                              offset: Offset(0.0, 0.0),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                          "Assets/ball.png",
                                          width: 50.0,
                                          height: 50.0,
                                        ),
                                      ),
                                    ),
                                    // Text Container (Overlapping 25%)
                                    Positioned(
                                      left: 75.0,
                                      top: 35.0,
                                      right: 95.0, // Adjust the right position to overlap 25%
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(17.0),
                                          border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                          color: Color(0xFF00C2FF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.25),
                                              blurRadius: 4.0,
                                              offset: Offset(0.0, 4.0),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          "Sports",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // SizedBox(height: 150,),

                                  ],
                                ),

                              ],
                            ),
                            titleWidget: Text(
                              "Find your favorite subject\n       or activity to teach",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),




                          PageViewModel(
                            bodyWidget: Stack(
                              children: [
                                // Background Image
                                Positioned.fill(
                                  child: Image.asset(
                                    "Assets/groups.png", // Make sure the image path is correct
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // First Card
                                        Padding(
                                          padding: const EdgeInsets.only(right: 150.0, top: 20),
                                          child: Container(
                                            width: 300.0,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: Color(0xFFFFFFFF),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                                  blurRadius: 13.0,
                                                  offset: Offset(0.0, 0.0),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Ankit Kumar",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  "At Parents Home",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "Assets/groups.png", // Make sure the image path is correct
                                                      width: 30.0,
                                                      height: 30.0,
                                                    ),
                                                    Text(
                                                      "Central Park Bhopal",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Add more card stacks here as needed

                                  ],
                                ),
                              ],
                            ),
                            titleWidget: Text(
                              "Spot a learner near you and get started",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),






                          PageViewModel(
                            bodyWidget: Column(
                              children: [
                                // First Circular Container (Align Left)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 170.0, top: 0),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50.0), // Circular border radius
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/registration.png",
                                            width: 70.0, // Adjust the width here
                                            height: 70.0, // Adjust the height here
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0, top: 3),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "No registration fees",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Second Circular Container (Align Right)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15, left: 170),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50.0), // Circular border radius
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/fees.png",
                                            width: 70.0, // Adjust the width here
                                            height: 70.0, // Adjust the height here
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3, left: 150,bottom: 15),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "Guranteed fees security",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Third Circular Container (Align Left)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 170.0,),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50.0), // Circular border radius
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/men.png",
                                            width: 70.0, // Adjust the width here
                                            height: 70.0, // Adjust the height here
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0, top: 3),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "Earn good amount",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            titleWidget: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Why ",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal, // Set the fontWeight to normal for the "Why" part
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Edushala?",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold, // Set the fontWeight to bold for the "Edushala" part
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          PageViewModel(
                            bodyWidget: Column(
                              children: [

                                SizedBox(height: 40),
                                // First Circular Container (Align Left)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0, top: 1),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50.0), // Circular border radius
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/payment.png",
                                            width: 70.0, // Adjust the width here
                                            height: 70.0, // Adjust the height here
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0, top: 3),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "payment",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 100),
                                // Second Circular Container (Align Right)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1, left: 150),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50.0), // Circular border radius
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/quicksupport.png",
                                            width: 70.0, // Adjust the width here
                                            height: 70.0, // Adjust the height here
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3, left: 150),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "quicksupport",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Third Circular Container (Align Left)

                              ],
                            ),
                            titleWidget: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Why ",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal, // Set the fontWeight to normal for the "Why" part
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Edushala?",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold, // Set the fontWeight to bold for the "Edushala" part
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ),

                          PageViewModel(

                            bodyWidget: Column(
                              children: [
                                // First Container (Align Left)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0,top: 1),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15.0),
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/democlass.png",
                                            width: 50.0,
                                            height: 50.0,
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0,top: 3),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "Demo class",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),




                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1,left: 150),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15.0),
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/support.png",
                                            width: 50.0,
                                            height: 50.0,
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3,left: 150),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "support",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0,top: 1),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15.0),
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                                blurRadius: 13.0,
                                                offset: Offset(0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Image.asset(
                                            "Assets/attendence.png",
                                            width: 50.0,
                                            height: 50.0,
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 150.0,top: 3),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 8.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(17.0),
                                            border: Border.all(color: Color(0xFF00C2FF), width: 1.0),
                                            color: Color(0xFF00C2FF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                                blurRadius: 4.0,
                                                offset: Offset(0.0, 4.0),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            "attendence",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Second Container (Align Right)
                                // Container(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.end,
                                //     children: [
                                //       Image.asset(
                                //         "Assets/democlass.png",
                                //         width: 50.0,
                                //         height: 50.0,
                                //       ),
                                //       Container(
                                //         padding: EdgeInsets.all(8.0),
                                //         color: Colors.blue,
                                //         child: Text(
                                //           "demo class",
                                //           style: TextStyle(
                                //             color: Colors.white,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(height: 10,),
                                // // Third Container (Align Left)
                                // Container(
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Image.asset(
                                //         "Assets/democlass.png",
                                //         width: 50.0,
                                //         height: 50.0,
                                //       ),
                                //       Container(
                                //         padding: EdgeInsets.all(8.0),
                                //         color: Colors.blue,
                                //         child: Text(
                                //           "demo class",
                                //           style: TextStyle(
                                //             color: Colors.white,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            )
                            ,
                            titleWidget: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Manage Your ",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.normal, // Set the fontWeight to normal for the "Why" part
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Tution",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold, // Set the fontWeight to bold for the "Edushala" part
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],




                        // bodyPadding: EdgeInsets.only(top: 1),
                        // dotsFlex: 3,
                        dotsDecorator: DotsDecorator(
                          activeColor: mainColor,
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // Adjust the radius for circular dots
                          ),
                        ),
                        // controlsPadding: EdgeInsets.all(0),
                        showNextButton: false, // Hide the next button
                        showBackButton: false, // Hide the back button
                        showDoneButton: false, // Hide the done button

                        overrideNext: GestureDetector(
                          onTap: () {
                            _introKey.currentState!.next();
                          },
                          child: Container(
                            width: 0.0, // Customize the size of the circular button
                            height: 0.0,
                            decoration: BoxDecoration(
                              color: secColor, // Customize the button color
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.chevron_forward, // Customize the icon
                                color: Colors.white, // Customize the icon color
                              ),
                            ),
                          ),
                        ),

                        overrideBack: GestureDetector(
                          onTap: () {
                            _introKey.currentState!.previous();
                          },
                          child: Container(
                            width: 0.0, // Customize the size of the circular button
                            height: 0.0,
                            decoration: BoxDecoration(
                              color: secColor, // Customize the button color
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                CupertinoIcons.chevron_back, // Customize the icon
                                color: Colors.white, // Customize the icon color
                              ),
                            ),
                          ),
                        ),


                        // dotsFlex: 3,
                        // dotsDecorator: DotsDecorator(
                        //   activeColor: mainColor,
                        //   size: const Size(10.0, 2.0),
                        //   activeSize: const Size(20.0, 2.0),
                        //   shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(0.0)),
                        //   activeShape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(0.0)),
                        // ),
                        // controlsPadding: EdgeInsets.all(0),
                        // showNextButton: true,
                        // showBackButton: true,
                        //
                        // overrideNext: IconButton(
                        //   onPressed: () {
                        //     _introKey.currentState!.next();
                        //   },
                        //   icon: Icon(
                        //     Iconsax.arrow_right_3,
                        //     color: secColor,
                        //   ),
                        // ),
                        //
                        // overrideBack: IconButton(
                        //   onPressed: () {
                        //     _introKey.currentState!.previous();
                        //   },
                        //   icon: Icon(
                        //     Iconsax.arrow_left_2,
                        //     color: textLight,
                        //   ),
                        // ),
                        //
                        // overrideDone: IconButton(
                        //   onPressed: () {
                        //     done();
                        //   },
                        //   icon: Icon(
                        //     CupertinoIcons.checkmark_alt,
                        //     color: secColor,
                        //     size: 30.0,
                        //   ),
                        // ),
                        // onDone: (){
                        //
                        //     },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      // width: 600,
                      height: 120,
                      decoration: ShapeDecoration(
                        color: Color(0xFFDEF7FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 18,
                            offset: Offset(3, 0),
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(00.0),
                      // height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
                        children: [
                          btnsss("Login", () {
                            // done();
                            navScreen(mobile(), context, false);
                          }, secColor, Colors.white),
                          btnsss("SignUp", () {
                            // Add the login functionality here
                            navScreen(registerNow(), context, false);
                          }, secColor, Colors.white),
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
            loaderss(isHide, "Please wait", true, context),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  done() async {
    Navigator.pop(context);
  }
}
