import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/Inquire/RaiseInquire.dart';
import 'package:student/Tutor/TutorSliders.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Dialogs.dart';
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

import 'package:introduction_screen/introduction_screen.dart';

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






late _assignedTutorState stateofassignedTutor;

class assignedTutor extends StatefulWidget {
  Map enquireData;
  assignedTutor({Key? key,required this.enquireData}) : super(key: key);

  @override
  State<assignedTutor> createState() {
    stateofassignedTutor = _assignedTutorState();
    return stateofassignedTutor;
  }
}

class _assignedTutorState extends State<assignedTutor> {
  bool isHide = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool notFound = false;


  final formKey = GlobalKey<FormState>();

  List tutorsData = [];
  int totalTutors = 0;


  @override
  void initState() {
    getTutorList();
  }

  getTutorList() async{
    setState(() {
      isHide = true;
    });
    List tutorids = jsonDecode(widget.enquireData['tutors']);
    totalTutors = tutorids.length;
    print(tutorids);
    for(var i in tutorids){
      User? auth = FirebaseAuth.instance.currentUser;
      http.Response response = await http.post(Uri.parse(getTutorUrl),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'tutor_id': i.toString(),
        }),
      );
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200){
        Map td = jsonDecode(response.body);
        Map tdd = td['tutor'];
        setState(() {
          tutorsData.add(tdd);
        });
        if(tutorids.last == i){
          setState(() {
            isHide = false;
          });
        }
      }
    }

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: _key,
          backgroundColor: bgColor,
          // drawer: navigationDrawer(allData: widget.data),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            // leadingWidth: 100.0,
            elevation: 0.0,
            title: mainText("$totalTutors Tutors have been assigned to you", textColor, 10.0, FontWeight.bold, 1),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Iconsax.arrow_left_2,color: mainColor,)),

          ),
          body: Stack(
              children:[
                newbgcircles(context, secColor),
                Blur(context, 100),

                Visibility(
                    visible: !isHide,
                    child: TutorSlider(allTutorData: tutorsData,enquiryData: widget.enquireData,)),

                loaderss(isHide, "Please Wait", true, context),


              ]
          )
      ),
    );
  }
}

