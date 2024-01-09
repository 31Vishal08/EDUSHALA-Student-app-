import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Homes/Children.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';

import '../Usefull/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';





final _messangerKey = GlobalKey<ScaffoldMessengerState>();


late _raiseEnquireState stateofInquire;
class raiseEnquire extends StatefulWidget {
  Map oneChild;
  raiseEnquire({Key? key,this.oneChild = const {}}) : super(key: key);


  @override
  State<raiseEnquire> createState() {
    stateofInquire = _raiseEnquireState();
    return stateofInquire;
  }
}

class _raiseEnquireState extends State<raiseEnquire> {
  bool isHide = false;
  final formKey = GlobalKey<FormState>();
  String child = "";
  String tutor_age = "";
  String tutor_gender = "";
  String tutor_subject = "";
  double lat = 0.0;
  double lng = 0.0;
  Widget cardItem = Column();
  List<Widget> allChilds = [];
  Map childData = {};

  String ageGroup = "";
  List<Widget> allAgs = [];

  List mySubjects = [];
  List<Widget> allSubjects = [];

  String tution_time = "";
  Time t_time = Time(hour: 11, minute: 00);

  String tution_duration = "";
  List<Widget> allDurations = [];

  String start_date = "";
  DateTime startDate = DateTime.now();

  String budget = "";
  String language = "";
  String frequency = "";

  List<Widget> allLanguages = [];
  List<Widget> allFrequency = [];

  String range = "";
  RangeValues _currentRangeValues = const RangeValues(100, 1000);


  String goals = "";
  String additional = "";
  String hearaboutus = "";
  bool showSubs = false;

  FirebaseAuth _auth = FirebaseAuth.instance;




  @override
  void initState() {
    getChildrens();
    // cardItemFiller();
    updateChildren();
    getags();
    getDurations();
    getlangs();
    getFrequency();
  }

