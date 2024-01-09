import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/DummyData/dummyData.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/SWOT/bookSwot.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Usefull/Buttons.dart';
import 'package:flutter/services.dart';
// import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;













late _swotSlidersState stateofSwotSliders;

class swotSliders extends StatefulWidget {
  Map classData;
  Map TutorData;
  swotSliders({Key? key,this.classData = const {},this.TutorData = const{}}) : super(key: key);

  @override
  State<swotSliders> createState() {
    stateofSwotSliders = _swotSlidersState();
    return stateofSwotSliders;
  }
}

class _swotSlidersState extends State<swotSliders> with SingleTickerProviderStateMixin{
  bool isHide = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  CardSwiperController _cardSwiperController = CardSwiperController();
  bool showswot = false;


  List swotDataList = [];
  @override
  void initState() {
    fillSwotData();
    swipeSwot();
  }

  fillSwotData() {
    setState(() {
      swotDataList = [
        swotData("Assets/SWOT/swot2.png", "SWOT", "What is SWOT??"),
        swotData("Assets/SWOT/swot3.png", "About", "It is a kuch toh hai,\n mujhe ni pta kaise pta hoga"
            "\n milestone mein yeh ni likha hai"),
        swotData("Assets/SWOT/swot4.png", "Subject Area of Focus", "Something like subject area etc etc\n"
            "zada ni pta hai hume bss yhi hai jo hai smghe"),
        // swotData("Assets/SWOT/swot1.png", "SWOT", "What is SWOT"),
      ];
    });
  }

  Map swotData(String img, String title, String desc){
    return {
      'img':img,
      'title':title,
      'desc':desc,
    };
  }

  swipeSwot(){
    bool left = true;
    int a = 0;
    Timer.periodic(Duration(seconds: 2), (timer) {
      if(left) {
        _cardSwiperController.swipeLeft();
        left = false;
      }
      else{
        _cardSwiperController.swipeRight();
        left = true;
      }
      if(a < 1) {
        a += 1;
      }
      else{
        setState(() {
          showswot = true;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
                children: [
                  bgcircles(context, secColor),
                  // Blur(context, 80),
                  SafeArea(
                    child: CardSwiper(
                      controller: _cardSwiperController,
                      cardsCount: swotDataList.length,
                      cardBuilder: (ctx,index,x,y){
                      return swotCard(data: swotDataList[index]);
                    },
                    onSwipe: (i,ii,d){
                        print(d.name);
                        if(d.name == "top"){
                          print("Tops");

                        }
                        return true;
                    },
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: superTransparent,
                  ),
                  Visibility(
                    visible: showswot,
                    child: Container(
                      alignment: Alignment.bottomCenter,

                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50.0,
                          margin: EdgeInsets.symmetric(horizontal: 50.0,vertical: 50.0),
                          child: custombtnsss("BOOK SWOT", () {
                            if(stateofonlyHome.parent) {
                              if(widget.classData.keys.isNotEmpty) {
                                navScreen(bookSwot(
                                  oneChild: stateofHomeScreen.widget
                                      .childData[widget.classData['child']],classData: widget.classData,
                                  tutorData: widget.TutorData,
                                ),
                                    context, false);
                              }
                              else{
                                navScreen(bookSwot(),
                                    context, false);
                              }
                            }
                            else{
                              if(widget.classData.keys.isNotEmpty) {
                                navScreen(bookSwot(
                                  oneChild:stateofHomeScreen.widget.childData.values.toList()[0],classData: widget.classData,
                                  tutorData: widget.TutorData,
                                ),
                                    context, false);
                              }
                              else{
                                navScreen(bookSwot(oneChild: stateofHomeScreen.widget.childData.values.toList()[0],), context, false);

                              }
                            }
                          }, oneCardColor, Colors.white,10))
                    ),
                  ),
                  loaderss(isHide, "Please Wait", true, context)

                ],
              ),
      ),
    );
  }


}

class swotCard extends StatefulWidget {
  Map data;
  swotCard({Key? key,required this.data}) : super(key: key);

  @override
  State<swotCard> createState() => _swotCardState();
}

class _swotCardState extends State<swotCard> {



  @override
  void initState() {

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 00.0,vertical: 00.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.white,
        child: Stack(
          children: [
            bgcircles(context, oneCardColor),
            Blur(context, 100.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Image.asset(widget.data['img'],width: 250.0,),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  mainText(widget.data['title'], textColor, 40.0, FontWeight.bold, 1),
                  mainText(widget.data['desc'], textColor, 10.0, FontWeight.normal, 5),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}










