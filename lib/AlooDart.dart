
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:student/Usefull/Backgrounds.dart';

import 'Usefull/colors.dart';


class Allodart extends StatefulWidget {
  Widget bodies;
  Color bgs;

  Allodart({Key? key,required this.bodies,this.bgs = const Color(0xFFF6F8FE)}) : super(key: key);

  @override
  State<Allodart> createState() => _AllodartState();
}

class _AllodartState extends State<Allodart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: widget.bgs,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left_2,color: Colors.white,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            bgcircles(context, secColor),
            Blur(context, 100.0),
            widget.bodies
          ],
        ),
      ),
    );
  }
}
