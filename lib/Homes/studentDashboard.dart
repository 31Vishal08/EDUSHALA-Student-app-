import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Calendar/ClassSchedule.dart';
import 'package:student/Children/AddChildren.dart';
import 'package:student/Class/OneClass.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/Homes/Notice.dart';
import 'package:student/Inquire/Assignedtutor.dart';
import 'package:student/Inquire/MyInquire.dart';
import 'package:student/Inquire/RaiseInquire.dart';
import 'package:student/SWOT/SWOT.dart';
import 'package:student/Tutor/TutorSliders.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:intl/intl.dart';


import 'package:url_launcher/url_launcher.dart';




late _studentDashboardState stateofStudentDashboard;



class studentDashboard extends StatefulWidget {
  Map studentData;
  studentDashboard({Key? key,required this.studentData}) : super(key: key);

  @override
  State<studentDashboard> createState() {
    stateofStudentDashboard = _studentDashboardState();
    return stateofStudentDashboard;
  }
}

class _studentDashboardState extends State<studentDashboard> {
  bool isHide = false;
  bool noClass = true;
  List<Widget> allClases = [];
  List allClassesData = [];
  List allSubmissionData = [];

  List<Widget> allEnquires = [];
  bool noEnquiresound = false;

  @override
  void initState() {
    getClasses();
    getEnquireData();
  }

  getClasses() async{
    setState(() {
      isHide = true;
    });
    User? auth = FirebaseAuth.instance.currentUser;
    http.Response response = await http.post(Uri.parse(getClassChildUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'child': widget.studentData['id']
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      List cd = aa['classes'];
      allClassesData = cd;
      for(var i in cd){
        Map tutorData = await getTutor(i['tutor']);
        var a = classCard(data: i,tutorData: tutorData,);
        setState(() {
          allClases.add(a);
        });
        if(cd.last == i){
          setState(() {
            isHide = false;
            noClass = false;
          });
          getSubmission();
        }
      }
    }
    else{
      setState(() {
        isHide = false;
        noClass = true;
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

  getEnquireData() async{

    http.Response response = await http.post(Uri.parse(getInquirebyChildUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'child': widget.studentData['id'],
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
        noEnquiresound = true;

      });
    }
  }

  getSubmission() async{
    http.Response response = await http.post(Uri.parse(getSubmissionByChildId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'child':widget.studentData['id'],
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      allSubmissionData = aa['submission'];
    }
    stateofHomeScreen.setState(() {
      stateofHomeScreen.heads = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          oneCard(icon: Icon(Iconsax.screenmirroring,size: 50.0,), title: "${allClases.length}", sub: "Classes"),
          oneCard(icon: Icon(Iconsax.book_1,size: 50.0,), title: "${allSubmissionData.length}", sub: "Tests Given"),
        ],
      );
    });
  }




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Column(
          children: [

            Visibility(
              visible: !noClass && !isHide,
              child: Column(
                  children: [
                    // childProgressCard(),

                    notice(),

                    oneMoreCard(title: "Class Schedule", sub: "View Upcoming Class Schedule", image: "Assets/VS/onevs.png",
                      c: secColor, callback: (){
                        navScreen(classSchedule(classData: allClassesData,), context, false);
                      },
                    ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: oneMoreCard(icon: const Icon(Iconsax.book,color: Colors.white,size: 30.0,),
                    //         title: "Class Schedule", sub: "View Upcoming Class Schedule", image: "Assets/VS/onevs.png",
                    //         c: secColor, callback: (){
                    //           navScreen(classSchedule(classData: allClassesData,), context, false);
                    //         },
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: oneMoreCard(icon: const Icon(Iconsax.book,color: Colors.white,size: 30.0,),
                    //           title: "S.W.O.T.", sub: "what is swot", image: "Assets/SWOT/swot1.png", c: redColor, callback: (){
                    //         navScreen(swotSliders(), context, false);
                    //       }),
                    //     ),
                    //   ],
                    // ),

                    Row(
                      children: [
                        Expanded(child: mainTextFAQS("upcoming classes", textLight, 15.0, FontWeight.bold, 1)),
                        TextButton(onPressed: (){}, child: onlymainText("View All", secColor, 10.0, FontWeight.normal,1))
                      ],
                    ),

                    Column(
                      children: allClases,
                    ),

                    onemoreMoreCard(title: "Study Materials", sub: "Find Study Material for your Child", image: "Assets/VS/why.png",
                      c: oneCardColor, callback: (){},
                    )
                  ]
              ),
            ),

            Visibility(
              visible: noClass && !isHide,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainTextFAQS("you are not enrolled in any class",
                      textColor, 15.0, FontWeight.bold, 1),
                  SizedBox(height: 20.0,),
                ],
              )
            ),

            Visibility(
                visible: !noEnquiresound && !isHide,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        mainTextFAQS("My Enquires",
                            textColor, 15.0, FontWeight.bold, 1),
                        Spacer(),
                        IconButton(onPressed: (){}, icon: Icon(Iconsax.arrow_circle_right,color: secColor,))
                      ],
                    ),
                    Column(
                      children: allEnquires,
                    ),
                  ],
                )
            ),
          ],
        ),

        loaderss(isHide, "Please Wait", true, context)
      ],
    );
  }
}


class classCard extends StatefulWidget {
  Map data;
  Map tutorData;
  classCard({Key? key,required this.data,required this.tutorData}) : super(key: key);

  @override
  State<classCard> createState() => _classCardState();
}

class _classCardState extends State<classCard> {

  Map childData = {};
  String subjects = "";
  bool getAttendacne = false;
  bool activeClass = false;
  int attendClass = 0;
  int totalClass = 0;

  @override
  void initState() {
    print(widget.data);
    getAttend();
    getChildData();
  }

