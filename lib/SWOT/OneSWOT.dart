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
import 'package:fl_chart/fl_chart.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';
// import 'package:graphic/graphic.dart';
import 'package:d_chart/d_chart.dart';






late _oneSwotState stateofoneSwot;

class oneSwot extends StatefulWidget {
  Map swotdata;
  oneSwot({Key? key,required this.swotdata}) : super(key: key);

  @override
  State<oneSwot> createState() {
    stateofoneSwot = _oneSwotState();
    return stateofoneSwot;
  }
}

class _oneSwotState extends State<oneSwot> {
  bool isHide = true;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();


  Map tutorData = {};
  Map childData = {};
  Map invagilationData = {};
  Map AnswerSheet = {};
  List parentFeedBack = [];
  Map analysis = {};



  @override
  void initState() {
    // oneSignals();
    makeData();
    // updateData();
  }


  updateData() async{
    http.Response response = await http.post(Uri.parse(updateSwotUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id':widget.swotdata['id'],
        'analysis':jsonEncode({
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
        })
      }),
    );
    print(response.statusCode);
    print(response.body);
  }
  makeData() async{
    Map swotMap = jsonDecode(widget.swotdata['analysis']);
      tutorData = await getTutor(widget.swotdata['tutor']);
      childData = stateofHomeScreen.widget.childData[widget.swotdata['child']];
      invagilationData = swotMap['InavagilationAnalysis'];
      AnswerSheet = swotMap['AnswerSheetAnalyis'];
      parentFeedBack = swotMap['ParentsFeedBack'];
      analysis = swotMap['Analysis'];
      makeFeedback();

      setState((){
        isHide = false;
      });
  }

  List<Widget> allFeedBack = [];
  makeFeedback() {
    for(var i in parentFeedBack){
      var a = faqsItem(title: i['question'], answer: i['answer']);
      setState(() {
        allFeedBack.add(a);
      });
    }
  }

  Future<Map> getTutor(String id) async {
    http.Response response = await http.post(Uri.parse(getTutorUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'tutor_id': id,
      }),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map td = jsonDecode(response.body);
      Map tdd = td['tutor'];
      return tdd;
    }
    else {
      return {};
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

          body:DraggableHome(
              headerExpandedHeight: 0.45,
              stretchMaxHeight: 0.55,
              title: mainText("SWOT REPORT",bgColor, 15.0, FontWeight.normal, 1),
              appBarColor: oneCardColor,
              leading: IconButton(
                icon:Icon(Iconsax.arrow_left_2,color: Colors.white,),
                    onPressed: (){
                  Navigator.pop(context);

                  },
              ),
              alwaysShowLeadingAndAction: true,
              headerWidget: Container(
                color: oneCardColor,
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
                              Image.asset('Assets/SWOT/swot2.png',width: MediaQuery.of(context).size.width * 0.60,),
                              Spacer(),
                            ],
                          ),
                          SizedBox(height: 0.0,),
                          mainText("SWOT REPORT",bgColor, 40.0, FontWeight.bold, 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),



              body:[Stack(
                children: [
                  Visibility(
                    visible: !isHide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Card(
                            elevation: 5.0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: mainColor,
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
                                      backgroundColor: secColor,
                                      radius: 60.0,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
                                  child: Row(
                                    children: [
                                      Image.asset("Assets/oneteacher.png",width: 100.0,),
                                      SizedBox(width: 20.0,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,

                                          children: [
                                            Row(
                                              children: [
                                                Icon(Iconsax.teacher,color: Colors.white,),

                                                Expanded(child: mainTextFAQS(tutorData['name'], Colors.white, 25.0, FontWeight.bold, 1)),
                                              ],
                                            ),

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Iconsax.omega_circle,color: Colors.white,size: 20.0,),
                                                Expanded(child: mainTextFAQS(" ${tutorData['gender']}", Colors.white, 10.0, FontWeight.bold, 2)),
                                              ],
                                            ),

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Iconsax.book_1,color: Colors.white,size: 20.0,),
                                                Expanded(child: mainTextFAQS(" ${tutorData['qualification']}", Colors.white, 10.0, FontWeight.bold, 2)),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                Icon(Iconsax.timer_1,color: Colors.white,size: 20.0,),
                                                mainTextFAQS(" ${tutorData['experience']} Experience", Colors.white, 10.0, FontWeight.bold, 1),
                                              ],
                                            ),

                                            // Row(
                                            //   crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children: [
                                            //     Icon(Iconsax.verify,color: Colors.white,size: 20.0,),
                                            //     Expanded(child: mainTextFAQS(" Badge $", Colors.white, 10.0, FontWeight.bold, 2)),
                                            //   ],
                                            // ),
                                            //
                                            // Row(
                                            //   crossAxisAlignment: CrossAxisAlignment.start,
                                            //   children: [
                                            //     Icon(Iconsax.message,color: Colors.white,size: 20.0,),
                                            //     Expanded(child: mainTextFAQS(" Above Average Communication", Colors.white, 10.0, FontWeight.bold, 2)),
                                            //   ],
                                            // ),




                                               ],
                                        ),
                                      ),


                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Card(
                            elevation: 5.0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: secColor,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: [
                                            Row(
                                              children: [
                                                Icon(Iconsax.grammerly,color: Colors.white,),
                                                mainTextFAQS(" ${childData['name']}", Colors.white, 25.0, FontWeight.bold, 1),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                Icon(Iconsax.teacher,color: Colors.white,size: 20.0,),
                                                mainTextFAQS(" ${stateofHomeScreen.widget.gradesData[childData['grade']]['title']} "
                                                    "${stateofHomeScreen.widget.gradesData[childData['grade']]['board']}", Colors.white, 15.0, FontWeight.bold, 1),
                                              ],
                                            ),

                                            // Row(
                                            //   children: [
                                            //     Icon(Iconsax.book,color: Colors.white,size: 20.0,),
                                            //     mainTextFAQS(" Maths", Colors.white, 15.0, FontWeight.bold, 1),
                                            //   ],
                                            // ),




                                               ],
                                        ),
                                      ),

                                      Image.asset("Assets/onechild.png",width: 100.0,),
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Card(
                            color: oneCardColor,
                            elevation: 0.0,
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: mainText("INVIGILATION ANALYSIS",
                                  Colors.white, 15.0, FontWeight.bold,1),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            mainText("Syllabus Coverage", textLight, 15.0, FontWeight.bold,1),
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200.0,
                                  child: AspectRatio(
                                    aspectRatio: 1/1,
                                    child: DChartPie(data:[
                                      {'domain': 'Question Solving',
                                        'measure': double.parse(invagilationData['SyllbusCoverage']['rating'])
                                      },
                                      {'domain': 'Intelligence', 'measure': 10.0 - double.parse(invagilationData['SyllbusCoverage']['rating'])},
                                      ],
                                      fillColor: (pieData, index) => [secColor,lightWhite][index!],
                                      donutWidth: 20,
                                      pieLabel: (pieData, index) {
                                        return "";
                                      },

                                      labelPosition: PieLabelPosition.outside,
                                      labelColor: textColor,
                                      labelFontSize: 10,


                                      // showLabelLine: true,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 200.0,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      mainText(double.parse(invagilationData['SyllbusCoverage']['rating']).toString(), secColor, 30.0, FontWeight.bold, 1),
                                      onlymainText(invagilationData['SyllbusCoverage']['remark'], Colors.grey, 10.0, FontWeight.normal, 1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 10.0,),

                        Column(
                          children: [
                            mainText("Tuition Copy Maintenance", textLight, 15.0, FontWeight.bold,1),
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200.0,
                                  child: AspectRatio(
                                    aspectRatio: 1/1,
                                    child: DChartPie(data:[
                                      {'domain': 'Question Solving',
                                        'measure': double.parse(invagilationData['TutionCopy']['rating'])
                                      },
                                      {'domain': 'Intelligence', 'measure': 10.0 - double.parse(invagilationData['TutionCopy']['rating'])},
                                    ],
                                      fillColor: (pieData, index) => [oneCardColor,lightWhite][index!],
                                      donutWidth: 20,
                                      pieLabel: (pieData, index) {
                                        return "";
                                      },

                                      labelPosition: PieLabelPosition.outside,
                                      labelColor: textColor,
                                      labelFontSize: 10,


                                      // showLabelLine: true,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 200.0,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      mainText(double.parse(invagilationData['TutionCopy']['rating']).toString(), oneCardColor, 30.0, FontWeight.bold, 1),
                                      onlymainText(invagilationData['TutionCopy']['remark'], Colors.grey, 10.0, FontWeight.normal, 1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 10.0,),

                        Column(
                          children: [
                            mainText("Conceptual Learning", textLight, 15.0, FontWeight.bold,1),
                            Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200.0,
                                  child: AspectRatio(
                                    aspectRatio: 1/1,
                                    child: DChartPie(data:[
                                      {'domain': 'Question Solving',
                                        'measure': double.parse(invagilationData['ConceptualLearning']['rating'])
                                      },
                                      {'domain': 'Intelligence', 'measure': 10.0 - double.parse(invagilationData['ConceptualLearning']['rating'])},
                                    ],
                                      fillColor: (pieData, index) => [greenColor,lightWhite][index!],
                                      donutWidth: 20,
                                      pieLabel: (pieData, index) {
                                        return "";
                                      },

                                      labelPosition: PieLabelPosition.outside,
                                      labelColor: textColor,
                                      labelFontSize: 10,


                                      // showLabelLine: true,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 200.0,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      mainText(double.parse(invagilationData['ConceptualLearning']['rating']).toString(), greenColor, 30.0, FontWeight.bold, 1),
                                      onlymainText(invagilationData['ConceptualLearning']['remark'], Colors.grey, 10.0, FontWeight.normal, 1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Card(
                            color: oneCardColor,
                            elevation: 0.0,
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: mainText("ANSWER SHEET ANALYSIS",
                                  Colors.white, 15.0, FontWeight.bold,1),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.0,),

                        AspectRatio(aspectRatio: 16/9,
                          child: DChartBarCustom(
                            verticalDirection: true,
                            showDomainLine: true,
                            showMeasureLine: true,
                            showDomainLabel: true,
                            showMeasureLabel: true,
                            spaceBetweenItem: 25.0,
                            spaceDomainLabeltoChart: 5.0,
                            spaceDomainLinetoChart: 10.0,
                            spaceMeasureLinetoChart: 10.0,

                            radiusBar: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),

                            valuePadding: EdgeInsets.all(10),
                            measureLabelStyle: TextStyle(
                              fontSize: 10.0,
                              fontFamily: 'mons',

                            ),


                            listData: [
                              DChartBarDataCustom(value: double.parse(
                          AnswerSheet['CoceptualLearning']['rating']),
                                  valueCustom: Center(
                                    child: onlymainText("Conceptual Attributes",
                                        Colors.white, 10.0, FontWeight.normal, 2),
                                  ),
                                  label: "Invagilation\nnalysis",
                                  labelCustom:
                                  onlymainText("", textColor, 10.0, FontWeight.normal, 2),
                                  color: goodColors[3],
                                  showValue: true
                              ),
                            DChartBarDataCustom(value: double.parse(
                                AnswerSheet['TimeManagment']['rating']),
                                  valueCustom: Center(
                                    child: onlymainText("Time Management",
                                        Colors.white, 10.0, FontWeight.normal, 2),
                                  ),
                                  label: "Invagilation\nnalysis",
                                  labelCustom:
                                  onlymainText("", textColor, 10.0, FontWeight.normal, 2),
                                  color: goodColors[4],
                                  showValue: true
                              ),

                              DChartBarDataCustom(value: double.parse(
                                  AnswerSheet['PresentationSkills']['rating']),

                                  valueCustom: Center(
                                    child: onlymainText("Presentation Skills",
                                        Colors.white, 10.0, FontWeight.normal, 2),
                                  ),
                                  label: "Invagilation\nnalysis",
                                  labelCustom:
                                  onlymainText("", textColor, 10.0, FontWeight.normal, 2),
                                  color: goodColors[5],
                                  showValue: true
                              ),

                              DChartBarDataCustom(value: double.parse(
                                  AnswerSheet['QuestionUnderstanding']['rating']),
                                  valueCustom: Center(
                                    child: onlymainText("Quesion UnderStanding",
                                        Colors.white, 10.0, FontWeight.normal, 2),
                                  ),
                                  label: "Invagilation\nnalysis",
                                  labelCustom:
                                  onlymainText("", textColor, 10.0, FontWeight.normal, 2),
                                  color: goodColors[6],
                                  showValue: true
                              ),

                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Card(
                                      elevation: 0.0,
                                      color: goodColors[3],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: onlymainTextCenter("${AnswerSheet['CoceptualLearning']['rating']}", Colors.white, 15.0,
                                            FontWeight.bold, 1),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Expanded(child: mainTextFAQS("${AnswerSheet['CoceptualLearning']['remark']}", textLight, 10.0, FontWeight.normal, 2)),
                                ],
                              ),

                              SizedBox(height: 10.0,),

                              Row(
                                children: [
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Card(
                                      elevation: 0.0,
                                      color: goodColors[4],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: onlymainTextCenter("${AnswerSheet['TimeManagment']['rating']}", Colors.white, 15.0,
                                            FontWeight.bold, 1),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Expanded(child: mainTextFAQS("${AnswerSheet['TimeManagment']['remark']}", textLight, 10.0, FontWeight.normal, 2)),
                                ],
                              ),

                              SizedBox(height: 10.0,),

                              Row(
                                children: [
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Card(
                                      elevation: 0.0,
                                      color: goodColors[5],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: onlymainTextCenter("${AnswerSheet['PresentationSkills']['rating']}", Colors.white, 15.0,
                                            FontWeight.bold, 1),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Expanded(child: mainTextFAQS("${AnswerSheet['PresentationSkills']['remark']}", textLight, 10.0, FontWeight.normal, 2)),
                                ],
                              ),

                              SizedBox(height: 10.0,),

                              Row(
                                children: [
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    child: Card(
                                      elevation: 0.0,
                                      color: goodColors[6],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: onlymainTextCenter("${AnswerSheet['QuestionUnderstanding']['rating']}", Colors.white, 15.0,
                                            FontWeight.bold, 1),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.0,),
                                  Expanded(child: mainTextFAQS("${AnswerSheet['QuestionUnderstanding']['remark']}", textLight, 10.0, FontWeight.normal, 2)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.0,),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Card(
                            color: oneCardColor,
                            elevation: 0.0,
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: mainText("PARENTS FEEDBACK",
                                  Colors.white, 15.0, FontWeight.bold,1),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0,),



                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Column(
                            children: allFeedBack,
                          ),
                        ),

                        SizedBox(height: 20.0,),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          child: Card(
                            color: oneCardColor,
                            elevation: 0.0,
                            shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: mainText("ANALYSIS",
                                  Colors.white, 15.0, FontWeight.bold,1),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.0,),



                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            elevation: 0.0,
                            color: greenColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: mainTextFAQS("Strength", Colors.white, 25.0, FontWeight.bold, 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  mainTextFAQS(analysis['Strength'],
                                      Colors.white, 10.0, FontWeight.normal, 50),

                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            elevation: 0.0,
                            color: redColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: mainTextFAQS("Weakness", Colors.white, 25.0, FontWeight.bold, 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  mainTextFAQS(analysis['Weakness'],
                                      Colors.white, 10.0, FontWeight.normal, 50),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            elevation: 0.0,
                            color: secColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: mainTextFAQS("Opportunities", Colors.white, 25.0, FontWeight.bold, 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  mainTextFAQS(analysis['Opportunities'],
                                      Colors.white, 10.0, FontWeight.normal, 50),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            elevation: 0.0,
                            color: oneCardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: mainTextFAQS("Threats", Colors.white, 25.0, FontWeight.bold, 1),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  mainTextFAQS(analysis['threats'],
                                      Colors.white, 10.0, FontWeight.normal, 50),
                                ],
                              ),
                            ),
                          ),
                        ),










                        // AspectRatio(
                        //   aspectRatio: 16/9,
                        //   child: DChartPie(data:const [
                        //     {'domain': 'Test', 'measure': 90},
                        //     {'domain': 'Assesment', 'measure': 40},
                        //     {'domain': 'Regularity', 'measure': 70},
                        //   ],
                        //
                        //     fillColor: (pieData, index) => goodColors[index! + 3],
                        //     donutWidth: 40,
                        //     pieLabel: (pieData, index) {
                        //       return "${pieData['domain']}\n${pieData['measure']}%";
                        //     },
                        //
                        //     labelPosition: PieLabelPosition.outside,
                        //     labelColor: textColor,
                        //     labelFontSize: 10,
                        //
                        //
                        //     // showLabelLine: true,
                        //   ),
                        // ),




                      ],
                    ),
                  ),
                  loaderss(isHide, "Please Wait", true, context)
                ],
              )]
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
          color: lightWhite,
          child: ExpansionTile(

            title: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: mainTextFAQS("• " + title, textColor, 15.0, FontWeight.bold, 4)),
                  ],
                ),
                SizedBox(height: 10.0,),

              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: mainTextFAQS(answer, Colors.grey, 10.0, FontWeight.normal, 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


