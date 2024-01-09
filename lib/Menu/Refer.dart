import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Chats/Chatss.dart';
import 'package:student/Class/HolidayRequest.dart';

import 'package:student/Homes/HomeScreen.dart';

import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';


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
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';



class refer extends StatefulWidget {

  refer({Key? key}) : super(key: key);

  @override
  State<refer> createState() => _referState();
}

class _referState extends State<refer> {
  bool isHide = false;

  String sharemsg = "";
  String subject = "";

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool copied = false;
  int referals = 0;


  @override
  void initState() {
    // getReferals();
    setState((){
      sharemsg = "Edushala\n"
          "${_auth.currentUser!.uid}\n"
          "https://play.google.com/store/apps/details?id=com.edushala.tutor&hl=en&gl=US";
      subject = "Interested";
    });
  }

  // getReferals() async{
  //   if(widget.data['refers'] != null){
  //     List l = widget.data['refers'];
  //     setState(() {
  //       referals = l.length;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: secColor,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Iconsax.arrow_left),
          ),
          title: mainText("Refer and Earn", bgColor, 15.0, FontWeight.normal, 1),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('Assets/welcome.png',width: MediaQuery.of(context).size.width * 0.90,),


                    SizedBox(height: 20.0,),

                    mainText("My Referal Code", textColor, 10.0, FontWeight.normal, 1),

                    Container(
                      height: 60.0,
                      child: Card(
                        elevation: 0.0,
                        color: transparent_overlay,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: secColor,width: 2.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              mainText(_auth.currentUser!.uid, secColor, 10.0, FontWeight.normal, 1),
                              Spacer(),
                              Visibility(
                                  visible: !copied,
                                  child:GestureDetector(
                                    onTap: () async{
                                      await Clipboard.setData(ClipboardData(text: _auth.currentUser!.uid));
                                      toaster(context,"Code Copied");
                                      setState(() {
                                        copied = true;
                                      });

                                    },
                                    child: Icon(Iconsax.copy,color: Colors.green,),
                                  ) ),
                              Visibility(
                                  visible: copied,
                                  child: GestureDetector(
                                    onTap: () async{

                                    },
                                    child: Icon(Iconsax.tick_circle,color: Colors.green,),
                                  ) ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0,),

                    Container(
                      height: 50.0,
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                          child: Row(
                            children: [
                              Spacer(),
                              Icon(Iconsax.share,size: 25.0,color: bgColor,),
                              SizedBox(width: 3.0,),
                              mainText(
                                  "Refer Now", bgColor, 15.0, FontWeight.normal,1),
                              Spacer()
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all<Color>(
                                secColor),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(secColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20.0),
                                    side: BorderSide(color: bgColor,
                                    )))),
                        onPressed: (){
                          share();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            loaderss(isHide,"Hold Onn", true, context),
          ],
        ),
      ),
    );
  }

  share(){
    Share.share(sharemsg,
      subject: subject,
    );
  }



}
