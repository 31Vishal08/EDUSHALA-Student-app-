import 'package:carousel_slider/carousel_slider.dart';


import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:intl/intl.dart';

// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../Usefull/colors.dart';








late _noticeState stateofNotice;
class notice extends StatefulWidget {
  notice({Key? key}) : super(key: key);

  @override
  State<notice> createState() {
    stateofNotice = _noticeState();
    return stateofNotice;
  }
}

class _noticeState extends State<notice> {
  bool isHide = false;
  List<Widget> Items = [];
  CarouselController buttonCarouselController = CarouselController();


  @override
  void initState() {
    makeCarousalItems();
  }

  makeCarousalItems(){
    setState(() {
      var a = oneMoreCard(icon: Icon(Iconsax.add), title: "Notices", sub: "upcoming notices",
            image: "Assets/VS/threevs.png", c: secColor, callback: (){});
       var b = oneMoreCard(icon: Icon(Iconsax.add), title: "One Notice", sub: "notice is this",
            image: "Assets/VS/twovs.png", c: oneCardColor, callback: (){});
       var c = oneMoreCard(icon: Icon(Iconsax.add), title: "One Notice", sub: "notice is this",
            image: "Assets/VS/fourvs.png", c: secColor, callback: (){});
       Items.add(a);
       Items.add(b);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            mainTextFAQS("Notices", textLight, 15.0, FontWeight.bold,1),
            CarouselSlider(
              items: Items,
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 2.0,
                initialPage: 0,
              ),
            ),
          ],
        ),
        loaderss(isHide, "Please White", true, context)
      ],
    );
  }

}

class oneMoreCard extends StatelessWidget {
  Icon icon;
  String title;
  String sub;
  String image;
  Color c;
  VoidCallback callback;
  oneMoreCard({Key? key,required this.icon,required this.title,
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
                          mainText(title, Colors.white, 20.0, FontWeight.bold, 1),
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











