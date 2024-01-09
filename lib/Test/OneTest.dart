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

late _oneTestState stateOfOneTest;
class oneTest extends StatefulWidget {
  Map data;
  Map testData;
  oneTest({Key? key,required this.data,required this.testData}) : super(key: key);

  @override
  State<oneTest> createState() {
    stateOfOneTest = _oneTestState();
    return stateOfOneTest;
  }
}

class _oneTestState extends State<oneTest> with WidgetsBindingObserver {
  bool isHide = false;
  bool showQuestions = false;
  List<oneQuestion> allTheQuestions = [];
  int paper_id = 0;
  int passMarks = 0;

  int totalMinutes = 0;
  int totalSeconds = 0; // 5 minutes in seconds
  late Timer timer;
  String timeDisplay = "5:00";


  bool mcq = true;
  String testUrl = "";
  Widget myPdf = Column();
  FirebaseAuth _auth = FirebaseAuth.instance;
  File mySubmission = File("");

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
      totalMinutes = int.parse(widget.data['duration']);
      totalSeconds = totalMinutes * 60;
    });
    makeQuestionPaper();
  }

  makeQuestionPaper(){
      if(mcq) {
        List allQuestionItems = jsonDecode(widget.testData['questions']);
        for(var i in allQuestionItems){
          var a = oneQuestion(data: i);
          setState(() {
            allTheQuestions.add(a);
          });
        }
      }
      else{
        setState(() {
          testUrl = widget.testData['questions'];
          print("qqq $testUrl");
        });
      }
      Future.delayed(Duration(seconds: 1),(){
        ConfirmAttempt();
      });

  }


  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (totalSeconds > 0) {
          totalSeconds--;
          int minutes = totalSeconds ~/ 60;
          int seconds = totalSeconds % 60;
          timeDisplay = "$minutes:${seconds.toString().padLeft(2, '0')}";
        } else {
          timer.cancel();
          // Timer is done, you can add your desired action here.
          // For example, show a dialog or trigger some event.
        }
      });
    });
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


  updateTestStatus() async{
    http.Response response = await http.post(Uri.parse(updateAssignedTestUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id': widget.data['id'],
        'status':'attempt',
      }),
    );
    print(response.statusCode);
    print(response.body);
    stateofAllTests.getAssignedTest();
  }



  Future<bool> ConfirmAttempt() async {

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
        title: Row(
          children: [
            Spacer(),
            onlymainText("Attempt Test", greenColor, 20.0, FontWeight.bold, 1),
            Spacer(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Spacer(),
                onlymainText("Do You want to Attempt the Test", textLight, 13.0, FontWeight.normal,1),
                Spacer(),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Spacer(),
                onlymainText("Instruction", textLight, 15.0, FontWeight.bold,1),
                Spacer(),
              ],
            ),
            SizedBox(height: 10.0,),
            onlymainText("1. You cannot quit test there is only one attempt", Colors.grey, 10.0, FontWeight.normal,2),
            onlymainText("2. You cannot switch Tabs", Colors.grey, 10.0, FontWeight.normal,2),
            onlymainText("3. The Duration of the test in $totalMinutes Minutes", Colors.grey, 10.0, FontWeight.normal,2),


            SizedBox(height: 10.0,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              height: 50.0,
              child:newiconbtnsss("ATTEMPT", () {
                yessAttempt();
                updateTestStatus();
              }, greenColor,Colors.white,Iconsax.tick_circle,10.0),
            ),


          ],
        ),

      ),
    )) ?? false;
  }

  yessAttempt() async{
    setState(() {
      startTimer();
      isHide = false;
      showQuestions = true;
      print(testUrl);
      if(!mcq){
        myPdf = SfPdfViewer.network(testUrl);
      }
      Navigator.of(context).pop(false);
    });
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
                close();
              },
              icon: Icon(CupertinoIcons.clear
                ,color: textColor,),
            ),
            actions: [
              Row(
                children: [
                  TextButton(onPressed: (){
                    close();
                  }, child: mainTextFAQS(timeDisplay, secColor, 15.0, FontWeight.bold, 1)),
                  SizedBox(width: 10.0,),
                ],
              )
            ],
          ),
          body: Stack(
            children: [
              newbgcircles(context, secColor),
              Blur(context, 100),
              Visibility(
                visible: showQuestions,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: mainPadding,
                  child: Column(
                    children: [

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
              ),

              Visibility(
                visible: !mcq && showQuestions,
                child: Container(
                    margin: EdgeInsets.only(top: 00.0,bottom: 60.0),
                    child: myPdf),
              ),

              Container(
                alignment: Alignment.bottomCenter,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Visibility(
                          visible: mcq,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // mainTextFAQS(widget.subject, textColor, 15.0, FontWeight.bold, 1),
                              mainTextFAQS("${allTheQuestions.length} Questions", Colors.grey, 10.0, FontWeight.normal, 1),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: !mcq,
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: (){
                                pickSubmission();
                              },
                              child: mainTextFAQS("Submit My Solution", secColor, 10.0, FontWeight.bold, 1),
                            ),
                            Visibility(
                                visible: mySubmission.path != "",
                                child: onlymainText("1 file uploaded", Colors.grey, 10.0, FontWeight.normal, 1))
                          ],
                        )),
                        Spacer(),
                        Container(
                            height: 40.0,
                            child: custombtnsss("Submit", () {
                              ConfirmSubmit();
                            }, greenColor, Colors.white,10.0))
                      ],
                    ),
                  ),
                ),
              ),
              loaderss(isHide, "Please White", true, context)
            ],
          ),
        ),
      ),
    );
  }

  pickSubmission() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null){
      final file = File(result.files.single.path.toString());
      setState(() {
        mySubmission = file;
        print(mySubmission.path);
      });
    }
  }


  Future<bool> ConfirmSubmit() async {

    int totalQuestion = totalQuestions()[0];
    int mcqs = totalQuestions()[1];
    int nums = totalQuestions()[2];
    int attempt = totalQuestions()[3];


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
            onlymainText("Submit", greenColor, 20.0, FontWeight.bold, 1),
            Spacer(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (mcq)?Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Spacer(),
                    Text("You have attempted $attempt Questions"),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Text("$mcqs MCQs"),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Text("$nums Numericals"),
                    Spacer(),
                  ],
                ),
              ],
            ):
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (mySubmission.path != "")?Row(
                  children: [
                    Spacer(),
                    Text("You have Submitted One Solution"),
                    Spacer(),
                  ],
                ):
                Row(
                  children: [
                    Spacer(),
                    Text("You Haven't Submitted Any Solution"),
                    Spacer(),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            (mcq)?Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              height: 50.0,
              child:newiconbtnsss("SUBMIT", () {
                finalSubmit();
              }, greenColor,Colors.white,Iconsax.tick_circle,10.0),
            ):Visibility(
              visible: mySubmission.path != "",
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                height: 50.0,
                child:newiconbtnsss("SUBMIT", () {
                  finalSubmit();
                }, greenColor,Colors.white,Iconsax.tick_circle,10.0),
              ),
            ),


          ],
        ),

      ),
    )) ?? false;
  }

  finalSubmit() async {

    Navigator.of(context).pop(false);
    setState(() {
      isHide = true;
    });
    List submissionList = [];

    for(var i in allTheQuestions){
      Map a = i.stateofQuestion.widget.data;
      a['myanswer'] = i.stateofQuestion.myAnswer;
      submissionList.add(jsonEncode(a));
    }

    int mymarks = totalQuestions()[4];

    Map<String,String> submissionItem = {
      'tutor':widget.data['tutor'],
      'child':widget.data['child'],
      'parent':widget.data['child'],
      'assigned':widget.data['assigned'],
      'test':widget.data['test'],
      'marks':mymarks.toString(),
      'assigned_test':widget.data['id'],
      'datetime':DateTime.now().toString(),
    };

    if(mcq){
      submissionItem['submission'] = submissionList.toString();
    }
    else{
      String mysurl = await uploadImage(mySubmission.path);
      String submission = jsonEncode({
        'url':mysurl,
      });
      submissionItem['submission'] = submission;
    }


    http.Response response = await http.post(Uri.parse(createSubmissionUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(submissionItem),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      toaster(context, "You Have Successfully Submitted the Test");
      updateFinalTestStatus();
    }
  }

  updateFinalTestStatus() async{
    http.Response response = await http.post(Uri.parse(updateAssignedTestUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id': widget.data['id'],
        'status':'submit',
      }),
    );
    print("final ${response.statusCode}");
    print(response.body);
    stateofAllTests.getAssignedTest();
    if(response.statusCode == 200){
      Navigator.of(context).pop(true);


    }
  }

  List totalQuestions() {
    int tq = 0;
    int num = 0;
    int mcq = 0;
    int attempted = 0;
    int myMarks = 0;
    for(var i in allTheQuestions){
      if(i.stateofQuestion.mcq){
        if(i.stateofQuestion.myAnswer != ""){
          attempted += 1;
          mcq += 1;
        }
        if(i.stateofQuestion.myAnswer == i.stateofQuestion.answer){
          myMarks += 1;
        }

      }
      else{
        print("my answer is ${i.stateofQuestion.myAnswer}");
        if(i.stateofQuestion.myAnswer != ""){
          attempted += 1;
          num += 1;
        }
        if(i.stateofQuestion.myAnswer == i.stateofQuestion.answer){
          myMarks += 1;
        }

      }
    }
    return[mcq+num,mcq,num,attempted,myMarks];
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
      }
      else{
        answer = widget.data['answer'];
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
                  mainTextFAQS("Q.${stateOfOneTest.allTheQuestions.indexOf(this.widget) + 1} ", textColor, 15.0, FontWeight.bold, 10),
                  Expanded(child: mainTextFAQS(question, textColor, 15.0, FontWeight.normal, 10)),
                ],
              ),
              SizedBox(height: 15.0,),
              Visibility(
                  visible: mcq,
                  child: Column(
                    children: [
                      optionitem(option1, () {ChangeOption(0, widget.data['option1']);}, bgs[0], textss[0],"a)"),
                      optionitem(option2, () {ChangeOption(1, widget.data['option2']);}, bgs[1], textss[1],"b)"),
                      optionitem(option3, () {ChangeOption(2, widget.data['option3']);}, bgs[2], textss[2],"c)"),
                      optionitem(option4, () {ChangeOption(3, widget.data['option4']);}, bgs[3], textss[3],"d)"),
                    ],
                  )),
              Visibility(
                visible: !mcq,
                child: TextFormField(
                  maxLength: 20,
                  keyboardType:TextInputType.text,
                  cursorColor: mainColor,

                  style: TextStyle(
                    fontFamily: 'mons',
                    fontSize: 15.0,
                    color: mainColor,
                  ),
                  decoration: InputDecoration(
                      hintText: "Answer",
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
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: errorColor
                          )
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: mainColor
                          )
                      )
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
              )
            ],
          ),
        ),
      ),
    );
  }

  ChangeOption(int a,String ans) {
    if((a + 1).toString() == myAnswer) {
      setState(() {
        bgs = [lightWhite, lightWhite, lightWhite, lightWhite];
        textss = [textLight, textLight, textLight, textLight];
        myAnswer = "";
      });

    }
    else{
      setState(() {
        bgs = [lightWhite, lightWhite, lightWhite, lightWhite];
        textss = [textLight, textLight, textLight, textLight];
        bgs[a] = greenColor;
        textss[a] = Colors.white;
        myAnswer = (a+1).toString();
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



