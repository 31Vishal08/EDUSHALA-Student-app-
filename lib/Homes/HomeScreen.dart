import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Homes/Children.dart';
import 'package:student/Homes/Classes.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/Homes/UserProfile.dart';
import 'package:student/Menu/Menu.dart';
import 'package:student/Menu/NavDrawer.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:intl/intl.dart';






final GlobalKey<ScaffoldState> _key = GlobalKey();

late _homeScreenState stateofHomeScreen;

class homeScreen extends StatefulWidget {
  Map data;
  Map subjectData;
  Map gradesData;
  Map childData;
  homeScreen({Key? key,required this.data,
    required this.subjectData,required this.gradesData,required this.childData}) : super(key: key);

  @override
  State<homeScreen> createState() {
    stateofHomeScreen = _homeScreenState();
    return stateofHomeScreen;
  }
}

class _homeScreenState extends State<homeScreen> {
  bool isHide = false;
  int _index = 0;
  List bottomItems = [];
  int userCode = 0;
  Color bg = bgColor;

  List<CustomNavigationBarItem> bottomsss = [];
  Widget heads = Column();




  @override
  void initState() {
    getdd();
    print("hello ${widget.data}");
    setState(() {
      userCode = int.parse(widget.data['user_id']);

    });
    makeBottoms();

  }

  getdd() async{
    await OneSignal.shared.setAppId(oneSignalID);
    await OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {
      print("accepted");
    });
    OneSignal.shared.setSubscriptionObserver((changes) {
      print("hello");
      print(changes);
    });
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    String device = osUserID.toString();
    print('device');
    print(device);
  }

  makeBottoms() {
    if(widget.data['type'] == "parent") {
      setState(() {
        bottomsss = [
          CustomNavigationBarItem(icon: Icon(Iconsax.home),
            title: onlymainText("Home", Colors.grey, 7.0, FontWeight.normal, 1),
          ),
          CustomNavigationBarItem(icon: Icon(Iconsax.grammerly),
            title: onlymainText(
                "Children", Colors.grey, 7.0, FontWeight.normal, 1),
          ),
          CustomNavigationBarItem(icon: Icon(Iconsax.teacher),
            title: onlymainText(
                "Classes", Colors.grey, 7.0, FontWeight.normal, 1),
          ),
          CustomNavigationBarItem(icon: Icon(Iconsax.notification),
            title: onlymainText(
                "Notification", Colors.grey, 7.0, FontWeight.normal, 1),
          ),
          CustomNavigationBarItem(icon: Icon(Iconsax.user),
            title: onlymainText(
                "Profile", Colors.grey, 7.0, FontWeight.normal, 1),

          ),
        ];
        bottomItems = [
          homes(data: widget.data),
          children(data: widget.data),
          classes(data: widget.data),
          Column(),
          userProfile(data: widget.data),
        ];
      });
    }
    else{
      setState(() {
        bottomsss = [
          CustomNavigationBarItem(icon: Icon(Iconsax.home),
            title: onlymainText("Home", Colors.grey, 7.0, FontWeight.normal, 1),
          ),
          CustomNavigationBarItem(icon: Icon(Iconsax.teacher),
            title: onlymainText(
                "Classes", Colors.grey, 7.0, FontWeight.normal, 1),
          ),
          CustomNavigationBarItem(icon: Icon(Iconsax.notification),
            title: onlymainText(
                "Notification", Colors.grey, 7.0, FontWeight.normal, 1),
          ),
          CustomNavigationBarItem(icon: Icon(Iconsax.user),
            title: onlymainText(
                "Profile", Colors.grey, 7.0, FontWeight.normal, 1),

          ),
        ];
        bottomItems = [
          homes(data: widget.data),
          classes(data: widget.data),
          Column(),
          userProfile(data: widget.data),
        ];
      });
    }
  }






  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        titleTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 15.0, color: textColor),
        contentTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 13.0, color: Colors.grey),
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: new Text('Close App'),
        content: new Text('Do You Want to Close the App'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: new Text(
              'Yes',
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
        ],
      ),
    )) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            key: _key,
            backgroundColor: bgColor,
            drawer: navigationDrawer(allData: widget.data,),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(00.0),
              child: CustomNavigationBar(
                borderRadius: Radius.circular(10.0),
                elevation: 0.0,
                currentIndex: _index,
                backgroundColor: Colors.transparent,
                unSelectedColor: Colors.grey,
                selectedColor: secColor,
                iconSize: 25.0,
                // iconSize: 20.0,
                onTap: (i){
                  setState(() {
                    _index = i;
                    if(_index == 4){
                      bg = oneCardColor;
                    }
                    else{
                      bg = bgColor;
                    }
                  });
                },
                items: bottomsss
              ),
            ),
            // drawer: navigationDrawer(allData: widget.data),

            body: Stack(
              children:[
                newbgcircles(context, secColor),
                Blur(context, 100),
                DraggableHome(
                    headerExpandedHeight: 0.40,
                    stretchMaxHeight: 0.45,
                    leading: Row(
                      children: [
                        SizedBox(width: 10.0,
                        ),
                        IconButton(onPressed: (){
                          // navScreen(menu(),context,false);
                          _key.currentState!.openDrawer();
                        }, icon: Image.asset('Assets/nav.png',color: Colors.white,width: 20.0,))
                      ],
                    ),
                    actions: [
                      Row(
                        children: [
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: (){

                              },
                              icon: Avatars(widget.data['photo_url'], 0, "", 20.0)),
                          SizedBox(width: 10.0,),
                        ],
                      ),
                    ],
                    alwaysShowLeadingAndAction: true,
                    title:Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 3.0,),
                              onlymainText("✋🏾 ", Colors.grey, 20.0, FontWeight.bold, 1),
                              onlymainText("Hello ", lightWhite, 18.0, FontWeight.normal, 1),
                              mainTextFAQS(widget.data['name'], Colors.white, 20.0, FontWeight.bold, 1),
                              // Expanded(child: mainText(widget.data['name'], mainColor, 20.0, FontWeight.bold, 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    appBarColor: secColor,
                    headerWidget: Container(
                      color: secColor,
                      child: Stack(
                        children: [
                          bgcircles(context, bgColor),
                          Blur(context, 80),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10.0,),
                                  mainTextFAQS("Hello", lightWhite, 10.0, FontWeight.bold, 1),
                                  mainTextFAQS(widget.data['name'], Colors.white, 30.0, FontWeight.bold, 1),
                                  SizedBox(height: 10.0,),
                                  heads
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),



                    body:[
                        bottomItems.elementAt(_index)
                        ]
                ),
                ],
    )
        ),
      ),
    );
  }
}
