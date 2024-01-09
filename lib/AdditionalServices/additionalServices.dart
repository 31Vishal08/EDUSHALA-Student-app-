import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/Inquire/Assignedtutor.dart';
import 'package:student/Inquire/RaiseInquire.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Dialogs.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:introduction_screen/introduction_screen.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../Usefull/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';






late _additionalServicesState stateofAdditionalServices;

class additionalServices extends StatefulWidget {
  additionalServices({Key? key,}) : super(key: key);

  @override
  State<additionalServices> createState() {
    stateofAdditionalServices = _additionalServicesState();
    return stateofAdditionalServices;
  }
}

class _additionalServicesState extends State<additionalServices> {
  bool isHide = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Widget> allProduct = [];
  bool notFound = false;

  final formKey = GlobalKey<FormState>();



  @override
  void initState() {
    // oneSignals();
    putData();
  }

  putData() async{
    var a = productCard(title: "Edushala Encyclopedia", desc: "very badhiya book, very badhiya book", img: "Assets/IP/ip2.png");

    var b = productCard(title: "Edushala book", desc: "Very bashiyaa book", img: "Assets/IP/ip3.png");

    setState(() {
      allProduct.add(a);
      allProduct.add(b);
    });
  }











  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: _key,
          backgroundColor: bgColor,
          // drawer: navigationDrawer(allData: widget.data),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            // leadingWidth: 100.0,
            elevation: 0.0,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Iconsax.arrow_left_2,color: mainColor,)),

          ),
          body: Stack(
              children:[
                newbgcircles(context, secColor),
                Blur(context, 100),

                SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: mainPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainTextFAQS("Additional Products", textColor, 20.0, FontWeight.bold, 1),
                      SizedBox(height: 20.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: allProduct,
                      ),

                    ],
                  ),
                ),

                loaderss(isHide, "Please Wait", true, context),


              ]
          )
      ),
    );
  }
}

class productCard extends StatefulWidget {
  String title;
  String desc;
  String img;
  productCard({Key? key,required this.title, required this.desc, required this.img}) : super(key: key);

  @override
  State<productCard> createState() => _productCardState();
}

class _productCardState extends State<productCard> {


  @override
  void initState() {
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 0.0,
        color: lightWhite,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(widget.img,width: 100.0,),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mainTextFAQS(widget.title, textLight, 20.0,FontWeight.bold, 2),
                        onlymainText(widget.desc, Colors.grey, 10.0,FontWeight.normal, 6),

                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                margin: EdgeInsets.symmetric(horizontal: 30.0,vertical: 10.0),
                child: custombtnsss("Raise Enquire",(){},greenColor,Colors.white,10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
