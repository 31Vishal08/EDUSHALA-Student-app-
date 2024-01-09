import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Auth/WelcomeScreen.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Dialogs.dart';


import '../Usefull/Functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';










class menu extends StatefulWidget {
  menu({Key? key}) : super(key: key);

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {

  String sharemsg = "";
  String subject = "";
  String pp = "www.google.com";

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    sharemsg = "Edushala\n"
        "${_auth.currentUser!.uid}\n"
        "https://play.google.com/store/apps/details?id=com.edushala.student&hl=en&gl=US";
    subject = "Interested";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Iconsax.arrow_left_2,color: textLight,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            // circles(context),
            bgcircles(context, secColor),
            Blur(context, 100),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 20.0),
              child: Column(
                children: [

                  Row(
                    children: [
                      Spacer(),
                      Image.asset("Assets/logo.png",width: MediaQuery.of(context).size.width * 0.30,),
                      Spacer(),
                    ],
                  ),

                  SizedBox(height: 5.0,),
                  mainText("Edushala", secColor, 30.0, FontWeight.bold,1),
                  mainText("student", mainColor, 15.0, FontWeight.normal,1),

                  SizedBox(height: 20.0,),

                  mybtnsss("Share", () {share(); }, Iconsax.send_1),
                  mybtnsss("Rate Us", () {launch_us("https://play.google.com/store/apps/details?id=com.edushala.studentd&hl=en&gl=US");}, Iconsax.star_1),
                  mybtnsss("Refer and Earn", () { }, Iconsax.share),

                  SizedBox(height: 20.0,),


                  mybtnsss("About Us", () {  }, Iconsax.info_circle),
                  mybtnsss("My Story", () { }, Iconsax.book_1),
                  mybtnsss("Privacy Policy", () { }, Iconsax.shield),

                  SizedBox(height: 20.0,),

                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    width: MediaQuery.of(context).size.width,
                    height: 60.0,
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(3, 5, 3,5),
                        child: Row(
                          children: [
                            Icon(Iconsax.notification,color: secColor,),
                            SizedBox(width: 5.0,),
                            onlymainText(
                                "Show Notifications", Colors.blueGrey, 15.0, FontWeight.normal,1),
                            Spacer(),
                            notiswitch(),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                          foregroundColor:
                          MaterialStateProperty.all<Color>(
                              lightWhite),
                          elevation: MaterialStateProperty.all(0.0),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(lightWhite),

                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15.0),
                                  side: BorderSide(color: lightWhite)))),
                      onPressed: (){

                      },
                    ),
                  ),



                  SizedBox(height: 20.0,),


                  mybtnsss("Sign Out", () {
                    dialogs(context, "Logout", "You wanted to Logout", "Logout", "Cancel", () {
                      FirebaseAuth.instance.signOut().then((value) => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) =>
                                welcomeScreen()), (Route<dynamic> route) => false)
                      });
                    },);
                  }, Iconsax.logout,c: redColor,),


                ],
              ),
            ),
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

  launch_us(String s) async{
    await launchUrl(
        Uri.parse(s),
        mode: LaunchMode.externalApplication
    );

  }

// Future<bool> referDialog(BuildContext context) async {
//   var textColor;
//   return (await showDialog(
//     context: context,
//     builder: (context) => new AlertDialog(
//       titleTextStyle:
//       TextStyle(fontFamily: 'mons', fontSize: 15.0, color: textColor),
//       contentTextStyle:
//       TextStyle(fontFamily: 'mons', fontSize: 13.0, color: Colors.grey),
//       alignment: Alignment.center,
//       backgroundColor: bgColor,
//       shape:
//       RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//       title: new Text("Refer and Earn"),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               onlymainText("Get 500 coins for a refferal", yellove, 15.0, FontWeight.normal, 1),
//               Spacer(),
//             ],
//           ),
//           SizedBox(height: 10.0,),
//           TextFormField(
//             readOnly: true,
//             controller: TextEditingController(text: _auth.currentUser!.uid),
//             style: TextStyle(
//
//               fontFamily: 'mons',
//               fontSize: 15.0,
//               color:mainColor,
//             ),
//             keyboardType: TextInputType.text,
//             maxLength: 48,
//
//             decoration: InputDecoration(
//
//               counterText: "",
//               filled: true,
//               fillColor: bglight,
//               suffixIcon: IconButton(
//                 icon: Icon(Iconsax.copy,color: mainColor,),
//                 onPressed: () async{
//                   await Clipboard.setData(ClipboardData(text: _auth.currentUser!.uid));
//                   toaster(context,"Code Copied");
//                 },
//               ),
//               hintStyle: TextStyle(
//                   fontFamily: 'mons',
//                   color:Colors.grey
//               ),
//               labelStyle: TextStyle(
//                   fontFamily: 'mons',
//                   color:secColor
//               ),
//
//               errorStyle: TextStyle(
//                   fontFamily: 'mons',
//                   color: errorColor
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.transparent,width: 0),
//                 borderRadius: BorderRadius.circular(15.0),
//
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                     color: transparent_overlay,
//                     width: 0
//                 ),
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                     color: errorColor,
//                     width: 0
//                 ),
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//
//             ),
//           )
//         ],
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: (){
//             Share.share(sharemsg + "\nJoin and Earn 200 coins with my refferal code",
//               subject: "Earn 200 coins with my Referal Code",
//             );
//           },
//           child: new Text(
//             "Share",
//             style: TextStyle(color: mainColor, fontFamily: 'mons'),
//           ),
//         ),
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(false),
//           child: new Text(
//             "Cancel",
//             style: TextStyle(color: mainColor, fontFamily: 'mons'),
//           ),
//         ),
//       ],
//     ),
//   )) ?? false;
// }

}

class mybtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  IconData i;
  Color c;

  mybtnsss(this.title,this.callback,this.i,{this.c = Colors.blueGrey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: MediaQuery.of(context).size.width,
      height: 60.0,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 5, 3,5),
          child: Row(
            children: [
              Icon(i,color: secColor,),
              SizedBox(width: 5.0,),
              onlymainText(
                  title, c, 15.0, FontWeight.normal,1),
              Spacer(),
            ],
          ),
        ),
        style: ButtonStyle(
            foregroundColor:
            MaterialStateProperty.all<Color>(
                lightWhite),
            elevation: MaterialStateProperty.all(0.0),
            backgroundColor:
            MaterialStateProperty.all<Color>(lightWhite),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15.0),
                    side: BorderSide(color: lightWhite)))),
        onPressed: callback,
      ),
    );
  }
}



