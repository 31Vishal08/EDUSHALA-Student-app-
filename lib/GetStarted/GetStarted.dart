

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:student/Usefull/ImpCards.dart';
import 'package:student/ValueShowCase/ValueShowCase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../Usefull/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:place_picker/place_picker.dart';



double latitude = 23.229672620343724;
double longitude = 77.4326722750532;
late BuildContext mCtx;


class getStarted extends StatefulWidget {
  const getStarted({Key? key}) : super(key: key);

  @override
  State<getStarted> createState() => _getStartedState();
}

class _getStartedState extends State<getStarted> {
  bool isHide = false;
  final _introKey = GlobalKey<IntroductionScreenState>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  String device = "";


  @override
  void initState() {

    vs();
    startLocating();

  }
  startLocating() async{
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;


    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {

      }
    }

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {

    }
    else{
      getPosition();
    }


  }

  getPosition() async {
    geo.Position position = await geo.Geolocator.getCurrentPosition().then((value)  {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
      return Future.value();
    });
  }


  vs(){
    Future.delayed(Duration(microseconds: 200),(){
      navScreen(valueShowCase(), context, false);
    });
  }

  oneSignals() async {
    await OneSignal.shared.setAppId(oneSignalID);
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    device = osUserID.toString();
  }
  @override
  Widget build(BuildContext context) {
    mCtx = context;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: secColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: SafeArea(child: Center(child: Stack(
                      children: [
                        bgcircles(context, bgColor),
                        Blur(context, 80),
                        Row(

                          children: [
                            Spacer(),
                            Image.asset("Assets/obj.png",
                              width: MediaQuery.of(context).size.width * 0.90,),
                            Spacer(),
                          ],
                        ),
                      ],
                    ))),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.60,
                    color: Colors.transparent,
                    child: Container(
                        decoration: new BoxDecoration(
                            color: bgColor,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(30.0),
                              topRight: const Radius.circular(30.0),
                            )
                        ),
                        child: Stack(
                          children: [
                            
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: mainPadding,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Expanded(
                                    child: IntroductionScreen(
                                      isProgressTap:false,
                                      key: _introKey,
                                      scrollPhysics:NeverScrollableScrollPhysics(),
                                      globalBackgroundColor: Colors.transparent,
                                      pages: [
                                        PageViewModel(
                                            titleWidget: Row(
                                              children: [
                                                Expanded(child: mainTextFAQS("Welcome to Edushala", textColor, 35.0, FontWeight.bold, 1)),
                                              ],
                                            ),
                                            bodyWidget: Row(
                                              children: [
                                                mainTextFAQS("give your two minutes\nto gather your details", secColor, 20.0, FontWeight.bold, 2),
                                                Spacer(),
                                              ],
                                            ),
                                            footer:  enterName(),

                                            decoration: const PageDecoration(
                                              bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                                              contentMargin: EdgeInsets.all(0),
                                              titlePadding: EdgeInsets.all(0),
                                              bodyAlignment: Alignment.topLeft,
                                                imageFlex: 3,
                                                bodyFlex: 2,
                                                imagePadding: EdgeInsets.only(bottom: 0)
                                            )
                                        ),
                                        PageViewModel(
                                            titleWidget: Row(
                                              children: [
                                                Expanded(child: mainTextFAQS("So let us know about", textColor, 35.0, FontWeight.bold, 1)),
                                              ],
                                            ),
                                            bodyWidget: Row(
                                              children: [
                                                mainTextFAQS("your email", secColor, 20.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            footer: enterEmail(),

                                            decoration: PageDecoration(
                                                bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                                                contentMargin: EdgeInsets.all(0),
                                                titlePadding: EdgeInsets.all(0),
                                                bodyAlignment: Alignment.topLeft,
                                                imageFlex: 3,
                                                bodyFlex: 2,
                                                imagePadding: EdgeInsets.only(bottom: 0)
                                            )
                                        ),
                                        PageViewModel(
                                            titleWidget: Row(
                                              children: [
                                                mainTextFAQS("Now", textColor, 35.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            bodyWidget: Row(
                                              children: [
                                                mainTextFAQS("Select Your Date of Birth", secColor, 20.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            footer:  enterDOB(),

                                            decoration: PageDecoration(
                                                bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                                                contentMargin: EdgeInsets.all(0),
                                                titlePadding: EdgeInsets.all(0),
                                                bodyAlignment: Alignment.topLeft,
                                                imageFlex: 3,
                                                bodyFlex: 2,
                                                imagePadding: EdgeInsets.only(bottom: 0)
                                            )
                                        ),
                                        PageViewModel(
                                            titleWidget: Row(
                                              children: [
                                                mainTextFAQS("Here just", textColor, 35.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            bodyWidget: Row(
                                              children: [
                                                mainTextFAQS("Select Your Gender", secColor, 20.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            footer:  enterGender(),

                                            decoration: PageDecoration(
                                                bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                                                contentMargin: EdgeInsets.all(0),
                                                titlePadding: EdgeInsets.all(0),
                                                bodyAlignment: Alignment.topLeft,
                                                imageFlex: 3,
                                                bodyFlex: 2,
                                                imagePadding: EdgeInsets.only(bottom: 0)
                                            )
                                        ),
                                        PageViewModel(
                                            titleWidget: Row(
                                              children: [
                                                mainTextFAQS("finding you so", textColor, 35.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            bodyWidget: Row(
                                              children: [
                                                mainTextFAQS("Select your working area", secColor, 20.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            footer:  enterArea(),

                                            decoration: PageDecoration(
                                                bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                                                contentMargin: EdgeInsets.all(0),
                                                titlePadding: EdgeInsets.all(0),
                                                bodyAlignment: Alignment.topLeft,
                                                imageFlex: 3,
                                                bodyFlex: 2,
                                                imagePadding: EdgeInsets.only(bottom: 0)
                                            )
                                        ),
                                        PageViewModel(
                                            titleWidget: Row(
                                              children: [
                                                mainTextFAQS("Finally", textColor, 35.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            bodyWidget: Row(
                                              children: [
                                                mainTextFAQS("Select your Photo", secColor, 20.0, FontWeight.bold, 1),
                                                Spacer(),
                                              ],
                                            ),
                                            footer:  enterPhoto(),

                                            decoration: PageDecoration(
                                                bodyPadding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 0.0),
                                                contentMargin: EdgeInsets.all(0),
                                                titlePadding: EdgeInsets.all(0),
                                                bodyAlignment: Alignment.topLeft,
                                                imageFlex: 3,
                                                bodyFlex: 2,
                                                footerFlex: 3,
                                                imagePadding: EdgeInsets.only(bottom: 0)
                                            )
                                        ),

                                      ],
                                      dotsFlex: 2,
                                      dotsDecorator: DotsDecorator(
                                        activeColor: mainColor,
                                          size: const Size(10.0,2.0),
                                        activeSize: const Size(20.0, 2.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.0)
                                        ),
                                        activeShape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0.0)
                                          ),
                                      ),
                                      controlsPadding: EdgeInsets.all(0),
                                      showNextButton: true,
                                      showBackButton: true,


                                      overrideNext: IconButton(onPressed: (){
                                        next();
                                      },
                                      icon: Icon(Iconsax.arrow_right_3,color: secColor,),
                                      ),

                                      overrideBack: IconButton(onPressed: (){
                                        _introKey.currentState!.previous();
                                      },
                                        icon: Icon(Iconsax.arrow_left_2,color: textLight,),
                                      ),

                                      overrideDone: IconButton(onPressed: (){
                                        done();
                                      },
                                        icon: Icon(Iconsax.tick_circle,color: Colors.green,),
                                      ),
                                  onDone: (){

                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ),

                ],
              ),
            ),
            loaderss(isHide, "Please wait", true, context),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  done() async{
    if(_introKey.currentState!.getCurrentPage() == 5){
      if(stateofPhoto.img != ""){
        // toaster(context,"Finish");
        setState(() {
          isHide = true;
        });
        String imgs = await uploadImage(stateofPhoto.img);
        postData(imgs);
      }
      else{
        postData("noimg");
      }
    }
  }

  postData(String imgs) async {
    setState(() {
      isHide = true;
    });
    if(device == ""){
      await OneSignal.shared.setAppId(oneSignalID);
      final status = await OneSignal.shared.getDeviceState();
      final String? osUserID = status?.userId;
      device = osUserID.toString();
    }
    http.Response response = await http.post(Uri.parse(createUserUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'user_code': _auth.currentUser!.uid,
        'name': stateOfName.name,
        'gender':stateOfGender.gender,
        'dob':stateOfDOB.Dobs.toString(),
        'emailid':stateOfEmail.email,
        'mobileno':_auth.currentUser!.phoneNumber.toString(),
        'area':jsonEncode({
          'lat':stateofArea.lat,
          'lng':stateofArea.lng,
        }),
        'photo_url':imgs,
        'type':'parent',
        'player_id':device,

      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      checker(_auth.currentUser!.uid, context);
    }
    else{
      setState(() {
        isHide = false;
        toaster(context,"Something went wrong");
      });
    }
  }


  next(){
    if(_introKey.currentState!.getCurrentPage() == 0){
      if(stateOfName.formKey.currentState!.validate()){
        _introKey.currentState!.next();
      }
    }
    else if(_introKey.currentState!.getCurrentPage() == 1){
      if(stateOfEmail.formKey.currentState!.validate()){
        _introKey.currentState!.next();
      }
    }
    else if(_introKey.currentState!.getCurrentPage() == 2){
      if(stateOfDOB.formKey.currentState!.validate()){
        _introKey.currentState!.next();
      }
    }
    else if(_introKey.currentState!.getCurrentPage() == 3){
      if(stateOfGender.formKey.currentState!.validate()){
        _introKey.currentState!.next();
      }
    }
    else if(_introKey.currentState!.getCurrentPage() == 4){
      if(stateofArea.formKey.currentState!.validate()){
        _introKey.currentState!.next();
      }

    }
  }
}


late _enterNameState stateOfName;
class enterName extends StatefulWidget {
  const enterName({Key? key}) : super(key: key);

  @override
  State<enterName> createState() {
    stateOfName = _enterNameState();
    return stateOfName;
  }
}

class _enterNameState extends State<enterName> {
  String name = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(

            style: TextStyle(

              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.text,
            maxLength: 20,

            decoration: InputDecoration(

              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Enter Your Name",
              suffixIcon: Icon(Iconsax.user,color: mainColor,),
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:secColor
              ),

              errorStyle: TextStyle(
                  fontFamily: 'mons',
                  color: errorColor
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent,width: 0),
                borderRadius: BorderRadius.circular(15.0),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: transparent_overlay,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorColor,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            validator: (value){
              if(value!.isEmpty){
                return("Please Enter Your Name");
              }
            },
            onChanged: (text){
              name = text;
            },

          ),
        ),
      ],
    );
  }
}





late _enterEmailState stateOfEmail;
class enterEmail extends StatefulWidget {
  const enterEmail({Key? key}) : super(key: key);

  @override
  State<enterEmail> createState() {
    stateOfEmail = _enterEmailState();
    return stateOfEmail;
  }
}

class _enterEmailState extends State<enterEmail> {
  String email = "";
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            style: TextStyle(

              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.emailAddress,
            maxLength: 48,

            decoration: InputDecoration(

              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Email",
              suffixIcon: Icon(Iconsax.message_2,color: mainColor,),
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:secColor
              ),

              errorStyle: TextStyle(
                  fontFamily: 'mons',
                  color: errorColor
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent,width: 0),
                borderRadius: BorderRadius.circular(15.0),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: transparent_overlay,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorColor,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

              validator: (value){
                bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                if(!emailValid){
                  return("Please enter a valid email");
                }
                else{
                  return null;
                }
              },
            onChanged: (text){
              email = text;
            },

          ),
        ),
      ],
    );
  }
}



late _enterDOBState stateOfDOB;
class enterDOB extends StatefulWidget {
  const enterDOB({Key? key}) : super(key: key);

  @override
  State<enterDOB> createState() {
    stateOfDOB = _enterDOBState();
    return stateOfDOB;
  }
}

class _enterDOBState extends State<enterDOB> {
  String DOB = "";
  DateTime Dobs = DateTime.now();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: DOB),
            style: TextStyle(

              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.datetime,
            maxLength: 48,

            decoration: InputDecoration(

              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Date Of Birth",
              suffixIcon: Icon(Iconsax.calendar,color: mainColor,),
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: const TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:secColor
              ),

              errorStyle: TextStyle(
                  fontFamily: 'mons',
                  color: errorColor
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent,width: 0),
                borderRadius: BorderRadius.circular(15.0),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: transparent_overlay,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorColor,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            validator: (value){
              if(value!.isEmpty){
                return("Please Select Your Date of Birth");
              }
              else{
                return null;
              }
            },
            onChanged: (text){
              DOB = text;
            },
            onTap: (){
              showDate();
            },

          ),
        ),
      ],
    );
  }
  showDate(){
      // DatePickerDialog(
      //   firstDate: DateTime(1950),
      //   initialDate: DateTime(2001),
      //   lastDate: DateTime(2007),
      //   onDatePickerModeChange: (date){
      //     if(date != null){
      //       print(date);
      //     }
      //   },
      //
      // );

    showDatePicker(
      context: context,
      initialDate: DateTime(2001),
      firstDate: DateTime(1950),
      lastDate: DateTime(2007),
    ).then((date) {
      if (date != null) {
        print(date);
        String formattedDob = DateFormat('dd-MM-yyyy').format(date);
        setState(() {
          Dobs = date;
          DOB = formattedDob;
        });
      }
    });


    // DatePicker.showDatePicker(context,
    //       showTitleActions: true,
    //       minTime: DateTime(1950),
    //       maxTime: DateTime(2007),
    //       currentTime: DateTime(2001),
    //       onChanged: (date){
    //         if(date != null){
    //           print(date);
    //         }
    //       },
    //       onConfirm: (date){
    //         if(date != null){
    //           String formattedDob = DateFormat('dd-MM-yyyy').format(date);
    //           setState(() {
    //             Dobs = date;
    //             DOB = formattedDob;
    //           });
    //         }
    //       },
    //       // theme: DatePickerTheme(
    //       //   itemStyle: TextStyle(
    //       //       color: textLight,
    //       //       fontFamily: 'mons',
    //       //       fontSize:17.0
    //       //   ),
    //       //   doneStyle: TextStyle(
    //       //     color: mainColor,
    //       //     fontFamily: 'mons',
    //       //     fontSize: 20.0,
    //       //   ),
    //       //   cancelStyle: TextStyle(
    //       //     color: textColor,
    //       //     fontFamily: 'mons',
    //       //     fontSize: 20.0,
    //       //   ),
    //       // )
    //   );
    }

}


late _enterGenderState stateOfGender;
class enterGender extends StatefulWidget {
  const enterGender({Key? key}) : super(key: key);

  @override
  State<enterGender> createState() {
    stateOfGender = _enterGenderState();
    return stateOfGender;
  }
}

class _enterGenderState extends State<enterGender> {
  String gender = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: gender),
            style: TextStyle(

              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.text,
            maxLength: 48,

            decoration: InputDecoration(

              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Gender",
              suffixIcon: Icon(Iconsax.woman,color: mainColor,),
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:secColor
              ),

              errorStyle: TextStyle(
                  fontFamily: 'mons',
                  color: errorColor
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent,width: 0),
                borderRadius: BorderRadius.circular(15.0),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: transparent_overlay,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorColor,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            validator: (value){
              if(value!.isEmpty){
                return("Please Select Your Gender");
              }
              else{
                return null;
              }
            },
            onChanged: (text){
              gender = text;
            },
            onTap: (){
              showGender();
            },

          ),
        ),
      ],
    );
  }

  showGender(){
    bottoms(context, Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(onPressed: (){
          setState(() {
            gender = "male";
          });
          Navigator.of(context).pop(true);
        }, child: Row(
          children: [
            Icon(Iconsax.man,color: textColor,),
            SizedBox(width: 5.0,),
            mainText("Male", textColor, 15.0, FontWeight.normal, 1),
          ],
        )),
        TextButton(onPressed: (){
          setState(() {
            gender = "female";
          });
          Navigator.of(context).pop(true);
        }, child: Row(
          children: [
            Icon(Iconsax.woman,color: textColor,),
            SizedBox(width: 5.0,),
            mainText("Female", textColor, 15.0, FontWeight.normal, 1),
          ],
        )),
      ],
    ));
  }

}


late _enterAreaState stateofArea;
class enterArea extends StatefulWidget {
  const enterArea({Key? key}) : super(key: key);

  @override
  State<enterArea> createState() {
    stateofArea = _enterAreaState();
    return stateofArea;
  }
}

class _enterAreaState extends State<enterArea> {
  double lat = 0.0;
  double lng = 0.0;
  String Area = "";
  final formKey = GlobalKey<FormState>();
  Widget suffix = Icon(Iconsax.location,color: mainColor,);
  bool locating = false;
  bool located = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: Area),
            style: TextStyle(

              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            minLines: 1,
            maxLength: 120,

            decoration: InputDecoration(

              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Choose Your Working Area",
              suffixIcon: suffix,
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:secColor
              ),

              errorStyle: TextStyle(
                  fontFamily: 'mons',
                  color: errorColor
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent,width: 0),
                borderRadius: BorderRadius.circular(15.0),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: transparent_overlay,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorColor,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            validator: (value){
              if(value!.isEmpty){
                return("Please Select Your Working Area");
              }
              else{
                return null;
              }
            },
            onChanged: (text){
              Area = text;
            },
            onTap: (){
              // startLocating();
              getLocationPicker();
            },

          ),
        ),
      ],
    );
  }

  getLocationPicker() async{
    LocationResult result = await Navigator.of(mCtx).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker(mapApiKey,
              // displayLocation:LatLng(latitude,longitude),
            )
    ));
    setState(() {
      lat = result.latLng!.latitude;
      lng = result.latLng!.longitude;
      Area = result.formattedAddress!;
      suffix = Icon(Iconsax.tick_circle,color: Colors.green,);

    });
    print("result is $result");
  }

  startLocating() async{
    setState(() {
      locating = true;
      suffix = Container(
        width: 15.0,
        height : 15.0,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey,
          color: mainColor,
          strokeWidth: 3,
        ),
      );
    });
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {

    }
    else{
      getPosition();
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }


  getPosition() async {
    geo.Position position = await geo.Geolocator.getCurrentPosition().then((value)  {
      setState(() {
        lat = value.latitude;
        lng = value.longitude;
        if (lng != 0.0) {
          getCityData(lat, lng);
        }
      });
      return Future.value();
    });
  }

  getCityData(double lat, double lng) async{
    var address = await Geocoder.local
        .findAddressesFromCoordinates(Coordinates(lat, lng));
    print(address.first.locality);
    setState(() {
      suffix = Icon(Iconsax.tick_circle,color: Colors.green,);
      locating = false;
      located = true;
      Area = address.first.addressLine.toString();
    });

  }
}



