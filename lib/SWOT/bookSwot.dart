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
import 'package:student/Usefull/Dialogs.dart';

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


late _bookSwotState stateofbookSwot;
class bookSwot extends StatefulWidget {
  Map oneChild;
  Map classData;
  Map tutorData;
  bookSwot({Key? key,this.oneChild = const {},this.classData = const {},this.tutorData = const{}}) : super(key: key);


  @override
  State<bookSwot> createState() {
    stateofbookSwot = _bookSwotState();
    return stateofbookSwot;
  }
}

class _bookSwotState extends State<bookSwot> {
  bool isHide = false;
  final formKey = GlobalKey<FormState>();
  String child = "";

  Widget cardItem = Column();
  List<Widget> allChilds = [];
  Map childData = {};



  String tution_time = "";
  Time t_time = Time(hour: 11, minute: 00);



  String start_date = "";
  DateTime startDate = DateTime.now();


  FirebaseAuth _auth = FirebaseAuth.instance;




  @override
  void initState() {
    getChildrens();
    // cardItemFiller();
    updateChildren();
  }

  updateChildren() async{

    if(widget.oneChild.keys.length > 0){
      setState(() {
        childData = widget.oneChild;
        cardItem = Row(
          children: [
            Avatars(widget.oneChild['photo_url'], 0, "", 30.0),
            SizedBox(width: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainTextFAQS(widget.oneChild['name'], Colors.white, 25.0,FontWeight.bold, 1),
                mainTextFAQS(widget.oneChild['gender'], lightWhite, 15.0,FontWeight.normal, 1),
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
          mainTextFAQS("Book SWOT for", Colors.white, 15.0,FontWeight.bold, 1),
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
              cardItem = Row(
                children: [
                  Avatars(i['photo'], 0, "", 30.0),
                  SizedBox(width: 20.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainTextFAQS(i['name'], Colors.white, 25.0,FontWeight.bold, 1),
                      mainTextFAQS(i['gender'], lightWhite, 15.0,FontWeight.normal, 1),
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
                    title: mainText("Book SWOT",bgColor, 15.0, FontWeight.normal, 1),
                    appBarColor: oneCardColor,
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
                                    Image.asset('Assets/SWOT/swot2.png',width: MediaQuery.of(context).size.width * 0.70,),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(height: 5.0,),
                                mainText("BOOK",bgColor, 10.0, FontWeight.normal, 1),
                                mainText("SWOT",bgColor, 25.0, FontWeight.bold, 1),
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
                              onlymainText("Book SWOT for:", Colors.grey, 11.0, FontWeight.normal, 1),
                              GestureDetector(
                                onTap:(){
                                  if(stateofonlyHome.parent) {
                                    findChildren();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  height: 100.0,
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
                                              backgroundColor:mainColor,
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



                              SizedBox(height: 20.0,),
                              mainTextFAQS("  Tutor", Colors.grey, 20.0, FontWeight.bold, 1),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 0.0,vertical: 00.0),
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
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
                                        child: Column(
                                          children: [

                                            Row(
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
                                                          Expanded(child: mainTextFAQS(widget.tutorData['name'], Colors.white, 25.0, FontWeight.bold, 1)),
                                                        ],
                                                      ),

                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Icon(Iconsax.book_1,color: Colors.white,size: 20.0,),
                                                          Expanded(child: mainTextFAQS(widget.tutorData['qualification'].toString(), Colors.white, 10.0, FontWeight.bold, 2)),
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


                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 70.0,
                                margin: EdgeInsets.symmetric(horizontal: 00.0,vertical: 10.0),
                                child: custombtnsss("BOOK SWOT",(){
                                  dialogs(context, "BOOK", "Are you sure you want to book SWOT", "YES", "NO", () {
                                    Navigator.of(context).pop(false);
                                    bookSwot();
                                  });
                                },greenColor,Colors.white,10),
                              ),


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


  bookSwot() async{
    setState(() {
      isHide = true;
    });
    http.Response response = await http.post(Uri.parse(createSwotUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'child':childData['id'],
        'parent':stateofHomeScreen.widget.data['user_id'],
        'tutor':widget.tutorData['tutor_id'],
        'status':'pending',
        'analysis':'',
      }),
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      toaster(context, "SWOT booked Successfully");
      setState(() {
        isHide = false;
      });
    }
    else{
      setState(() {
        isHide = false;
      });
    }

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



}




