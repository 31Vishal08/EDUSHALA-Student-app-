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

late _testReportState stateOfTestReport;
class testReport extends StatefulWidget {
  Map data;
  Map testData;
  testReport({Key? key,required this.data,required this.testData}) : super(key: key);

  @override
  State<testReport> createState() {
    stateOfTestReport = _testReportState();
    return stateOfTestReport;
  }
}

class _testReportState extends State<testReport> with WidgetsBindingObserver {
  bool isHide = false;
  List<oneQuestion> allTheQuestions = [];



  bool mcq = true;
  String testUrl = "";
  Widget myPdf = Column();
  FirebaseAuth _auth = FirebaseAuth.instance;
  File mySubmission = File("");

  int passMarks = 0;
  int myMarks = 0;
  int totalQuestion = 0;
  int attempted = 0;
  int totalMcq = 0;
  int totalNum = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    makePaperType();
  }

  makePaperType(){
    if(widget.testData['mode'] != 'mcq'){
      setState(() {
        mcq = false;
      });
    }
    setState(() {
      passMarks = int.parse(widget.testData['pass_marks']);
    });
    // makeQuestionPaper();
    getSubmission();
  }

  getSubmission() async{
    setState(() {
      isHide = true;
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
        makeQuestionPaper(sd);
      }
  }


  makeQuestionPaper(Map sm){
    if(mcq) {
      List allQuestionItems = jsonDecode(sm['submission']);
      for(var i in allQuestionItems){
        var a = oneQuestion(data: i);
        setState(() {
          allTheQuestions.add(a);
        });
        if(allQuestionItems.last == i){
         UpdateData();
         setState(() {
           myMarks = int.parse(sm['marks']);
         });
        }
      }
    }
    else{
      setState(() {
        testUrl = widget.testData['questions'];
        print("qqq $testUrl");
      });
    }
  }

  UpdateData(){
    Future.delayed(Duration(seconds: 1),(){
      setState(() {
        isHide = false;
        totalQuestion = allTheQuestions.length;

        attempted = totalQuestions()[0];
        totalMcq = totalQuestions()[1];
        totalNum = totalQuestions()[2];
      });
    });
  }

  List totalQuestions() {
    int tq = 0;
    int num = 0;
    int mcq = 0;
    int attempted = 0;
    int myMarks = 0;
    for(var i in allTheQuestions){
      if(i.stateofQuestion.mcq){
        if(i.stateofQuestion.widget.data['myanswer'] != ""){
          attempted += 1;
          mcq += 1;
        }
        if(i.stateofQuestion.widget.data['myanswer'] == i.stateofQuestion.answer){
          myMarks += 1;
        }

      }
      else{
        print("my answer is ${i.stateofQuestion.widget.data['myanswer']}");
        if(i.stateofQuestion.myAnswer != ""){
          attempted += 1;
          num += 1;
        }
        if(i.stateofQuestion.widget.data['myanswer'] == i.stateofQuestion.answer){
          myMarks += 1;
        }

      }
    }
    return[mcq+num,mcq,num,attempted,myMarks];
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
                              mainTextFAQS("Total Question : $totalQuestion", textColor, 20.0, FontWeight.bold, 1),
                              mainTextFAQS("Total Attempted : $attempted", textColor, 20.0, FontWeight.bold, 1),
                              mainTextFAQS("Total MCQ Attempted : $totalMcq", textColor, 20.0, FontWeight.bold, 1),
                              mainTextFAQS("Total Numerical Attempted : $totalNum", textColor, 20.0, FontWeight.bold, 1),
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
                    SizedBox(height: 10.0,),
                    Visibility(
                      visible: mcq,
                      child: Column(
                        children: allTheQuestions,
                      ),
                    ),
                    // Visibility(
                    //     visible: !mcq,
                    //     child: SfPdfViewer.network(testUrl)),
                    SizedBox(height: 45.0,),
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

class oneQuestion extends StatefulWidget {
  Map data;
  oneQuestion({Key? key,required this.data}) : super(key: key);

  late _oneQuestionState stateofQuestion;
  @override
  State<oneQuestion> createState() {
    stateofQuestion = _oneQuestionState();
    return stateofQuestion;
  }
}

class _oneQuestionState extends State<oneQuestion> {
  String question = "";
  bool mcq = true;
  String option1 = "";
  String option2 = "";
  String option3 = "";
  String option4 = "";
  String answer = "";
  String myAnswer = "";
  List<Color> bgs = [lightWhite,lightWhite,lightWhite,lightWhite];
  List<Color> textss = [textLight,textLight,textLight,textLight];

  String equation = "";
  Color fc = greenColor;


  @override
  void initState() {
    getData();
  }

  getData() async{
    setState(() {
      if(widget.data['type'] != 'mcq'){
        setState(() {
          mcq = false;
        });
      }
      makePaper();
    });
  }

  makePaper() async{
    setState(() {
      question = widget.data['question'];
      if(mcq){
        option1 = widget.data['o1'];
        option2 = widget.data['o2'];
        option3 = widget.data['o3'];
        option4 = widget.data['o4'];
        answer = widget.data['answer'];
        myAnswer = widget.data['myanswer'];
        if(myAnswer != ""){
          if(myAnswer == answer){
            ChangeOption(int.parse(answer) - 1, 0, true);
          }
          else{
            ChangeOption(int.parse(answer) - 1, int.parse(myAnswer) - 1, false);
          }
        }
      }
      else{
        answer = widget.data['answer'];
        myAnswer = widget.data['myanswer'];
        print("$answer, $myAnswer");
        if(answer != myAnswer){
          setState(() {
            fc = redColor;
          });
        }
        else if(myAnswer == ""){
          setState(() {
            fc = oneCardColor;
          });
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainTextFAQS("Q.${stateOfTestReport.allTheQuestions.indexOf(this.widget) + 1} ", textColor, 15.0, FontWeight.bold, 10),
                  Expanded(child: mainTextFAQS(question, textColor, 15.0, FontWeight.normal, 10)),
                ],
              ),
              SizedBox(height: 15.0,),
              Visibility(
                  visible: mcq,
                  child: Column(
                    children: [
                      optionitem(option1, () {}, bgs[0], textss[0],"a)"),
                      optionitem(option2, () {}, bgs[1], textss[1],"b)"),
                      optionitem(option3, () {}, bgs[2], textss[2],"c)"),
                      optionitem(option4, () {}, bgs[3], textss[3],"d)"),
                    ],
                  )),
              Visibility(
                visible: !mcq,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: TextEditingController(text: widget.data['myanswer']),
                      readOnly: true,

                      maxLength: 20,
                      keyboardType:TextInputType.text,
                      cursorColor: mainColor,

                      style: TextStyle(
                        fontFamily: 'mons',
                        fontSize: 15.0,
                        color: mainColor,
                      ),
                      decoration: InputDecoration(
                          hintText: "Not Attempted",
                          fillColor: fc,
                          filled: true,
                          // suffixIcon: Icon(Iconsax.user,color: mainColor,),
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
                        myAnswer = text;
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return("Please Enter a Answer");
                        }
                      },
                    ),
                    onlymainText(widget.data['answer'], textColor, 10.0, FontWeight.normal, 1)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ChangeOption(int a,int b,bool r) {
    if(r){
      setState(() {
        bgs[a] = greenColor;
        textss[a] = Colors.white;
      });
    }
    else{
      setState(() {

      bgs[a] = greenColor;
      bgs[b] = redColor;
      textss[a] = Colors.white;
      textss[b] = Colors.white;
      });
    }

  }
}

class optionitem extends StatelessWidget {
  VoidCallback callback;
  String title;
  String o;
  Color main;
  Color text;

  optionitem(this.title,this.callback,this.main,this.text,this.o);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: 50.0,

      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            children: [
              mainText(
                  o, text, 13.0, FontWeight.normal,1),
              SizedBox(width: 5.0,),
              Expanded(
                child: mainTextFAQS(
                    title, text, 13.0, FontWeight.normal,3),
              ),
            ],
          ),
        ),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(2.0),
            foregroundColor:
            MaterialStateProperty.all<Color>(
                main),
            backgroundColor:
            MaterialStateProperty.all<Color>(main),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                    side: BorderSide(color: main)))),
        onPressed: callback,
      ),
    );
  }
}



