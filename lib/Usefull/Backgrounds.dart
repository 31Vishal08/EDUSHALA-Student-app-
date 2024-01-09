import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


Widget bgcircles(BuildContext context,Color c){
  return Stack(
    clipBehavior: Clip.hardEdge, children: [
    Container(
      // margin: EdgeInsets.only(),

      child:
      Transform.translate(
        offset: Offset(
          -70.0,
          -120.0,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 60.0,
        ),
      ),
    ),
    Container(
      // margin: EdgeInsets.only(),
      alignment: Alignment.center,
      child:
      Transform.translate(
        offset: Offset(
          100.0,
          -10.0,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 70.0,
        ),
      ),
    ),
    Container(
      // margin: EdgeInsets.only(),
      alignment: Alignment.bottomCenter,
      child:
      Transform.translate(
        offset: Offset(
          0,
          200,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 130.0,
        ),
      ),
    ),

  ],
  );
}

Widget newbgcircles(BuildContext context,Color c){
  return Stack(
    clipBehavior: Clip.hardEdge, children: [
    Container(
      // margin: EdgeInsets.only(),

      child:
      Transform.translate(
        offset: Offset(
          -70.0,
          -120.0,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 60.0,
        ),
      ),
    ),
    Container(
      // margin: EdgeInsets.only(),
      alignment: Alignment.center,
      child:
      Transform.translate(
        offset: Offset(
          100.0,
          -10.0,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 70.0,
        ),
      ),
    ),
    Container(
      // margin: EdgeInsets.only(),
      alignment: Alignment.bottomCenter,
      child:
      Transform.translate(
        offset: Offset(
          0,
          200,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 70.0,
        ),
      ),
    ),

  ],
  );
}