late _enterSubjectsState stateofSubjects;
class enterSubjects extends StatefulWidget {
  const enterSubjects({Key? key}) : super(key: key);

  @override
  State<enterSubjects> createState() {
    stateofSubjects = _enterSubjectsState();
    return stateofSubjects;
  }
}

class _enterSubjectsState extends State<enterSubjects> {
  Map<String, String> allSubjects = {
    'Science':'Assets/Subjects/science.png',
    'Biology':'Assets/Subjects/biology.png',
    'Chemistry':'Assets/Subjects/chemistry.png',
    'English':'Assets/Subjects/english.png',
    'History':'Assets/Subjects/history.png',
    'Maths':'Assets/Subjects/maths.png',
    'Physics':'Assets/Subjects/physics.png',
  };
  List<String> selectSubject = [];
  List<Color> allColor = [Colors.redAccent,
  Colors.pinkAccent,Colors.greenAccent,Colors.teal,Colors.orangeAccent,Colors.blueAccent,Colors.redAccent,
  Colors.pinkAccent,Colors.greenAccent,Colors.teal,Colors.orangeAccent,Colors.blueAccent,Colors.redAccent,
  Colors.pinkAccent,Colors.greenAccent,Colors.teal,Colors.orangeAccent,Colors.blueAccent,];

