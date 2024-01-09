import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student/Profile/EditProfile.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';

import 'package:url_launcher/url_launcher.dart';






late _userProfileState stateofProfile;



class userProfile extends StatefulWidget {
  Map data;

  userProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<userProfile> createState() {
    stateofProfile = _userProfileState();
    return stateofProfile;
  }
}

class _userProfileState extends State<userProfile> {
  bool isHide = false;
  String address = "";




  @override
  void initState() {
    // getallChild(context);
    getAddress();
  }


  getAddress() async{
    // Map addressData = json.decode(widget.data['area']);
    // print(addressData);
    print(widget.data['area']);
    var a = jsonDecode(widget.data['area']);
    address  = (await getLocationString(a['lat'],a['lng']))!;
    setState(() {

    });
    print(address);
  }



  // var a = listItems(bg: subjectsColor[subjects.indexOf(i)],
  //     circles: subjectscircleColor[subjects.indexOf(i)], imgs: stateofHomeScreen.widget.subjectData[i.toString()], h: 30.0, title: i.toString());
  // setState(() {
  // allSubjects.add(a);
  // });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Padding(
            padding: mainPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Spacer(),
                    Avatars(widget.data['photo_url'], 0, "", 50.0),
                    Spacer(),

                  ],
                ),
                SizedBox(height: 10.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mainTextFAQS(widget.data['name'], textLight, 25.0, FontWeight.bold, 1),
                        IconButton(onPressed: (){
                          navScreen(editProfile(data: widget.data), context, false);
                        }, icon: Icon(Iconsax.edit,color: textColor,))
                      ],
                    ),
                    mainTextFAQS(widget.data['gender'] + " "
                        + calculateAge(DateTime.parse(widget.data['dob'])).toString()+ " years"
                        , textLight, 12.0, FontWeight.normal, 1),
                  ],
                ),



                SizedBox(height: 10.0,),

                Container(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          mainTextFAQS(widget.data['mobileno'], textLight, 15.0, FontWeight.bold, 1),

                          SizedBox(height: 5.0,),

                          mainTextFAQS(widget.data['emailid'], textLight, 15.0, FontWeight.bold, 1),

                          SizedBox(height: 5.0,),

                          Row(
                            children: [
                              Expanded(child: mainText(address, textLight, 15.0, FontWeight.bold, 2)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          loaderss(isHide, "Please Wait", true, context)
        ],
      ),
    );
  }
}

