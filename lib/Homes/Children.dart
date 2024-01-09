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
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Inquire/RaiseInquire.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';

import 'package:url_launcher/url_launcher.dart';




late _childrenState stateofChildren;



class children extends StatefulWidget {
  Map data;

  children({Key? key, required this.data}) : super(key: key);

  @override
  State<children> createState() {
    stateofChildren = _childrenState();
    return stateofChildren;
  }
}

class _childrenState extends State<children> {
  bool isHide = false;
  bool noChildren = false;
  List<Widget> allChildrens = [];




  @override
  void initState() {
    print(DateTime.now());
    getParentChildren();
    // getallChild(context);
    // getData();
  }

  getParentChildren() async{
    setState(() {
      isHide = true;
    });
    http.Response response = await http.post(Uri.parse(getChildrenUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'parent': stateofHomeScreen.userCode.toString(),
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      setState(() {
        isHide = false;
        noChildren = false;
        Map data = jsonDecode(response.body);
        List allChild = data['children'];
        for(var i in allChild){
          Map a = i;
          var cc = childCard(data: a);
          setState(() {
            allChildrens.add(cc);
          });
        }
      });
    }
    else{
      setState(() {
        isHide = false;
        noChildren = true;
      });
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
                mainTextFAQS("My Childrens", textColor, 15.0, FontWeight.bold, 1),
                SizedBox(height: 20.0,),
                Column(
                  children: allChildrens,
                ),
              ]
          ),
        ),
        Visibility(
          visible: !noChildren,
          child: Container(
            alignment: Alignment.bottomRight,
              margin: EdgeInsets.all(20.0),
              child: circularBtn(Iconsax.add_circle, () {navScreen(addChildren(), context, false); }, secColor, Colors.white, true)),
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

class childCard extends StatefulWidget {
  Map data;
  childCard({Key? key,required this.data}) : super(key: key);

  @override
  State<childCard> createState() => _childCardState();
}

class _childCardState extends State<childCard> {

  int age = 0;
  bool isEdit = true;

  @override
  void initState() {
    DateTime dob = DateTime.parse(widget.data['dob']);
    setState(() {
      age = calculateAge(dob);
    });
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mainTextFAQS(widget.data['name'], textColor, 20.0, FontWeight.bold, 1),
                        onlymainText(age.toString() + " years " + widget.data['gender'], Colors.grey, 10.0, FontWeight.normal, 1),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Icon(Iconsax.teacher,color: Colors.grey,),
                            SizedBox(width:10.0,),
                            mainText(stateofHomeScreen.widget.gradesData[widget.data['grade']]['title'] + " "+
                                stateofHomeScreen.widget.gradesData[widget.data['grade']]['board']
                                , Colors.grey, 10.0, FontWeight.bold, 1),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Iconsax.building,color: Colors.grey,),
                            SizedBox(width:10.0,),
                            mainText(widget.data['school']
                                , Colors.grey, 10.0, FontWeight.bold, 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Avatars(widget.data['photo_url'], 0, "", 40.0),

                ],
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                child: btnsss("FIND TUTORS", () { navScreen(raiseEnquire(oneChild: widget.data,),context,false);}, secColor,Colors.white),
              )

            ],
          ),
        ),
      ),
    );
  }

}



