
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:student/AdditionalServices/additionalServices.dart';
import 'package:student/AlooDart.dart';
import 'package:student/Homes/Children.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/UserProfile.dart';
import 'package:student/IP/invagilationProduct.dart';
import 'package:student/Inquire/MyInquire.dart';
import 'package:student/Menu/About%20Us.dart';
import 'package:student/Menu/ContactUs.dart';
import 'package:student/Menu/FAQs.dart';
import 'package:student/Menu/Refer.dart';
import 'package:student/SWOT/MySwots.dart';
import 'package:student/SWOT/OneSWOT.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Dialogs.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';




import '../Auth/WelcomeScreen.dart';
import '../Usefull/Functions.dart';







class navigationDrawer extends StatefulWidget {
  Map<dynamic,dynamic> allData;
  navigationDrawer({Key? key, required this.allData})
      : super(key: key);

  @override
  State<navigationDrawer> createState() => _navigationDrawerState();
}

class _navigationDrawerState extends State<navigationDrawer> {

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: buildMenu(allData: widget.allData,)),
          ],
        ),
      ),
    );
  }

  Widget buildHeder(BuildContext context,Map data,String img) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: bgColor
      ),
        child:Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: (){
                      navScreen(userProfile(data: widget.allData), context, false);
                    },
                    child: Avatars(img, 0, "", 30.0)),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 5.0,),
            Row(
              children: [
                mainText(data['firstName'], textLight, 20.0, FontWeight.normal, 1),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                mainText(data['phone'], textLight, 10.0, FontWeight.normal, 1),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                mainText(data['email'], textLight, 10.0, FontWeight.normal, 1),
                const Spacer(),
              ],
            ),


          ],
        )
    );
  }


}

// Future <List<String>> fetchUrl() async{
//   final response = await http.get("https://gefgkerg.com" as Uri);
//
// }

class buildMenu extends StatefulWidget {
  Map allData;
  buildMenu({Key? key,required this.allData}) : super(key: key);

  @override
  State<buildMenu> createState() => _buildMenuState();
}

class _buildMenuState extends State<buildMenu> {
  bool showmore = false;
  String sharemsg = "";
  String subject = "";
  String pp = "www.google.com";

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    sharemsg = "Edushala\n"
        "${_auth.currentUser!.uid}\n"
        "https://play.google.com/store/apps/details?id=com.edushala.tutor&hl=en&gl=US";
    subject = "Edushala";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: [
            bgcircles(context, secColor),
            Blur(context, 100),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10.0,),

                  mainTextFAQS("   History", Colors.grey, 13.0, FontWeight.normal, 1),
                  SizedBox(height: 5.0,),


                  ListTile(
                    leading: Icon(Iconsax.user,color: secColor,),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("My Details", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(Allodart(bodies: userProfile(data:stateofHomeScreen.widget.data,)), context, false);
                    },
                  ),

                  ListTile(
                    leading: Icon(Iconsax.message_question,color: secColor,),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("My Enquiries", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(myInquire(), context, false);
                    },
                  ),
                  Visibility(
                    visible: widget.allData['type'] == "parent",
                    child: ListTile(
                      leading: Icon(Iconsax.grammerly,color: secColor,),
                      iconColor: mainColor,
                      visualDensity: const VisualDensity(vertical: -3),
                      focusColor: textLight,
                      selectedTileColor: textLight,
                      selectedColor: textLight,
                      title:
                      mainTextLeft("My Children", textColor, 13.0, FontWeight.bold, 1),
                      onTap: () {
                        navScreen(Allodart(bodies: children(data: stateofHomeScreen.widget.data,)), context, false);
                      },
                    ),
                  ),

                  ListTile(
                    leading: Icon(Iconsax.receipt,color: secColor,),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("My SWOT Reports", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(mySwots(), context, false);
                    },
                  ),

                  ListTile(
                    leading: Icon(Iconsax.password_check,color: secColor,),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Invigilation Product", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(ipSliders(), context, false);
                    },
                  ),
                  
                  ListTile(
                    leading: Icon(Iconsax.bag,color: secColor,),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Additional Products", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(additionalServices(), context, false);
                    },
                  ),



                  Container(
                    margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    width:MediaQuery.of(context).size.width,
                    height: 0.2,
                    color:Colors.grey,
                  ),

                  mainTextFAQS("   Support Us", Colors.grey, 13.0, FontWeight.normal, 1),
                  SizedBox(height: 5.0,),

                  ListTile(
                    leading: Icon(Iconsax.share,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Share", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      share();
                    },
                  ),
                  ListTile(
                    leading: Icon(Iconsax.star,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Rate Us", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      launch_us
                        ("https://play.google.com/store/apps/details?id=com.edushala.studnet&hl=en&gl=US");
                    },
                  ),
                  ListTile(
                    leading: Icon(Iconsax.money_3,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Refer and Earn", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(refer(), context, false);
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    width:MediaQuery.of(context).size.width,
                    height: 0.2,
                    color:Colors.grey,
                  ),

                  mainTextFAQS("   About", Colors.grey, 13.0, FontWeight.normal, 1),
                  SizedBox(height: 5.0,),

                  ListTile(
                    leading: Icon(Iconsax.info_circle,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("About Us", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(aboutUs(), context, false);
                      // navScreen(
                      //meetWeb(url: "https://meet.tdpvista.com/join/gqw"), context, false);
                      // navScreen(meetWeb(url: "https://meet.google.com/wfs-gzyc-gqw"), context, false);
                    },
                  ),
                  ListTile(
                    leading: Icon(Iconsax.quote_down,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("FAQs", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(faqs(), context, false);
                      // navScreen(meetWeb(url: "https://meet.tdpvista.com/join/gqw"), context, false);
                      // navScreen(meetWeb(url: "https://meet.google.com/wfs-gzyc-gqw"), context, false);
                    },
                  ),
                  ListTile(
                    leading: Icon(Iconsax.call,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Contact Us", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      navScreen(contactUs(), context, false);
                    },
                  ),

                  ListTile(
                    leading: Icon(Iconsax.info_circle,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Privacy Policy", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      launch_us('https://edushalaacademy.com/privacypolicy');
                      // navScreen(
                      //meetWeb(url: "https://meet.tdpvista.com/join/gqw"), context, false);
                      // navScreen(meetWeb(url: "https://meet.google.com/wfs-gzyc-gqw"), context, false);
                    },
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    width:MediaQuery.of(context).size.width,
                    height: 0.2,
                    color:Colors.grey,
                  ),



                  ListTile(
                    leading: Icon(Iconsax.logout,color: secColor),
                    iconColor: mainColor,
                    visualDensity: const VisualDensity(vertical: -3),
                    focusColor: textLight,
                    selectedTileColor: textLight,
                    selectedColor: textLight,
                    title:
                    mainTextLeft("Logout", textColor, 13.0, FontWeight.bold, 1),
                    onTap: () {
                      confirmLogout(context);
                    },
                  ),





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

  Future<bool> confirmLogout(BuildContext context) async {
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
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: new Text("Logout"),
        content: new Text("do you wan't to logout?"),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              Navigator.of(context).pop(false);
              FirebaseAuth.instance.signOut().then((value) => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        welcomeScreen()), (Route<dynamic> route) => false)
              });
            },
            child: new Text(
              "Logout",
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              "Cancel",
              style: TextStyle(color: mainColor, fontFamily: 'mons'),
            ),
          ),
        ],
      ),
    )) ?? false;
  }

}