  List<subjectCard> subjectsItem = [];


  @override
  void initState() {
    for(var i in allSubjects.keys){
      var a = subjectCard(title: i, bg: allColor[allSubjects.keys.toList().indexOf(i)], img: allSubjects[i].toString());
      setState(() {
        subjectsItem.add(a);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mainText(selectSubject.join(", "), textColor, 15.0, FontWeight.normal, 1),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: subjectsItem,
            )),
      ],
    );
  }
}



late _enterSchoolState stateofSchool;
class enterSchool extends StatefulWidget {
  const enterSchool({Key? key}) : super(key: key);

  @override
  State<enterSchool> createState() {
    stateofSchool = _enterSchoolState();
    return stateofSchool;
  }
}

class _enterSchoolState extends State<enterSchool> {

  String School = "";
  final formKey = GlobalKey<FormState>();
  Widget suffix = Icon(Iconsax.building_3,color: mainColor,);
  bool locating = false;
  bool located = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            style: TextStyle(

              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.text,
            maxLength: 120,

            decoration: InputDecoration(

              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Enter Your School",
              suffixIcon: suffix,
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:secColor
              ),

              errorStyle: TextStyle(
                  fontFamily: 'mons',
                  color: errorColor
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent,width: 0),
                borderRadius: BorderRadius.circular(15.0),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: transparent_overlay,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorColor,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            validator: (value){
              if(value!.isEmpty){
                return("Please Enter Your School");
              }
              else{
                return null;
              }
            },
            onChanged: (text){
              School = text;
            },


          ),
        ),
      ],
    );
  }
}


