import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Class/OneClass.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:file_picker/file_picker.dart';


late BuildContext mCtx;

late _PDFtestReportState stateOfPdfTestReport;
class PDFtestReport extends StatefulWidget {
  Map data;
  Map testData;
  PDFtestReport({Key? key,required this.data,required this.testData}) : super(key: key);

  @override
  State<PDFtestReport> createState() {
    stateOfPdfTestReport = _PDFtestReportState();
    return stateOfPdfTestReport;
  }
}

class _PDFtestReportState extends State<PDFtestReport> with WidgetsBindingObserver {
  bool isHide = false;



  bool mcq = true;
  String testUrl = "";
  Widget myPdf = Column();
  FirebaseAuth _auth = FirebaseAuth.instance;
  File mySubmission = File("");

  int passMarks = 0;
  int myMarks = 0;
  String message = "";


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getSubmission();
  }


  getSubmission() async{
    setState(() {
      isHide = true;
      passMarks = int.parse(widget.testData['pass_marks']);
    });
    http.Response response = await http.post(Uri.parse(getSubmissionByAssignTestId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'assigned_test':widget.data['id'],
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      Map sd = aa['submission'][0];
      Map aaa = jsonDecode(sd['submission']);
      setState(() {
        isHide = false;
        message = aaa['message'];
        myMarks = int.parse(sd['marks']);
      });

    }
  }







  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.paused) {

      //do your stuff
    }
  }




  Future<bool> close() async {

    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titleTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 20.0, color: greenColor,),
        contentTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 13.0, color: Colors.grey),
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        actionsAlignment: MainAxisAlignment.center,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Row(
          children: [
            Spacer(),
            onlymainText("Quit Test", redColor, 20.0, FontWeight.bold, 1),
            Spacer(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Spacer(),
                onlymainText("Do You want to Quit the Test", textLight, 13.0, FontWeight.normal,1),
                Spacer(),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Spacer(),
                onlymainTextCenter("You cannot Quit the test\n"
                    "if you quit you cannot\nattempt it again", textLight, 15.0, FontWeight.bold,3),
                Spacer(),
              ],
            ),


            SizedBox(height: 10.0,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              height: 50.0,
              child:newiconbtnsss("QUIT", () {
                setState(() {
                  isHide = true;
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              }, redColor,Colors.white,Iconsax.tick_circle,10.0),
            ),


          ],
        ),

      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    mCtx = context;
    return MaterialApp(
      home: WillPopScope(
        onWillPop: close,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,

            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.clear
                ,color: textColor,),
            ),

          ),
          body: Stack(
            children: [
              newbgcircles(context, secColor),
              Blur(context, 100),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: mainPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainTextFAQS("Test Report for", textColor, 15.0, FontWeight.bold, 1),
                    mainTextFAQS(widget.testData['title'], textLight, 30.0, FontWeight.bold, 1),
                    onlymainText("${stateofHomeScreen.widget.gradesData[widget.testData['grade']]['title']} "
                        "${stateofHomeScreen.widget.gradesData[widget.testData['grade']]['board']}", Colors.grey, 10.0, FontWeight.normal, 1),
                    onlymainText("${stateofHomeScreen.widget.subjectData[widget.testData['subject']]['title']}"
                        , Colors.grey, 10.0, FontWeight.normal, 1),

                    SizedBox(height: 20.0,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mainTextFAQS("Passing Marks : $passMarks", textColor, 20.0, FontWeight.bold, 1),
                              mainTextFAQS("My Marks : $myMarks", textColor, 20.0, FontWeight.bold, 1),
                              Visibility(
                                  visible: myMarks >= passMarks,
                                  child: mainTextFAQS("PASS", greenColor, 30.0, FontWeight.bold, 1)),
                              Visibility(
                                  visible: !(myMarks >= passMarks),
                                  child: mainTextFAQS("FAIL", redColor, 30.0, FontWeight.bold, 1)),

                            ],
                          ),
                        ),
                      ),


                    ),

                    SizedBox(height: 20.0,),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mainTextFAQS("Message From Tutor", textColor, 15.0,FontWeight.bold, 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Iconsax.message,color: secColor,size: 40.0,),
                                  Expanded(child: mainTextFAQS(message, textColor, 15.0, FontWeight.bold, 20)),
                                ],
                              ),


                            ],
                          ),
                        ),
                      ),


                    ),

                  ],
                ),
              ),


              loaderss(isHide, "Please White", true, context)
            ],
          ),
        ),
      ),
    );
  }







}





