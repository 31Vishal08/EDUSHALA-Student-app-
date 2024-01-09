import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Class/OneClass.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';


import '../Usefull/Functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;

import '../Usefull/colors.dart';









class oneholidayRequest extends StatefulWidget {
  Map classData;
  oneholidayRequest({Key? key,required this.classData}) : super(key: key);

  @override
  State<oneholidayRequest> createState() => _oneholidayRequestState();
}

class _oneholidayRequestState extends State<oneholidayRequest> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  String msg = "";
  bool isHide= false;

  final formKey = GlobalKey<FormState>();

  String start_date = "";
  DateTime startDate = DateTime.now();

  @override
  void initState() {

  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left_2,color: textLight,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            // circles(context),
            bgcircles(context, secColor),
            Blur(context, 100),
            SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainText("Request Holiday", textLight,20.0, FontWeight.bold, 1),
                      SizedBox(height: 10.0,),
                      TextFormField(
                        style: TextStyle(

                          fontFamily: 'mons',
                          fontSize: 15.0,
                          color:textColor,
                        ),
                        keyboardType: TextInputType.text,
                        maxLength: 512,
                        minLines: 1,
                        maxLines: 10,

                        decoration: InputDecoration(

                          filled: true,
                          fillColor: lightWhite,
                          hintText: "Enter Reason",
                          // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
                          hintStyle: TextStyle(
                              fontFamily: 'mons',
                              color:Colors.grey
                          ),
                          labelStyle: TextStyle(
                              fontFamily: 'mons',
                              color:secColor
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

                        validator: (value){
                          if(value!.isEmpty){
                            return("Please Enter a message");
                          }
                        },
                        onChanged: (text){
                          msg = text;
                        },

                      ),

                      SizedBox(height: 20.0,),

                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: start_date),
                        style: TextStyle(
                          fontFamily: 'mons',
                          fontSize: 15.0,
                          color:textColor,
                        ),
                        keyboardType: TextInputType.text,
                        maxLength: 20,

                        decoration: InputDecoration(

                          counterText: "",
                          filled: true,
                          fillColor: lightWhite,
                          hintText: "Holiday Date",
                          labelText: "Holiday Date",
                          suffixIcon: Icon(Iconsax.calendar,color: mainColor,),
                          // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
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

                        validator: (value){
                          if(value!.isEmpty){
                            return("Please Select a Date");
                          }
                          else{
                            return null;
                          }
                        },
                        onChanged: (text){
                          start_date = text;
                        },
                        onTap: (){
                          startDatePicker();
                        },

                      ),


                      SizedBox(height: 30.0,),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        child: newiconbtnsss("Request Holiday", () {
                          if(formKey.currentState!.validate()){
                            requestHoliday();
                          }
                        }, secColor, Colors.white, Iconsax.send_1, 10.0),
                      ),
                      SizedBox(height: 30.0,),



                    ],
                  ),
                )
            ),
            loaderss(isHide, "Please Wait", true, context)
          ],
        ),
      ),
    );
  }

  requestHoliday() async{
    setState(() {
      isHide = true;
    });
    http.Response response = await http.post(Uri.parse(createHolidayUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'tutor': widget.classData['tutor'],
        'child':widget.classData['child'],
        'parent':widget.classData['parent'],
        'date':startDate.toString(),
        'assigned':widget.classData['id'],
        'reason':msg,
        'status':'pending',
        'request':'parent',
        'cc':"0",
      }),
    );

    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      setState(() {
        isHide = false;
      });
      stateofOneClass.getHoliday();
      toaster(context, "Holiday Request Submitted Successfully");
    }
    else{
      setState(() {
        isHide = false;
      });
    }
  }


  startDatePicker(){

    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 60)),
    ).then((date) {
      if (date != null) {
        print(date);
        String formattedDob = DateFormat('dd-MM-yyyy').format(date);
        setState(() {
          startDate = date;
          start_date = formattedDob;
        });
      }
    });

    // DatePicker.showDatePicker(context,
    //     showTitleActions: true,
    //     minTime: DateTime.now().add(Duration(days: 1)),
    //     maxTime: DateTime.now().add(Duration(days: 60)),
    //     currentTime: DateTime.now().add(Duration(days: 1)),
    //     onChanged: (date){
    //       if(date != null){
    //         print(date);
    //       }
    //     },
    //     onConfirm: (date){
    //       if(date != null){
    //         String formattedDob = DateFormat('dd-MM-yyyy').format(date);
    //         setState(() {
    //           startDate = date;
    //           start_date = formattedDob;
    //         });
    //       }
    //     },
    //     // theme: DatePickerTheme(
    //     //   itemStyle: TextStyle(
    //     //       color: textLight,
    //     //       fontFamily: 'mons',
    //     //       fontSize:17.0
    //     //   ),
    //     //   doneStyle: TextStyle(
    //     //     color: mainColor,
    //     //     fontFamily: 'mons',
    //     //     fontSize: 20.0,
    //     //   ),
    //     //   cancelStyle: TextStyle(
    //     //     color: textColor,
    //     //     fontFamily: 'mons',
    //     //     fontSize: 20.0,
    //     //   ),
    //     // )
    // );
  }



}