  updateChildren() async{

    if(widget.oneChild.keys.length > 0){
      setState(() {
        childData = widget.oneChild;
        showSubs = true;
        getSubjects();
        cardItem = Row(
          children: [
            Avatars(widget.oneChild['photo_url'], 0, "", 20.0),
            SizedBox(width: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainTextFAQS(widget.oneChild['name'], Colors.white, 15.0,FontWeight.bold, 1),
                mainTextFAQS(widget.oneChild['gender'], lightWhite, 10.0,FontWeight.normal, 1),
              ],
            ),
          ],
        );
      });
    }
    else{
      cardItemFiller();
    }
  }


  cardItemFiller(){
    setState(() {
      cardItem = Row(
        children: [
          Avatars("", 0, "", 20.0),
          SizedBox(width: 20.0,),
          mainTextFAQS("Find tutor for", Colors.white, 15.0,FontWeight.bold, 1),
        ],
      );
    });
  }

  getChildrens(){
    for(var i in stateofHomeScreen.widget.childData.values){
      print(i);
      var a = Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: ListTile(

          tileColor: lightWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          leading: Avatars(i['photo'], 0,"", 25.0),
          title: onlymainText(i['name'], textColor, 15.0, FontWeight.bold,1),
          subtitle: onlymainText(i['gender'], Colors.grey, 10.0, FontWeight.bold,1),
          onTap: (){
            setState(() {
              childData = i;
              showSubs = true;
              getSubjects();
              cardItem = Row(
                children: [
                  Avatars(i['photo'], 0, "", 20.0),
                  SizedBox(width: 20.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainTextFAQS(i['name'], Colors.white, 15.0,FontWeight.bold, 1),
                      mainTextFAQS(i['gender'], lightWhite, 10.0,FontWeight.normal, 1),
                    ],
                  ),
                ],
              );
            });
            Navigator.of(context).pop(false);
          },
        ),
      );
      allChilds.add(a);
      setState(() {

      });
    }
  }

  getags(){
    List ag = ["20-25","25-30","30-35","35-40","40-45","45-50","50-55"];
    for(var i in ag){
      var a = TextButton(onPressed: (){
        setState(() {
          ageGroup = i;
          Navigator.of(context).pop(false);
        });
      }, child: mainTextFAQS(i, textColor, 15.0, FontWeight.normal, 1));
      setState(() {
        allAgs.add(a);
      });
    }
  }

  getDurations(){
    List ag = ["1 hour","1.5 hour","2 hour","2.5 hour","3 hour","3.5 hour","4 hour"];
    for(var i in ag){
      var a = TextButton(onPressed: (){
        setState(() {
          tution_duration = i;
          Navigator.of(context).pop(false);
        });
      }, child: mainTextFAQS(i, textColor, 15.0, FontWeight.normal, 1));
      setState(() {
        allDurations.add(a);
      });
    }
  }
  
  getSubjects(){
    setState((){
      allSubjects = [];
    });
    for(var i in stateofHomeScreen.widget.subjectData.values) {
      Map sm = i;
      if (sm['grade'] == childData['grade']) {
        var a = subjectCard(title: sm['title'], img: sm['icon'], id: sm['id']);
        setState(() {
          allSubjects.add(a);
        });
      }
    }
  }

  getlangs(){
    List ag = ["Hindi","English", "Marathi"];
    for(var i in ag){
      var a = TextButton(onPressed: (){
        setState(() {
          language = i;
          Navigator.of(context).pop(false);
        });
      }, child: mainTextFAQS(i, textColor, 15.0, FontWeight.normal, 1));
      setState(() {
        allLanguages.add(a);
      });
    }
  }

  getFrequency(){
    List ag = ["1","2"];
    for(var i in ag){
      var a = TextButton(onPressed: (){
        setState(() {
          frequency = i;
          Navigator.of(context).pop(false);
        });
      }, child: mainTextFAQS("$i day a week", textColor, 15.0, FontWeight.normal, 1));
      setState(() {
        allFrequency.add(a);
      });
    }
    setState(() {
      String f = "";
      final fk = GlobalKey<FormState>();

      allFrequency.add(
        Form(
          key: fk,
          child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[1-7]"))
            ],
            style: TextStyle(
              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.number,
            maxLength: 1,

            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Custom",
              suffixIcon: IconButton(
                icon: Icon(Iconsax.tick_circle,color: greenColor,),
                onPressed: (){
                  if(fk.currentState!.validate()) {
                    Navigator.of(context).pop(false);
                    setState(() {
                      frequency = f;
                    });
                  }
                },
              ),
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
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
                return("Please Select Custom Days");
              }
              else{
                return null;
              }
            },
            onChanged: (text){
              f = text.toString();
            },

          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        home:Scaffold(
            backgroundColor: bgColor,
            body: Stack(
              children: [
                DraggableHome(
                  headerExpandedHeight: 0.45,
                    stretchMaxHeight: 0.55,
                    title: mainText("Find your Tutor",bgColor, 15.0, FontWeight.normal, 1),
                    appBarColor: secColor,
                    headerWidget: Container(
                      color: secColor,
                      child: Stack(
                        children: [
                          bgcircles(context, bgColor),
                          Blur(context, 80),
                          SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Spacer(),
                                    Image.asset('Assets/findtutor.png',width: MediaQuery.of(context).size.width * 0.70,),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(height: 5.0,),
                                mainText("Find your Tutor",bgColor, 25.0, FontWeight.normal, 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),



                    body:[SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                      child: Form(
                          key: formKey,
                          child:
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              onlymainText("Tutor For", Colors.grey, 11.0, FontWeight.normal, 1),
                              GestureDetector(
                                onTap:(){
                                  if(stateofonlyHome.parent) {
                                    findChildren();
                                  }
                                  },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  height: 80.0,
                                  child: Card(
                                    elevation: 5.0,
                                    color: secColor,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          // margin: EdgeInsets.only(),
                                          child:
                                          Transform.translate(
                                            offset: Offset(
                                              -40.0,
                                              -40.0,
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: mainColor,
                                              radius: 60.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
                                          child: cardItem
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.0,),

                              onlymainText("Subjects", Colors.grey, 11.0, FontWeight.normal, 1),

                              Visibility(
                                visible: showSubs,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: allSubjects,
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.0,),

                              mainTextFAQS("Requirements", textColor, 15.0, FontWeight.bold, 1),

                              SizedBox(height: 20.0,),

                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text:tutor_gender),
                                style: TextStyle(

                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 48,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "tutor gender",
                                  labelText: "Tutor Gender",
                                  suffixIcon: Icon(Iconsax.woman,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                    return("Please Select Your Gender");
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (text){
                                  tutor_gender = text;
                                },
                                onTap: (){
                                  showGender();
                                },

                              ),

                              SizedBox(height: 20.0,),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: ageGroup),
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 10,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "tutor age group",
                                  labelText: "Tutor Age Group",
                                  suffixIcon: Icon(Iconsax.calendar,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                    return("Please Select tutor age group");
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (text){
                                  ageGroup = text;
                                },
                                onTap: (){
                                  showAge();
                                },

                              ),

                              SizedBox(height: 20.0,),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: tution_time),
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 20,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "Tution Time",
                                  labelText: "Tution Time",
                                  suffixIcon: Icon(Iconsax.clock,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                    return("Please Select tution time");
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (text){
                                  tution_time = text;
                                },
                                onTap: (){
                                  tutionTime();
                                },

                              ),

                              SizedBox(height: 20.0,),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: tution_duration),
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 20,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "Tution Duration",
                                  labelText: "Tution Duration",
                                  suffixIcon: Icon(Iconsax.timer_1,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                    return("Please Select Tution Duration");
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (text){
                                  tution_duration = text;
                                },
                                onTap: (){
                                  bottoms(context, Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: allDurations
                                  ));
                                },

                              ),

                              SizedBox(height: 20.0,),
                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: start_date),
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 20,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "Tution Start Date",
                                  labelText: "Tution Start Date",
                                  suffixIcon: Icon(Iconsax.calendar,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                    return("Please Select Tution Start Date");
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (text){
                                  start_date = text;
                                },
                                onTap: (){
                                  startDatePicker();
                                },

                              ),

                              SizedBox(height: 20.0,),

                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: frequency),
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 30,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "Frequency of Tuition",
                                  labelText: "Days per week",
                                  suffixIcon: Icon(Iconsax.timer_1,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                    return("Please Select Frequency of Tution");
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (text){
                                  start_date = text;
                                },
                                onTap: (){
                                  frequencyPicker();
                                },

                              ),

                              SizedBox(height: 20.0,),

                              TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: language),
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.text,
                                maxLength: 30,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "Preferred Language",
                                  labelText: "Language",
                                  suffixIcon: Icon(Iconsax.speaker,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                    return("Please Select Preferred Language");
                                  }
                                  else{
                                    return null;
                                  }
                                },
                                onChanged: (text){
                                  language = text;
                                },
                                onTap: (){
                                  languagePicker();
                                },

                              ),

                              SizedBox(height: 20.0,),

                              onlymainText("Budget Range", Colors.grey, 11.0, FontWeight.normal, 1),
                              onlymainText("₹${_currentRangeValues.start} to ₹${_currentRangeValues.end}", secColor, 15.0, FontWeight.bold, 1),

                              RangeSlider(values: _currentRangeValues,
                                  divisions: 20,
                                  max:3000,

                                  labels: RangeLabels(
                                    _currentRangeValues.start.round().toString(),
                                    _currentRangeValues.end.round().toString(),
                                  ),

                                  onChanged: (values){
                                setState(() {
                                  _currentRangeValues = values;
                                });
                                  }),
                              
                              SizedBox(height: 20.0,),


                              mainTextFAQS("Additional", textColor, 15.0, FontWeight.bold, 1),

                              SizedBox(height: 10.0,),
                              TextFormField(
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 2,
                                maxLength: 180,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "What are your Goals for this tution",
                                  labelText: "Goals",
                                  suffixIcon: Icon(Iconsax.archive,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                onChanged: (text){
                                  goals = text;
                                },

                              ),

                              SizedBox(height: 20.0,),
                              TextFormField(
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 2,
                                maxLength: 180,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "How you hear about us",
                                  labelText: "hear about us",
                                  suffixIcon: Icon(Iconsax.sound,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                onChanged: (text){
                                  hearaboutus = text;
                                },

                              ),

                              SizedBox(height: 20.0,),
                              TextFormField(
                                style: TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 15.0,
                                  color:textColor,
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 2,
                                maxLength: 180,

                                decoration: InputDecoration(

                                  counterText: "",
                                  filled: true,
                                  fillColor: lightWhite,
                                  hintText: "Additional Comments",
                                  labelText: "Additional Comments",
                                  suffixIcon: Icon(Iconsax.message_2,color: mainColor,),
                                  // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                                  hintStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
                                  ),
                                  labelStyle: TextStyle(
                                      fontFamily: 'mons',
                                      color:Colors.grey
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
                                onChanged: (text){
                                  additional = text;
                                },

                              ),


                              SizedBox(height: 25.0,),


                             Container(
                                 width: MediaQuery.of(context).size.width,
                                 height: 50.0,
                                 child: custombtnsss("SUBMIT ENQUIRY", () {Complete(); }, secColor, Colors.white, 15.0))

                            ],
                          )
                      ),
                    ),]
                ),
                loaderss(isHide, "Hold onnn", true, context),
              ],
            )
        )
    );
  }

  Complete(){
    if(formKey.currentState!.validate()){
      if(childData == {}){
        print("nochild");
      }
      else if(mySubjects.isEmpty){
        print("nosub");
        toaster(context,"Please Select a Subject");
      }
      else{
        submitInquire();

      }
    }
  }

  submitInquire() async{
    setState(() {
      isHide = true;
    });
    http.Response response = await http.post(Uri.parse(submitInquireUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'child':childData['id'],
        'parent':stateofHomeScreen.userCode.toString(),
        'gender':tutor_gender,
        'age':ageGroup,
        'time':tution_time,
        'duration':tution_duration,
        'startdate':startDate.toString().split(" ")[0],
        'subjects':jsonEncode(mySubjects),
        'hearaboutus':hearaboutus,
        'language':language,
        'frequency':frequency,
        'budget': _currentRangeValues.start.toString() + "-" + _currentRangeValues.end.toString(),
        'goals':goals,
        'additionalcomments':additional,
        'status':'pending',
      }),
    );

    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      toaster(context,"Enquire Submitted Successfully");
      checker(_auth.currentUser!.uid, context);
    }
    else{
      setState(() {
        isHide = false;
        toaster(context,"Something went wrong");
      });
    }

  }


  showGender(){
    bottoms(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(onPressed: (){
          setState(() {
            tutor_gender = "male";
          });
          Navigator.of(context).pop(true);
        }, child: Row(
          children: [
            Icon(Iconsax.man,color: textColor,),
            SizedBox(width: 5.0,),
            mainText("male", textColor, 15.0, FontWeight.normal, 1),
          ],
        )),
        TextButton(onPressed: (){
          setState(() {
            tutor_gender = "female";
          });
          Navigator.of(context).pop(true);
        }, child: Row(
          children: [
            Icon(Iconsax.woman,color: textColor,),
            SizedBox(width: 5.0,),
            mainText("female", textColor, 15.0, FontWeight.normal, 1),
          ],
        )),
        TextButton(onPressed: (){
          setState(() {
            tutor_gender = "Any";
          });
          Navigator.of(context).pop(true);
        }, child: Row(
          children: [
            Icon(Iconsax.user,color: textColor,),
            SizedBox(width: 5.0,),
            mainText("Any", textColor, 15.0, FontWeight.normal, 1),
          ],
        )),
      ],
    ));
  }

  showAge(){
    bottoms(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: allAgs
    ));
  }

  frequencyPicker(){
    newbottoms(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: allFrequency
    ));
  }

  languagePicker(){
    bottoms(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: allLanguages
    ));
  }

  Future<bool> findChildren() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        titleTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 20.0, color: greenColor,),
        contentTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 13.0, color: Colors.grey),
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        actionsAlignment: MainAxisAlignment.center,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: onlymainText("Select Child", textLight, 15.0, FontWeight.bold, 1),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: allChilds
        ),
        // actions: <Widget>[
        //   custombtnsss("SUBMIT", () { }, greenColor, Colors.white, 10.0),
        //   SizedBox(width: 5.0,),
        //   custombtnsss("CLOSE", () { }, redColor, Colors.white, 10.0),
        // ],
      ),
    )) ?? false;
  }

  tutionTime() async{
    Navigator.push(context, showPicker(
        context: context,
        value: t_time,
        onChange: (times){
          setState(() {
            t_time = times;
          },
          );
        },
        onChangeDateTime: (dateTime){
          setState(() {
            tution_time = DateFormat('HH:mm').format(dateTime).toString();
          });
        },

    ));
  }

  startDatePicker(){

    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 60)),
    ).then((date) {
      if (date != null) {
        print(date);
        String formattedDob = DateFormat('dd-MM-yyyy').format(date);
        setState(() {
          startDate = date;
          start_date = formattedDob;
        });
      }
    });

    // DatePicker.showDatePicker(context,
    //       showTitleActions: true,
    //       minTime: DateTime.now().add(Duration(days: 1)),
    //       maxTime: DateTime.now().add(Duration(days: 60)),
    //       currentTime: DateTime.now().add(Duration(days: 1)),
    //       onChanged: (date){
    //         if(date != null){
    //           print(date);
    //         }
    //       },
    //       onConfirm: (date){
    //         if(date != null){
    //           String formattedDob = DateFormat('dd-MM-yyyy').format(date);
    //           setState(() {
    //             startDate = date;
    //             start_date = formattedDob;
    //           });
    //         }
    //       },
    //       // theme: DatePickerTheme(
    //       //   itemStyle: TextStyle(
    //       //       color: textLight,
    //       //       fontFamily: 'mons',
    //       //       fontSize:17.0
    //       //   ),
    //       //   doneStyle: TextStyle(
    //       //     color: mainColor,
    //       //     fontFamily: 'mons',
    //       //     fontSize: 20.0,
    //       //   ),
    //       //   cancelStyle: TextStyle(
    //       //     color: textColor,
    //       //     fontFamily: 'mons',
    //       //     fontSize: 20.0,
    //       //   ),
    //       // )
    //   );
    }


}

class subjectCard extends StatefulWidget {

  String title;
  String img;
  String id;

  subjectCard({Key? key,required this.title,required this.img,required this.id}) : super(key: key);

  @override
  State<subjectCard> createState() => _subjectCardState();
}

class _subjectCardState extends State<subjectCard> {
  Color bg = Colors.white;

  Color circles = lightWhite;
  Color text = secColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.only(right: 10.0),
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image.asset(i,width: 30.0,),
              // SizedBox(width: 5.0,),
              mainText(widget.title, text, 13.0, FontWeight.normal, 1),
            ],
          ),
        ),
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(bg),
            backgroundColor: MaterialStateProperty.all<Color>(bg),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: bg, width: 0.0)))),
        onPressed: (){
          if(bg == Colors.white){
            setState(() {
              bg = secColor;
              circles = mainColor;
              text = Colors.white;
              stateofInquire.setState(() {
                stateofInquire.mySubjects.add(widget.id);
              });
            });
          }
          else{
            setState(() {
              bg = Colors.white;
              circles = lightWhite;
              text = secColor;
              stateofInquire.setState(() {
                stateofInquire.mySubjects.remove(widget.id);
              });
            });
          }
        },
      ),
    );
  }
}


