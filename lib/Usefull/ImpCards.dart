import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/GetStarted/GetStarted.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../Usefull/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class subjectCard extends StatefulWidget {
  String title;
  Color bg;
  String img;
  subjectCard({Key? key,required this.title,required this.bg,required this.img}) : super(key: key);

  @override
  State<subjectCard> createState() => _subjectCardState();
}

class _subjectCardState extends State<subjectCard> {
  Color text = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.60,
      margin: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){
          if(widget.bg == Colors.white){
            setState(() {
              widget.bg = text;
              text = Colors.white;
            });
            stateofSubjects.setState(() {
              stateofSubjects.selectSubject.remove(widget.title);
            });
          }

          else{
            setState(() {
              text = widget.bg;
              widget.bg = Colors.white;
            });
            stateofSubjects.setState(() {
            stateofSubjects.selectSubject.add(widget.title);
            });

          }
        },

        child: Stack(
          children: [
            Container(
              child: Stack(
                children: [
                  Card(
                    color: text,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)
                    ),

                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          mainText(widget.title, widget.bg, 20.0, FontWeight.bold, 1),
                        ],
                      ),
                    ),
                  ),
                  Image.asset(widget.img,height: MediaQuery.of(context).size.width * 0.25,),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