  getAttend() async{
    setState(() {
      getAttendacne = true;
    });
    http.Response response = await http.post(Uri.parse(getAttendacneByAssignId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'assigned': widget.data['id'],
      }),
    );
    print(response.statusCode);
    print(response.body);
    double totalCredits = double.parse(widget.data['credits']);
    double currentCredits = 0.0;

    totalClass = 4 * int.parse(widget.data['frequency']);
    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      List allAt = aa['attendance'];
      for(var i in allAt){
        setState((){
          attendClass += 1;
        });
        currentCredits += double.parse(i['credit']);
      }
      setState(() {
        getAttendacne = false;
      });
      if(currentCredits >= totalCredits){
        setState(() {
          activeClass = false;
        });
      }
      else{
        setState(() {
          activeClass = true;
        });
      }
    }
    else{
      setState(() {
        totalClass = 4 * int.parse(widget.data['frequency']);
        attendClass = 0;
        activeClass = true;
        getAttendacne = false;
      });
    }
  }

  getChildData(){
    setState(() {
      childData = stateofHomeScreen.widget.childData[widget.data['child']];
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      height: MediaQuery.of(context).size.height * 0.40,
      child: Card(
        elevation: 0.0,
        color: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Image.asset("Assets/VS/threevs.png",width: 300.0,),
            ),


            Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.topRight,
              height: 60.0,
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.clock,color: secColor,),
                      mainText(widget.data['time'], secColor, 15.0, FontWeight.bold, 1),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,

              child: Card(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Stack(
                  children: [
                    Container(
                        height: 150.0,
                        child: custimBlur(context, (activeClass)?secColor:redColor, 0.5, 10.0)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    onlymainText("tuition for", Colors.white, 10.0, FontWeight.normal, 1),
                                    mainTextFAQS(childData['name'], Colors.white, 20.0, FontWeight.bold, 1),
                                    Row(
                                      children: [
                                        Icon(Iconsax.teacher,color: Colors.white,),
                                        SizedBox(width: 10.0,),
                                        mainTextFAQS(widget.tutorData['name'], Colors.white, 15.0, FontWeight.bold, 1),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(onPressed: (){
                                navScreen(oneClass(tutorData: widget.tutorData, childData: childData, classData: widget.data), context, false);
                              }, icon: Icon(Iconsax.arrow_circle_right,color: Colors.white,))
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Expanded(child: Container(
                                height: 40.0,
                                child: Card(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Colors.white,
                                          width: 1.0
                                      )
                                  ),
                                  child: Center(child: mainText("$attendClass Attended", Colors.white, 10.0, FontWeight.bold, 1)),
                                ),
                              )),
                              SizedBox(width: 5.0,),
                              Expanded(child: Container(
                                height: 40.0,
                                child: Card(
                                  elevation: 0.0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Colors.white,
                                          width: 1.0
                                      )
                                  ),
                                  child: Center(child: mainText("${totalClass - attendClass} Remaining", Colors.white, 10.0, FontWeight.bold, 1)),
                                ),
                              )),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class childProgressCard extends StatefulWidget {
  const childProgressCard({Key? key}) : super(key: key);

  @override
  State<childProgressCard> createState() => _childProgressCardState();
}

class _childProgressCardState extends State<childProgressCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 20.0),
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Row(

                    children: [
                      Column(
                        children: [
                          Avatars("", 0, "", 30.0),
                          onlymainText("Random Child", textLight, 10.0, FontWeight.bold, 1),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              mainText("30", secColor, 20.0, FontWeight.bold, 1),
                              onlymainText("Classes", mainColor, 10.0, FontWeight.normal, 1),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              mainText("70", secColor, 20.0, FontWeight.bold, 1),
                              onlymainText("Tests", mainColor, 10.0, FontWeight.normal, 1),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              mainText("5", secColor, 20.0, FontWeight.bold, 1),
                              onlymainText("Classes", mainColor, 10.0, FontWeight.normal, 1),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: borderbtnsss("VIEW DETAILED REPORT", () { }, secColor, secColor))
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}

class oneCard extends StatelessWidget {
  Icon icon;
  String title;
  String sub;
  oneCard({Key? key,required this.icon,required this.title,required this.sub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      width: 110.0,
      child: Card(
        color: Colors.white,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(height: 10.0,),
              mainText(title, textLight, 30.0, FontWeight.bold, 1),
              onlymainText(sub, Colors.grey, 10.0, FontWeight.normal, 1),
            ],
          ),
        ),
      ),
    );
  }
}


class oneMoreCard extends StatelessWidget {
  String title;
  String sub;
  String image;
  Color c;
  VoidCallback callback;
  oneMoreCard({Key? key,required this.title,
    required this.sub,required this.image,required this.c,required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: 200.0,
                  child: Image.asset(image,alignment: Alignment.center,width: 200.0,)),
              custimBlur(context, c, 0.6, 5.0),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(image,height: 150.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          mainText(title, Colors.white, 30.0, FontWeight.bold, 1),
                          onlymainText(sub, Colors.white, 10.0, FontWeight.normal, 1),
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
    );
  }
}


class onemoreMoreCard extends StatelessWidget {
  String title;
  String sub;
  String image;
  Color c;
  VoidCallback callback;
  onemoreMoreCard({Key? key,required this.title,
    required this.sub,required this.image,required this.c,required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: 200.0,
                  child: Image.asset(image,alignment: Alignment.center,width: 200.0,)),
              custimBlur(context, c, 0.6, 5.0),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          mainText(title, Colors.white, 30.0, FontWeight.bold, 1),
                          onlymainText(sub, Colors.white, 10.0, FontWeight.normal, 1),
                        ],
                      ),
                    ),
                    Image.asset(image,height: 200.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
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












