import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/MeetWeb/MeetWeb.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import '../Homes/HomeScreen.dart';
import '../Usefull/Functions.dart';
import '../Usefull/colors.dart';
import 'package:iconsax/iconsax.dart';
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

String meetLink = "";

late _PTMsState stateofPTM;
class PTMs extends StatefulWidget {
  Map data;
  Map classData;
  PTMs({Key? key,required this.data,required this.classData}) : super(key: key);

  @override
  State<PTMs> createState() {
    stateofPTM = _PTMsState();
    return stateofPTM;
  }
}

class _PTMsState extends State<PTMs> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isHide = false;
  List<Widget> sendButton = [];
  String msg = "";
  int _sendIndex = 0;
  bool _showSend = false;
  final fieldText = TextEditingController();


  final ScrollController _scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();


  String ptmID = "";

  String id_one = "";
  String id_two = "";

  List<Widget> allChats = [];
  List<String> chatIds = [];

  bool noChats = false;
  String oneChatid = "";
  Map chatDatas = {};

  String meetID = "";

  @override
  void initState() {
    getChatId();

  }

  getChatId() async {
    var x = widget.data['tutor_id'].toString();
    var userId = stateofHomeScreen.userCode.toString();
    List l = [x, userId];
    l.sort();
    var p = l[0];
    var q = l[1];
    id_one = p;
    id_two = q;
    setState(() {
      ptmID = "$p&$q";
      meetID = "https://meet.tdpvista.com/join/" + widget.classData['id'] +
          widget.classData['child'] +
          widget.classData['tutor'];
      meetLink = meetID;
    });
    print(ptmID);

    http.Response response = await http.post(Uri.parse(getPTMbyMTPid),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id': ptmID,
      }),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      Map cd = jsonDecode(response.body);
      setState(() {
        chatDatas = cd['ptms'][0];
      });
      makeChats(chatDatas);
    }
    else {
      setState(() {
        noChats = true;
      });
    }
  }

  makeChats(Map cd){
    setState(() {
      print(chatDatas);
      allChats = [];
    });
    List fdc = jsonDecode(cd['messages'].toString());
    oneChatid = cd['id'];
    for(var i in fdc){
      var a = chatbox(id: i['id'], msg: i['msg'],date: DateTime.parse(i['date']),time: i['time'],);
      setState(() {
        allChats.add(a);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 100,
          elevation: 0.0,
          leading: Row(
            children: [
              IconButton(
                icon: Icon(Iconsax.arrow_left_2,color: textLight,),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              Avatars(widget.data['photo_url'], 0, "", 18.0),
            ],
          ),
          title: mainText(widget.data['name'], textLight, 15.0, FontWeight.normal,1),
        ),
        body: Stack(

          children: [
            bgcircles(context, secColor),
            Blur(context, 100),
            Container(
              decoration: BoxDecoration(),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.only(bottom: 70.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                child: Column(
                  children: allChats,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
                child:Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  child:mainText("Upcoming PTM's", textColor, 15.0, FontWeight.bold, 1),
                ),

                // child: Row(
                //   children: [
                //     Flexible(
                //         child: TextFormField(
                //           controller: fieldText,
                //           minLines: 1,
                //           maxLines: 5,
                //           keyboardType: TextInputType.multiline,
                //           style: TextStyle(
                //               color: textLight,
                //               fontSize: 13.0,
                //               fontFamily: 'mon'
                //           ),
                //           decoration: InputDecoration(
                //             fillColor: Colors.white,
                //             filled: true,
                //             hintText: "Message...",
                //             hintStyle: TextStyle(
                //               color: secColor,
                //               fontFamily: 'mon',
                //               fontSize: 13.0,
                //             ),
                //             labelStyle: TextStyle(
                //               color: Colors.white,
                //               fontFamily: 'mon',
                //               fontSize: 13.0,
                //             ),
                //             errorStyle: TextStyle(
                //               color: errorColor,
                //               fontFamily: 'mon',
                //               fontSize: 12.0,
                //             ),
                //
                //
                //             border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(30.0),
                //                 borderSide: BorderSide(width: 0.0,color: Colors.white)
                //             ),
                //           ),
                //           onChanged: (text) {
                //             msg = text;
                //             if (text.isNotEmpty) {
                //               setState(() {
                //                 _sendIndex = 1;
                //                 _showSend = true;
                //               });
                //             } else {
                //               setState(() {
                //                 _sendIndex = 0;
                //                 _showSend = false;
                //               });
                //             }
                //           },
                //         )
                //     ),
                //     SizedBox(width: 2.0,),
                //     Visibility(
                //       visible: msg.isNotEmpty,
                //       child: FloatingActionButton(onPressed: (){
                //         Send();
                //       },
                //         backgroundColor:secColor,
                //         child: Icon(Iconsax.send_1,color: Colors.white,),),
                //     )
                //   ],
                // ),
              ),
            ),

            Container(
                alignment: Alignment.center,
                child: customNotFound(noChats, "Upcoming PTMS", "Assets/VS/twovs.png", context,
                    Column())),
            loaderss(isHide, "Please Wait", true, context)

          ],
        ),
      ),
    );
  }

  upDateChats(){

  }

  scroolDown() async {
    await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut);
  }

}


