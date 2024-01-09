import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Auth/WelcomeScreen.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Dialogs.dart';

import '../Usefull/Functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';










class aboutUs extends StatefulWidget {
  aboutUs({Key? key}) : super(key: key);

  @override
  State<aboutUs> createState() => _aboutUsState();
}

class _aboutUsState extends State<aboutUs> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left_2,color: textLight,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            // circles(context),
            bgcircles(context, secColor),
            Blur(context, 100),
            SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    mainText("About us", textLight,20.0, FontWeight.bold, 1),
                    SizedBox(height: 10.0,),
                     Image.asset("Assets/logo.png",width: 100.0,),
                    SizedBox(height: 10.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mainText("Edushala - ", secColor,25.0, FontWeight.bold, 1),
                        mainText("Student", mainColor,25.0, FontWeight.bold, 1),
                      ],
                    ),
                    SizedBox(height: 10.0,),
                    mainText("Edushala is a household name when it comes to home tutors in Bhopal, "
                        "Madhya Pradesh. We believe in quality education, and have the right blend "
                        "of experienced tutors and state-of-the-art technology. We are known for "
                        "imparting quality home tutoring in various subjects like English, Chemistry, "
                        "Maths, Science, Geography, History, Commerce, and whatnot. We know that each "
                        "student is unique, and we create customized study programs for them. "
                        "All our tutors are certified professionals and they are passionate about "
                        "helping students achieve their academic goals. Our main focus is on "
                        "helping students understand and retain information better so that "
                        "they can excel in their classes.", textLight, 13.0, FontWeight.normal, 30)
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }





}

class faqsItem extends StatelessWidget {
  String title;
  String answer;
  faqsItem({Key? key,required this.title,required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0,vertical: .0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)
          ),
          elevation: 0.0,
          color: Colors.white,
          child: ExpansionTile(

            title: Column(
              children: [
                Row(
                  children: [
                    mainTextFAQS(title, textColor, 15.0, FontWeight.bold, 4),
                  ],
                ),
                SizedBox(height: 10.0,),

              ],
            ),
            children: [
              mainTextFAQS(answer, Colors.grey, 10.0, FontWeight.normal, 50),
            ],
          ),
        ),
      ),
    );
  }
}




