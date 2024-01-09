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










class faqs extends StatefulWidget {
  faqs({Key? key}) : super(key: key);

  @override
  State<faqs> createState() => _faqsState();
}

class _faqsState extends State<faqs> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Widget> allFaqs = [];

  @override
  void initState() {
    makeFaqs();
  }

  makeFaqs() async{
    var a = faqsItem(title: "FAQs one", answer: "this is a new faqs with bhut saara dataaa");
    var b = faqsItem(title: "FAQs question two", answer: "this is a new faqs with bhut saara dataaa");
    setState(() {
      allFaqs.add(a);
      allFaqs.add(b);
    });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainTextFAQS("FAQs", textLight,20.0, FontWeight.bold, 1),
                  SizedBox(height: 10.0,),
                  Column(
                    children: allFaqs,
                  )
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




