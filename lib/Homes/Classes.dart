import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Children/AddChildren.dart';
import 'package:student/Class/OneClass.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Inquire/RaiseInquire.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';


import 'Homes.dart';




late _classesState stateofClasses;



class classes extends StatefulWidget {
  Map data;

  classes({Key? key, required this.data}) : super(key: key);

  @override
  State<classes> createState() {
    stateofClasses = _classesState();
    return stateofClasses;
  }
}

class _classesState extends State<classes> {
  bool isHide = false;
  bool noClass = true;
  List<Widget> allClases = [];


  @override
  void initState() {
    print(DateTime.now());
    getClasses();
  }

  getClasses() async {
    setState(() {
      isHide = true;
    });
    User? auth = FirebaseAuth.instance.currentUser;
    http.Response response = await http.post(Uri.parse(getClassParentUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'parent': stateofHomeScreen.userCode.toString()
      }),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map aa = jsonDecode(response.body);
      List cd = aa['classes'];
      for (var i in cd) {
        Map tutorData = await getTutor(i['tutor']);
        var a = classCard(data: i, tutorData: tutorData,);
        setState(() {
          allClases.add(a);
        });
        if (cd.last == i) {
          setState(() {
            isHide = false;
            noClass = false;
          });
        }
      }
    }
    else {
      setState(() {
        isHide = false;
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
    return Stack(
      children: [
        Padding(
          padding: mainPadding,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainTextFAQS("Classes", textColor, 15.0, FontWeight.bold, 1),
                SizedBox(height: 20.0,),
                Column(
                  children: allClases,
                ),

              ]
          ),
        ),
        customNotFound(noClass, "No Classes", "Assets/findtutor.png", context,
            Column()),
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