late _enterClassState stateofClass;
class enterClass extends StatefulWidget {
  const enterClass({Key? key}) : super(key: key);

  @override
  State<enterClass> createState() {
    stateofClass = _enterClassState();
    return stateofClass;
  }
}

class _enterClassState extends State<enterClass> {
  String classs = "";
  final formKey = GlobalKey<FormState>();
  Widget suffix = Icon(Iconsax.building,color: mainColor,);
  bool locating = false;
  bool located = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            style: TextStyle(

              fontFamily: 'mons',
              fontSize: 15.0,
              color:textColor,
            ),
            keyboardType: TextInputType.text,
            maxLength: 20,

            decoration: InputDecoration(

              counterText: "",
              filled: true,
              fillColor: lightWhite,
              hintText: "Enter Your Class",
              suffixIcon: suffix,
              // suffixIcon: Icon(Iconsax.call,color: Colors.grey,size: 20.0,),
              hintStyle: TextStyle(
                  fontFamily: 'mons',
                  color:Colors.grey
              ),
              labelStyle: TextStyle(
                  fontFamily: 'mons',
                  color:secColor
              ),

              errorStyle: TextStyle(
                  fontFamily: 'mons',
                  color: errorColor
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent,width: 0),
                borderRadius: BorderRadius.circular(15.0),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: transparent_overlay,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: errorColor,
                    width: 0
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),

            ),

            validator: (value){
              if(value!.isEmpty){
                return("Please Enter Your Class");
              }
              else{
                return null;
              }
            },
            onChanged: (text){
              classs = text;
            },


          ),
        ),
      ],
    );
  }
}


late _enterPhotoState stateofPhoto;
class enterPhoto extends StatefulWidget {
  const enterPhoto({Key? key}) : super(key: key);

  @override
  State<enterPhoto> createState() {
    stateofPhoto = _enterPhotoState();
    return stateofPhoto;
  }
}

class _enterPhotoState extends State<enterPhoto> {
  String img = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Avatars("", 0, img, 50.0),
        SizedBox(height: 5.0,),

        custombtnsss("Choose Photo", () {updatePhoto();}, secColor, Colors.white, 5.0),
      ],
    );
  }

  updatePhoto() async{
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,);


    if (pickedFile != null) {
      final file = File(pickedFile.path);
      print(file.path);
      cropSquare(File(pickedFile.path), context);
      // uploadFile(file.path, context);
    }
  }

  Future cropSquare(File imageFile,BuildContext context) async {
    CroppedFile? a = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square]);


    setState(() {
      img = a!.path;
    });
  }
}




