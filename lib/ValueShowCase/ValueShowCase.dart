

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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





class valueShowCase extends StatefulWidget {
  const valueShowCase({Key? key}) : super(key: key);

  @override
  State<valueShowCase> createState() => _valueShowCaseState();
}

class _valueShowCaseState extends State<valueShowCase> {
  bool isHide = false;
  final _introKey = GlobalKey<IntroductionScreenState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String device = "";


  @override
  void initState() {
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            bgcircles(context, secColor),
            Blur(context, 100),
            SafeArea(
              child: Padding(
                padding: mainPadding,
                child: IntroductionScreen(
                  key: _introKey,
                  globalBackgroundColor: Colors.transparent,
                  pages: [
                    PageViewModel(

                      image: Image.asset("Assets/VS/why.png",width: 280.0,),
                        titleWidget: mainText("Why Edushala??", textColor, 35.0, FontWeight.bold, 1),
                        // bodyWidget: Image.asset("Assets/welcome.png"),
                        bodyWidget:  mainText("Why to choose edushala??", Colors.grey, 10.0, FontWeight.bold, 2),

                        decoration: PageDecoration(
                            bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                            contentMargin: EdgeInsets.all(0),
                            titlePadding: EdgeInsets.all(0),
                            bodyAlignment: Alignment.center,

                            imageFlex: 3,
                            bodyFlex: 2,
                            imagePadding: EdgeInsets.only(bottom: 0)
                        )
                    ),
                    PageViewModel(

                      image: Image.asset("Assets/VS/onevs.png",width: 280.0,),
                        titleWidget: mainText("Home Tutors", textColor, 35.0, FontWeight.bold, 1),
                        // bodyWidget: Image.asset("Assets/welcome.png"),
                        bodyWidget:  mainText("Provides Well Interviewed\nRelevent Home Tutors", Colors.grey, 10.0, FontWeight.bold, 2),

                        decoration: PageDecoration(
                            bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                            contentMargin: EdgeInsets.all(0),
                            titlePadding: EdgeInsets.all(0),
                            bodyAlignment: Alignment.center,

                            imageFlex: 3,
                            bodyFlex: 2,
                            imagePadding: EdgeInsets.only(bottom: 0)
                        )
                    ),
                    PageViewModel(

                      image: Image.asset("Assets/VS/twovs.png",width: 280.0,),
                        titleWidget: mainText("Easy Report", textColor, 35.0, FontWeight.bold, 1),
                        // bodyWidget: Image.asset("Assets/welcome.png"),
                        bodyWidget:  mainText("Easy Reporting System\nof Daily Tuition on\nOur Mobile App",
                            Colors.grey, 10.0, FontWeight.bold, 3),

                        decoration: PageDecoration(
                            bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                            contentMargin: EdgeInsets.all(0),
                            titlePadding: EdgeInsets.all(0),
                            bodyAlignment: Alignment.center,

                            imageFlex: 3,
                            bodyFlex: 2,
                            imagePadding: EdgeInsets.only(bottom: 0)
                        )
                    ),
                    PageViewModel(

                      image: Image.asset("Assets/VS/threevs.png",width: 280.0,),
                        titleWidget: mainText("SWOT Test", textColor, 35.0, FontWeight.bold, 1),
                        // bodyWidget: Image.asset("Assets/welcome.png"),
                        bodyWidget:  mainText("Weekly SWOT Test by\nmgmt. So Teacher Get\nMore Responsible",
                            Colors.grey, 10.0, FontWeight.bold, 3),

                        decoration: PageDecoration(
                            bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                            contentMargin: EdgeInsets.all(0),
                            titlePadding: EdgeInsets.all(0),
                            bodyAlignment: Alignment.center,

                            imageFlex: 3,
                            bodyFlex: 2,
                            imagePadding: EdgeInsets.only(bottom: 0)
                        )
                    ),
                    PageViewModel(

                      image: Image.asset("Assets/VS/fourvs.png",width: 280.0,),
                        titleWidget: mainText("Tutors Options", textColor, 35.0, FontWeight.bold, 1),
                        // bodyWidget: Image.asset("Assets/welcome.png"),
                        bodyWidget:  mainText("Provide Tutors as per\nYour Choice", Colors.grey, 10.0, FontWeight.bold, 3),

                        decoration: PageDecoration(
                            bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                            contentMargin: EdgeInsets.all(0),
                            titlePadding: EdgeInsets.all(0),
                            bodyAlignment: Alignment.center,

                            imageFlex: 3,
                            bodyFlex: 2,
                            imagePadding: EdgeInsets.only(bottom: 0)
                        )
                    ),
                    PageViewModel(

                      image: Image.asset("Assets/VS/fivevs.png",width: 280.0,),
                        titleWidget: mainText("Weekly Consultation", textColor, 35.0, FontWeight.bold, 1),
                        // bodyWidget: Image.asset("Assets/welcome.png"),
                        bodyWidget:  mainText("Weekly Consultation to\nTutors, Students\nand Parents",
                            Colors.grey, 10.0, FontWeight.bold, 3),

                        decoration: PageDecoration(
                            bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                            contentMargin: EdgeInsets.all(0),
                            titlePadding: EdgeInsets.all(0),
                            bodyAlignment: Alignment.center,

                            imageFlex: 3,
                            bodyFlex: 2,
                            imagePadding: EdgeInsets.only(bottom: 0)
                        )
                    ),

                  ],
                  dotsFlex: 3,
                  dotsDecorator: DotsDecorator(
                    activeColor: mainColor,
                    size: const Size(10.0,2.0),
                    activeSize: const Size(20.0, 2.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)
                    ),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)
                    ),
                  ),
                  controlsPadding: EdgeInsets.all(0),
                  showNextButton: true,
                  showBackButton: true,


                  overrideNext: IconButton(onPressed: (){
                    _introKey.currentState!.next();
                  },
                    icon: Icon(Iconsax.arrow_right_3,color: secColor,),
                  ),

                  overrideBack: IconButton(onPressed: (){
                    _introKey.currentState!.previous();
                  },
                    icon: Icon(Iconsax.arrow_left_2,color: textLight,),
                  ),

                  overrideDone: IconButton(onPressed: (){
                    done();
                  },
                    icon: Icon(CupertinoIcons.checkmark_alt,color: secColor,size: 30.0,),
                  ),
                  // onDone: (){
                  //
                  //     },
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

  done() async{
    Navigator.pop(context);
  }

}




