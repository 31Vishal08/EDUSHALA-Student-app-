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
import 'package:student/SWOT/OneSWOT.dart';
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




Map aaa = {
  'InavagilationAnalysis':{
    'SyllbusCoverage':{
      'rating':'7.5',
      'remark':'Nice Work',
    },
    'AnnwerSheetAnalysis':{
      'rating':'7.5',
      'remark':'Nice Work',
    },
    'ConceptualLearning':{
      'rating':'7.5',
      'remark':'Nice Work',
    },

  },
  'AnswerSheetAnalyis':{
    'CoceptualLearning':{
      'rating':'7.5',
      'remark':'Nice Work',
    },
    'TimeManagment':{
      'rating':'7.5',
      'remark':'Nice Work',
    },
    'PresentationSkills':{
      'rating':'7.5',
      'remark':'Nice Work',
    },
    'QuestionUnderstanding':{
      'rating':'7.5',
      'remark':'Nice Work',
    },

  },
  'ParentsFeedBack':[
    {'question':"This is feedfack",
      'answer':'this is answer'
    },
    {'question':"This is feedfack",
      'answer':'this is answer'
    },
    {'question':"This is feedfack",
      'answer':'this is answer'
    },
    {'question':"This is feedfack",
      'answer':'this is answer'
    },
    {'question':"This is feedfack",
      'answer':'this is answer'
    },
  ],
  'Analysis':{
    'Strength':'bhut saari strength',
    'Weakness':'bhut saari weakness',
    'Opportunities':'bhut saari opportunities',
    'threats':'bhut saare threats',
  }
};

late _mySwotsState stateofMySwots;

class mySwots extends StatefulWidget {
  mySwots({Key? key,}) : super(key: key);

  @override
  State<mySwots> createState() {
    stateofMySwots = _mySwotsState();
    return stateofMySwots;
  }
}

class _mySwotsState extends State<mySwots> {
  bool isHide = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Widget> allSwots = [];
  bool notFound = false;

  final formKey = GlobalKey<FormState>();



  @override
  void initState() {
    // oneSignals();
    getSwots();
  }



  getSwots() async{
    setState(() {
      isHide = true;
    });
    http.Response response = await http.post(Uri.parse(getSwotbyParentId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'parent':stateofHomeScreen.widget.data['user_id']
      }),
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      List allS = aa['swot'];
      for(var i in allS){
        var a = swotCard(data: i);
        setState(() {
          allSwots.add(a);
          isHide = false;
        });
      }

    }
    else{
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
                      mainTextFAQS("My SWOTS", textColor, 20.0, FontWeight.bold, 1),
                      SizedBox(height: 20.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: allSwots,
                      ),

                    ],
                  ),
                ),

                customNotFound(!isHide && notFound, "You have not any SWOT", "Assets/SWOT/swot1.png", context, Column()),

                loaderss(isHide, "Please Wait", true, context),


              ]
          )
      ),
    );
  }
}

class swotCard extends StatefulWidget {
  Map data;
  swotCard({Key? key,required this.data}) : super(key: key);

  @override
  State<swotCard> createState() => _swotCardState();
}

class _swotCardState extends State<swotCard> {


  @override
  void initState() {
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 0.0,
        color: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("Assets/SWOT/swot2.png",width: 100.0,),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        onlymainText('SWOT report for', Colors.grey, 10.0,FontWeight.normal, 6),
                        mainTextFAQS(stateofHomeScreen.widget.childData[widget.data['child']]['name'],
                            textLight, 20.0,FontWeight.bold, 2),

                      ],
                    ),
                  ),
                ],
              ),
              (widget.data['status'] == "pending")?Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
                child: custombtnsss("SWOT Pending",(){
                  toaster(context, "SWOT is Currently being Prepared");
                },oneCardColor,Colors.white,10.0),
              ):Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
                child: custombtnsss("View Report",(){
                  navScreen(oneSwot(swotdata: widget.data,), context, false);
                },greenColor,Colors.white,10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
