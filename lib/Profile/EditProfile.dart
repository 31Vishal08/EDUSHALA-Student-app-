import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Dialogs.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:introduction_screen/introduction_screen.dart';

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






late _editProfileState stateofeditProfile;

class editProfile extends StatefulWidget {
  Map data;
  editProfile({Key? key,required this.data}) : super(key: key);

  @override
  State<editProfile> createState() {
    stateofeditProfile = _editProfileState();
    return stateofeditProfile;
  }
}

class _editProfileState extends State<editProfile> {
  bool isHide = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String file = "";
  String name = "";
  String dob = "";
  DateTime dobs = DateTime.now();

  String gender = "";
  String email = "";

  double lat = 0.0;
  double lng = 0.0;
  String Area = "";
  Widget suffix = Icon(Iconsax.location,color: mainColor,);
  bool locating = false;
  bool located = false;

  final formKey = GlobalKey<FormState>();



  @override
  void initState() {
    // oneSignals();
    print("hello ${widget.data}");
    updateData();
  }

  updateData() async{
    name = widget.data['name'];
    email = widget.data['emailid'];
    gender = widget.data['gender'];
    dobs = DateTime.parse(widget.data['dob']);
    dob = DateFormat('dd-MM-yyyy').format(dobs);
    print(widget.data['area']);
    var a = jsonDecode(widget.data['area']);
    lat = a['lat'];
    lng = a['lng'];
    Area = (await getLocationString(a['lat'],a['lng']))!;
    setState(() {

    });
  }








  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: _key,
          backgroundColor: bgColor,
          // drawer: navigationDrawer(allData: widget.data),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            // leadingWidth: 100.0,
            elevation: 0.0,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Iconsax.arrow_left_2,color: mainColor,)),

          ),
          body: Stack(
            children:[
              newbgcircles(context, secColor),
              Blur(context, 100),
              Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: mainPadding,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          profileAvatar(widget.data['photo_url'], 0, file, 60.0, () {updatePhoto();}),
                          Spacer(),
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        controller: TextEditingController(text: name),
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
                      SizedBox(height: 10.0,),
                      TextFormField(
                        controller: TextEditingController(text: email),
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
                      SizedBox(height: 10.0,),
                      TextFormField(
                        readOnly: true,
                        controller: TextEditingController(text: dob),
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
                            return("Please Select Your Date of Birth");
                          }
                          else{
                            return null;
                          }
                        },
                        onChanged: (text){
                          dob = text;
                        },
                        onTap: (){
                          showDate();
                        },

                      ),
                      SizedBox(height: 10.0,),
                      TextFormField(
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
                      SizedBox(height: 10.0,),
                      TextFormField(
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
                          hintText: "Select Your Working Area",
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
                          startLocating();
                        },

                      )
                    ],
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(20.0),
                alignment: Alignment.bottomRight,
                child: circularBtn(Iconsax.tick_circle,
                        () {
                  dialogs(context, "Edit Profile", "You want to edit profile", "Yes", "No", ()
                  {checkEditProfile();});
                        }, mainColor, Colors.white,false),
              ),

            ]
          )
      ),
    );
  }

  checkEditProfile() async{
    if(formKey.currentState!.validate()) {
      Navigator.of(context).pop(false);
      setState(() {
        isHide = true;
      });
      if (file == "") {
        editProfile("");
      }
      else {
        String imgs = await uploadImage(file);
        editProfile(imgs);
      }
    }
  }

  editProfile(String img) async  {
    if(formKey.currentState!.validate()) {
      setState(() {
        isHide = true;
      });
      Map<String,String> item = {
        'user_code': _auth.currentUser!.uid,
        'name': name,
        'gender':gender,
        'dob':dobs.toString(),
        'emailid':email,
        'area':jsonEncode({
          'lat':lat,
          'lng':lng,
        }),
      };

      if(img != ""){
        item['photo_url'] = img;
      }

      http.Response response = await http.post(Uri.parse(updateUserUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(item),
      );
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200){
        toaster(context,"Profile Updated Successfully");
        checker(_auth.currentUser!.uid, context);
      }
      else{
        setState(() {
          isHide = false;
          toaster(context,"Something went wrong");
        });
      }
    }
  }

  showDate(){

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
          dobs = date;
          dob = formattedDob;
        });
      }
    });
    // DatePicker.showDatePicker(context,
    //     showTitleActions: true,
    //     minTime: DateTime(1950),
    //     maxTime: DateTime(2007),
    //     currentTime: DateTime(2001),
    //     onChanged: (date){
    //       if(date != null){
    //         print(date);
    //       }
    //     },
    //     onConfirm: (date){
    //       if(date != null){
    //         String formattedDob = DateFormat('dd-MM-yyyy').format(date);
    //         setState(() {
    //           dobs = date;
    //           dob = formattedDob;
    //         });
    //       }
    //     },
    //     // theme: DatePickerTheme(
    //     //   itemStyle: TextStyle(
    //     //       color: textLight,
    //     //       fontFamily: 'mons',
    //     //       fontSize:17.0
    //     //   ),
    //     //   doneStyle: TextStyle(
    //     //     color: mainColor,
    //     //     fontFamily: 'mons',
    //     //     fontSize: 20.0,
    //     //   ),
    //     //   cancelStyle: TextStyle(
    //     //     color: textColor,
    //     //     fontFamily: 'mons',
    //     //     fontSize: 20.0,
    //     //   ),
    //     // )
    // );
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
      print(a!.path);
      file = a.path;
    });
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
