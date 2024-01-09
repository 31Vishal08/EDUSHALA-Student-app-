import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:student/GetStarted/GetStarted.dart';
import 'package:student/GetStarted/GetStartedStudent.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


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
import 'package:cached_network_image/cached_network_image.dart';
import '../Usefull/colors.dart';







late _userTypeState stateofuserType;

class userType extends StatefulWidget {

  userType({Key? key,}) : super(key: key);

  @override
  State<userType> createState() {
    stateofuserType = _userTypeState();
    return stateofuserType;
  }
}

class _userTypeState extends State<userType> {
  bool isHide = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

 

  FirebaseAuth _auth = FirebaseAuth.instance;



  final formKey = GlobalKey<FormState>();
  List bgs = [Colors.white,Colors.white];
  String type = "";

  @override
  void initState() {
    // oneSignals();
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: _key,
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Iconsax.arrow_left_2,color: textColor,),
              onPressed: (){

              },
            ),
          ),

          // drawer: navigationDrawer(allData: widget.data),
          body: Stack(
              children:[
                newbgcircles(context, secColor),
                Blur(context, 100),
                SingleChildScrollView(
                  padding: mainPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      mainText("Book tution for", secColor, 25.0, FontWeight.bold, 1),
                      SizedBox(height: 20.0,),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            bgs[1] = Colors.white;
                            bgs[0] = secColor;
                            type = "parent";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          height:110.0,
                          child: Card(
                            color: bgs[0],
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Image.asset("Assets/tutor.png",width: 80.0,),
                                  SizedBox(width: 10.0,),
                                  mainTextFAQS("My Child", textColor, 15.0,
                                      FontWeight.bold, 1),
                                ],
                              ),
                            ),

                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          setState(() {
                            bgs[0] = Colors.white;
                            bgs[1] = secColor;
                            type = "self";
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          height: 110.0,
                          child: Card(
                            color: bgs[1],
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Image.asset("Assets/nochild.png",width: 80.0,),
                                  SizedBox(width: 10.0,),
                                  mainTextFAQS("My Self", textColor, 15.0,
                                      FontWeight.bold, 1),
                                ],
                              ),
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: type != "",
                  child: Container(
                    margin: EdgeInsets.all(20.0),
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                      height: 50.0,
                      child: btnsss("Procceed",(){
                        if(type == "parent"){
                          navScreen(getStarted(),context,false);
                        }
                        else{
                          navScreen(getStartedStudent(), context, false);
                        }
                      },greenColor,Colors.white),
                    )
                  ),
                ),
                loaderss(isHide, "Please Wait", true, context),

              ]
          )
      ),
    );
  }

}






