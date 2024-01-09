import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Auth/WelcomeScreen.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Dialogs.dart';

import '../Usefull/Functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';










class contactUs extends StatefulWidget {
  contactUs({Key? key}) : super(key: key);

  @override
  State<contactUs> createState() => _contactUsState();
}

class _contactUsState extends State<contactUs> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  String msg = "";
  final formKey = GlobalKey<FormState>();

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
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainText("Contact Us", textLight,20.0, FontWeight.bold, 1),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        style: TextStyle(

                          fontFamily: 'mons',
                          fontSize: 15.0,
                          color:textColor,
                        ),
                        keyboardType: TextInputType.text,
                        maxLength: 512,
                        minLines: 1,
                        maxLines: 10,

                        decoration: InputDecoration(

                          filled: true,
                          fillColor: lightWhite,
                          hintText: "Message...",
                          // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                          hintStyle: TextStyle(
                              fontFamily: 'mons',
                              color:Colors.grey
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
                          ),

                          errorStyle: TextStyle(
                              fontFamily: 'mons',
                              color: errorColor
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent,width: 0),
                            borderRadius: BorderRadius.circular(15.0),

                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: transparent_overlay,
                                width: 0
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: errorColor,
                                width: 0
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),

                        ),

                        validator: (value){
                          if(value!.isEmpty){
                            return("Please Enter a message");
                          }
                        },
                        onChanged: (text){
                          msg = text;
                        },

                      ),

                      SizedBox(height: 30.0,),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: newiconbtnsss("Send Messages", () {

                        }, secColor, Colors.white, Iconsax.send_1, 10.0),
                      ),
                      SizedBox(height: 30.0,),

                      Row(
                        children: [
                          Icon(Iconsax.message_2,color: mainColor,),
                          TextButton(
                            onPressed: (){
                              launch_us("mailto:support@edushalaacademy.com.com");
                            },
                            child: mainTextFAQS("support@edushalaacademy.com", mainColor, 15.0, FontWeight.normal,1),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Iconsax.call,color: mainColor,),
                          TextButton(
                            onPressed: (){
                              launch_us("tel:+918989888365");
                            },
                            child: mainTextFAQS("+91 8989888365", mainColor, 15.0, FontWeight.normal,1),
                          )
                        ],
                      ),



                    ],
                  ),
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




