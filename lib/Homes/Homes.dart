import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Children/AddChildren.dart';
import 'package:student/Homes/DashBoard.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/studentDashboard.dart';
import 'package:student/Inquire/Assignedtutor.dart';
import 'package:student/Inquire/MyInquire.dart';
import 'package:student/Inquire/RaiseInquire.dart';
import 'package:student/Tutor/TutorSliders.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';

import 'package:url_launcher/url_launcher.dart';




late _homesState stateofonlyHome;



class homes extends StatefulWidget {
  Map data;

  homes({Key? key, required this.data}) : super(key: key);

  @override
  State<homes> createState() {
    stateofonlyHome = _homesState();
    return stateofonlyHome;
  }
}

class _homesState extends State<homes> {
  bool isHide = false;
  bool noChildren = false;
  bool assigned = false;
  List<Widget> assignedList = [];
  bool parent = true;


  @override
  void initState() {
    print(DateTime.now());
    setState(() {
      noChildren = stateofHomeScreen.widget.childData.keys.isEmpty;
      parent = widget.data['type'] == 'parent';
    });
    if(!noChildren) {
      getEnquireData();
    }
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
    print("enquiry ${response.statusCode}");
    print(response.body);
    if(response.statusCode == 200){
      Map aai = jsonDecode(response.body);
      List athi = aai['enquiry'];
      for(var i in athi){
        Map aa = i;
        if(aa['status'] == "assigned"){
          var a = assignedCard(data: aa);
          setState(() {
            isHide = false;
            assigned = true;
            assignedList.add(a);
          });
        }
        else{
          setState(() {
            isHide = false;
          });
        }

      }
    }
    else if(response.statusCode == 201){
      setState(() {
        isHide = false;
      });
    }
  }







  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !noChildren,
          child: Padding(
            padding: mainPadding,
            child: Column(
              children: [
                (widget.data['type'] == 'parent')?dashboard():
                studentDashboard(studentData: stateofHomeScreen.widget.childData.values.toList()[0]),
                Container(
                  height: 120.0,
                  child: GestureDetector(
                    onTap: (){
                      if(parent) {
                        navScreen(raiseEnquire(), context, false);
                      }
                      else{
                        navScreen(raiseEnquire(oneChild: stateofHomeScreen.widget.childData.values.toList()[0],), context, false);
                      }
                    },
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

                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset("Assets/findtutor.png",height: 200),
                                  SizedBox(width: 10.0,),
                                  Expanded(child: mainTextFAQS("Find a Tutor!!", Colors.white, 20.0, FontWeight.bold,1)),
                                  // IconButton(onPressed: (){
                                  //
                                  //   navScreen(raiseEnquire(), context, false);
                                  // }, icon:Icon(Iconsax.arrow_circle_right,color: Colors.white,))
                                ],
                              ),

                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ),

                Visibility(
                  visible: assigned,
                  child: Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mainTextFAQS("Assigned Request", textColor, 15.0, FontWeight.bold, 1),
                        SizedBox(height: 10.0,),
                        Column(
                          children: assignedList,
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),

        customNotFound(noChildren, "you haven't add a child", "Assets/nochild.png", context,
        TextButton(
            onPressed: (){
          navScreen(addChildren(), context, false);
        }, child: mainText("Add Children", secColor, 10.0, FontWeight.bold, 1))),
        loaderss(isHide, "Please Wait", true, context)
      ],
    );
  }
}

class assignedCard extends StatefulWidget {
  Map data;
  assignedCard({Key? key,required this.data}) : super(key: key);

  @override
  State<assignedCard> createState() => _assignedCardState();
}

class _assignedCardState extends State<assignedCard> {

  Map childData = {};
  bool pending = true;
  String subjects = "";

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
      subjects = subs.join(" ,");
    });
    if(widget.data['status'] == "assigned"){
      setState(() {
        pending = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      margin: EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 5.0,
        color: greenColor,
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
                  backgroundColor: (pending)?oneCardCircleColor:lightGrenn,
                  radius: 60.0,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                    height: 200.0,
                    child: Image.asset("Assets/tutor.png",height: 200.0,)),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      onlymainText("Tutor Assigned for", Colors.white, 10.0, FontWeight.normal, 1),
                      mainTextFAQS(childData['name'], Colors.white, 20.0, FontWeight.bold, 1),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: custombtnsss("VIEW", () {
                    navScreen(assignedTutor(enquireData: widget.data,), context, false);}, secColor, Colors.white, 20.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}




