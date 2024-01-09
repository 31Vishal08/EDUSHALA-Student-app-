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
import 'package:student/Inquire/Assignedtutor.dart';
import 'package:student/Inquire/RaiseInquire.dart';
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






late _myInquireState stateofMyInquire;

class myInquire extends StatefulWidget {
  myInquire({Key? key,}) : super(key: key);

  @override
  State<myInquire> createState() {
    stateofMyInquire = _myInquireState();
    return stateofMyInquire;
  }
}

class _myInquireState extends State<myInquire> {
  bool isHide = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Widget> allEnquires = [];
  bool notFound = false;


  final formKey = GlobalKey<FormState>();



  @override
  void initState() {
    // oneSignals();
    getEnquireData();
  }

  getEnquireData() async{
    setState(() {
      isHide = true;
    });
    http.Response response = await http.post(Uri.parse(getInquirebyParentUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'parent': stateofHomeScreen.userCode.toString(),
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map aai = jsonDecode(response.body);
      List athi = aai['enquiry'];
      for(var i in athi){
        Map aa = i;
        var a = enquireCard(data: i);
        setState(() {
          allEnquires.add(a);
          isHide = false;
        });
      }
    }
    else if(response.statusCode == 201){
      setState(() {
        isHide = false;
        notFound = true;
      });
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
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Iconsax.arrow_left_2,color: mainColor,)),

          ),
          body: Stack(
              children:[
                newbgcircles(context, secColor),
                Blur(context, 100),

                SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: mainPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainTextFAQS("My Enquires", textColor, 20.0, FontWeight.bold, 1),
                      SizedBox(height: 20.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: allEnquires,
                      ),

                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(20.0),
                  alignment: Alignment.bottomRight,
                  child: circularBtn(Iconsax.add_circle,
                          () {
                    navScreen(raiseEnquire(), context, false);
                      }, mainColor, Colors.white,false),
                ),
                customNotFound(notFound, "You don't have an Enquiry", "Assets/notfound.png", context,
                    GestureDetector(onTap: (){
                      navScreen(raiseEnquire(), context, false);
                    },
                        child:mainText("Submit an Enquiry", secColor, 10.0, FontWeight.normal, 1))),
                loaderss(isHide, "Please Wait", true, context),


              ]
          )
      ),
    );
  }
}

class enquireCard extends StatefulWidget {
  Map data;
  enquireCard({Key? key,required this.data}) : super(key: key);

  @override
  State<enquireCard> createState() => _enquireCardState();
}

class _enquireCardState extends State<enquireCard> {

  Map childData = {};
  bool pending = true;
  String subjects = "";
  Color bg = oneCardColor;

  @override
  void initState() {
    getChildData();
    getStatus();
  }

  getChildData(){
    setState(() {
      childData = stateofHomeScreen.widget.childData[widget.data['child']];
    });
  }

  getStatus(){
    List subs = jsonDecode(widget.data['subjects']);
    setState(() {
      subjects = "";
    });
    for(var i in subs){
      setState(() {
        subjects += stateofHomeScreen.widget.subjectData[i]['title'] + ", ";
      });

    }
    if(widget.data['status'] == "assigned"){
      setState(() {
        bg = greenColor;
        pending = false;
      });
    }
    else if(widget.data['status'] == "complete"){
      setState(() {
        bg = secColor;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 5.0,
        color: bg,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible:widget.data['status'] == "pending",
                      child: Row(
                        children: [
                          Expanded(child: mainTextFAQS("We are shortlisting\ntutors for you", Colors.white, 18.0, FontWeight.bold, 2)),
                          Image.asset("Assets/enquiry/waiting.png",width: 150.0,),
                        ],
                      )),

                  Visibility(
                      visible:widget.data['status'] == "assigned",
                      child: Row(
                        children: [
                          Expanded(child: mainTextFAQS("Tutors have been\nassigned to you", Colors.white, 18.0, FontWeight.bold, 2)),
                          Image.asset("Assets/enquiry/assigned.png",width: 150.0,),
                        ],
                      )),

                  Visibility(
                      visible:widget.data['status'] == "complete",
                      child: Row(
                        children: [
                          Expanded(child: mainTextFAQS("you have completed\nthis process", Colors.white, 18.0, FontWeight.bold, 2)),
                          Image.asset("Assets/enquiry/done.png",width: 150.0,),
                        ],
                      )),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    color: lightWhite,
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(00.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(title: mainTextFAQS("Requirements", textColor, 15.0, FontWeight.bold, 1),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0,bottom: 10.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.0,),
                                    Row(
                                      children: [
                                        Icon(Iconsax.calendar,color: textLight,),
                                        SizedBox(width: 5.0,),
                                        mainTextFAQS(widget.data['age'], textLight, 10.0, FontWeight.normal, 1),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        Icon(Iconsax.calendar_1,color: textLight,),
                                        SizedBox(width: 5.0,),
                                        Expanded(child: mainTextFAQS(DateFormat("EEE dd MMM yyyy").
                                        format(DateTime.parse(widget.data['startdate'])),
                                            textLight, 10.0, FontWeight.normal, 1)),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        Icon(Iconsax.man,color: textLight,),
                                        SizedBox(width: 5.0,),
                                        mainTextFAQS(widget.data['gender'], textLight, 10.0, FontWeight.normal, 1),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        Icon(Iconsax.clock,color: textLight,),
                                        SizedBox(width: 5.0,),
                                        mainTextFAQS(widget.data['time'], textLight, 10.0, FontWeight.normal, 1),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        Icon(Iconsax.timer_1,color: textLight,),
                                        SizedBox(width: 5.0,),
                                        mainTextFAQS(widget.data['duration'], textLight, 10.0, FontWeight.normal, 1),
                                      ],
                                    ),
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        Icon(Iconsax.book_1,color: textLight,),
                                        SizedBox(width: 5.0,),
                                        Expanded(child:
                                        mainTextFAQS(subjects, textLight, 10.0, FontWeight.normal, 3)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.0,),


                  Visibility(
                    visible: stateofonlyHome.parent,
                    child: Row(
                      children: [
                        Icon(Iconsax.grammerly,color: Colors.white,),
                        SizedBox(width:10.0),
                        mainTextFAQS(childData['name'], Colors.white, 13.0, FontWeight.bold, 1)
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !pending,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: custombtnsss("SEE TUTORS", () {
                        navScreen(assignedTutor(enquireData: widget.data), context, false);
                      }, secColor, Colors.white, 15.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