class chatbox extends StatefulWidget {
  String id;
  String msg;
  DateTime date;
  String time;
  chatbox({Key? key, required this.id, required this.msg,required this.time,required this.date}) : super(key: key);

  @override
  State<chatbox> createState() => _chatboxState();
}

class _chatboxState extends State<chatbox> {
  User? user = FirebaseAuth.instance.currentUser;
  Color boxColor = lightWhite;
  bool isUser = false;
  MainAxisAlignment alignment = MainAxisAlignment.start;
  Color textColor = textLight;
  double topleft = 0.0;
  double topright = 20.0;

  @override
  void initState() {
    var x = stateofHomeScreen.userCode.toString();
    if (x != widget.id) {
      setState(() {
        boxColor = secColor;
        textColor = Colors.white;
        isUser = true;
        alignment = MainAxisAlignment.end;
        topright = 0.0;
        topleft = 20.0;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparent_overlay,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 1.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          // Visibility(
          //     visible: isUser,
          //     child: SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.30,
          // )),

          GestureDetector(
            child: Container(
              constraints: BoxConstraints(
                  minWidth: 20,
                  maxWidth: MediaQuery.of(context).size.width * 0.90),
              color: transparent_overlay,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),

                  ),
                ),
                color: boxColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainTextFAQS( "PTM Metting", textColor, 20.0, FontWeight.bold, 100),
                      Row(
                        children: [
                          Icon(Iconsax.message,color: textColor,),
                          SizedBox(width: 10.0,),
                          Expanded(
                            child: mainTextFAQS( "${widget.msg}"
                                , textColor, 10.0, FontWeight.normal, 100),
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Icon(Iconsax.calendar,color: textColor,),
                          SizedBox(width: 10.0,),
                          mainTextFAQS( "${DateFormat("EEE dd MMM yyyy").format(widget.date)}"
                              , textColor, 10.0, FontWeight.normal, 100),

                        ],
                      ),
                      Row(
                        children: [
                          Icon(Iconsax.clock,color: textColor,),
                          SizedBox(width: 10.0,),
                          mainTextFAQS( "${widget.time}"
                              , textColor, 10.0, FontWeight.normal, 100),

                        ],
                      ),
                      SizedBox(height: 5.0,),
                      btnsss("join now", () {
                        navScreen(meetWeb(url: meetLink), context, false);
                      }, greenColor,Colors.white),


                    ],
                  ),
                ),
              ),
            ),
          ),
          // Visibility(
          //     visible: !isUser,
          //     child: SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.30,
          //     )),
        ],
      ),
    );
  }
}



