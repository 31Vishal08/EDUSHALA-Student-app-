import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Usefull/Backgrounds.dart';
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




class chat extends StatefulWidget {
  Map data;
  chat({Key? key,required this.data}) : super(key: key);

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isHide = false;
  List<Widget> sendButton = [];
  String msg = "";
  int _sendIndex = 0;
  bool _showSend = false;
  final fieldText = TextEditingController();


  final ScrollController _scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();


  String chatID = "";

  String id_one = "";
  String id_two = "";

  List<Widget> allChats = [];
  List<String> chatIds = [];

  bool noChats = false;
  String oneChatid = "";
  Map chatDatas = {};

  @override
  void initState() {
    getChatId();
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Display Notification, send null to not display, send notification to display
      print("get data");
      getChatId();
      // event.complete(event.notification);
    });
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
      chatID = "$p&$q";
    });
    print(chatID);

    http.Response response = await http.post(Uri.parse(getChatByChatId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id': chatID,
      }),
    );
    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      Map cd = jsonDecode(response.body);
      setState(() {
        chatDatas = cd['chats'][0];
      });
      makeChats(chatDatas);
    }
    else{
      setState(() {
        noChats = true;
      });
    }



    // List a = chatData.keys.toList()..sort();
    //
    // print(chatData);
    // // for(var x in chatData.keys) {
    // for (var x in a) {
    //   print("batman $x");
    //   Future.delayed(Duration(seconds: 1), () {
    //     scroolDown();
    //   });
    //   var sender = x.toString().split("&")[1].toString();
    //   String mainMsg = chatData[x]['msg'];
    //   var item = chatbox(id: sender, msg: mainMsg);
    //   if (!chatIds.contains(x)) {
    //     setState(() {
    //       allChats.add(item);
    //       chatIds.add(x);
    //     });
    //   }
    // }

  }

  makeChats(Map cd){
    setState(() {
      print(chatDatas);
      allChats = [];
    });
    List fdc = jsonDecode(cd['messages'].toString());
    oneChatid = cd['id'];
    for(var i in fdc){
      var a = chatbox(id: i['id'], msg: i['msg']);
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
                child: Row(
                  children: [
                    Flexible(
                        child: TextFormField(
                          controller: fieldText,
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                              color: textLight,
                              fontSize: 13.0,
                              fontFamily: 'mon'
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Message...",
                            hintStyle: TextStyle(
                              color: secColor,
                              fontFamily: 'mon',
                              fontSize: 13.0,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'mon',
                              fontSize: 13.0,
                            ),
                            errorStyle: TextStyle(
                              color: errorColor,
                              fontFamily: 'mon',
                              fontSize: 12.0,
                            ),


                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(width: 0.0,color: Colors.white)
                            ),
                          ),
                          onChanged: (text) {
                            msg = text;
                            if (text.isNotEmpty) {
                              setState(() {
                                _sendIndex = 1;
                                _showSend = true;
                              });
                            } else {
                              setState(() {
                                _sendIndex = 0;
                                _showSend = false;
                              });
                            }
                          },
                        )
                    ),
                    SizedBox(width: 2.0,),
                    Visibility(
                      visible: msg.isNotEmpty,
                      child: FloatingActionButton(onPressed: (){
                        Send();
                      },
                        backgroundColor:secColor,
                        child: Icon(Iconsax.send_1,color: Colors.white,),),
                    )
                  ],
                ),
              ),
            ),

            Container(
                alignment: Alignment.center,
                child: customNotFound(noChats, "Start Conversation", "Assets/signup.png", context,
                    Column())),
            loaderss(isHide, "Please Wait", true, context)

          ],
        ),
      ),
    );
  }
  Send() async {
    print(widget.data['player_id']);
    if(noChats) {
      setState(() {
        noChats = false;
      });
      List allsendchats = [];
      Map aa = {
        'date':DateTime.now().toString(),
        'msg':msg,
        'id':stateofHomeScreen.userCode.toString()
      };
      allsendchats.add(jsonEncode(aa));

      http.Response response = await http.post(Uri.parse(createChatUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'chat_id': chatID,
          'messages':allsendchats.toString()
        }),
      );

      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200){
        // oneChatid =
        Map aa = jsonDecode(response.body);

        var a = chatbox(id: stateofHomeScreen.userCode.toString(), msg: msg);
        setState(() {
          fieldText.clear();
          scroolDown();
          oneChatid = aa['chats'].toString();
          allChats.add(a);
          chatDatas = {
            'id':aa['chats'].toString(),
            'chat_id':chatID,
            'messages':allsendchats.toString(),
          };
        });

        postNotification(widget.data['player_id'], "A User Just Messaged you", "Someone just Messsaged you");

      }



    }
    else{
      List allSends = jsonDecode(chatDatas['messages']);
      List allsendchats = [];
      for(var i in allSends){
        allsendchats.add(jsonEncode(i));
      }
      Map aa = {
        'date':DateTime.now().toString(),
        'msg':msg,
        'id':stateofHomeScreen.userCode.toString()
      };
      allsendchats.add(jsonEncode(aa));

      http.Response response = await http.post(Uri.parse(updateChatUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'id': oneChatid,
          'messages':allsendchats.toString()
        }),
      );
      print(response.statusCode);
      print(response.body);
      chatDatas['messages'] = allsendchats.toString();
      makeChats(chatDatas);
      fieldText.clear();
      scroolDown();
      postNotification(widget.data['player_id'], "A User Just Messaged you", "Someone just Messsaged you");


    }
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
  chatbox({Key? key, required this.id, required this.msg}) : super(key: key);

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
    if (x == widget.id) {
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
        mainAxisAlignment: alignment,
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
                  maxWidth: MediaQuery.of(context).size.width * 0.68),
              color: transparent_overlay,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(topleft),
                    topRight: Radius.circular(topright),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),

                  ),
                ),
                color: boxColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: mainTextFAQS(
                      widget.msg, textColor, 15.0, FontWeight.normal, 100),
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
