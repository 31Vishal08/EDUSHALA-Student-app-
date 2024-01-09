import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Class/OneClass.dart';
import 'package:student/Homes/Children.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/MeetWeb/MeetWeb.dart';
import 'package:student/Test/OneTest.dart';
import 'package:student/Test/PDFTestReport.dart';
import 'package:student/Test/TestReport.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';

import '../Usefull/Buttons.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';



late _reviewSectionState stateofReviewSection;
class reviewSection extends StatefulWidget {
  Map classData;
  Map tutorData;
  reviewSection({Key? key,required this.classData,required this.tutorData}) : super(key: key);

  @override
  State<reviewSection> createState() {
    stateofReviewSection = _reviewSectionState();
    return stateofReviewSection;
  }
}

class _reviewSectionState extends State<reviewSection> {
  bool isHide = true;
  bool noratings = true;
  Widget ratingData = Column();


  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        elevation: 0.0,
        color: secColor,
        child: ExpansionTile(
          iconColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  mainTextFAQS("Review and Rating", Colors.white, 20.0, FontWeight.bold, 1),
                ],
              ),
              Visibility(
                  visible: !isHide && noratings,
                  child: onlymainText("No Rating Review for this tutor", lightWhite, 10.0, FontWeight.normal, 1)),

              Visibility(
                  visible: !isHide && !noratings,
                  child:ratingData),

            ],
          ),
          children: [allRating(classData: widget.classData,tutorData: widget.tutorData,)],
        ),
      ),
    );
  }
}


late _allRatingState stateofAllRatings;
class allRating extends StatefulWidget {
  Map classData;
  Map tutorData;
  allRating({Key? key,required this.classData,required this.tutorData}) : super(key: key);

  @override
  State<allRating> createState() {
    stateofAllRatings = _allRatingState();
    return stateofAllRatings;
  }
}

class _allRatingState extends State<allRating> {
  bool isHide = false;
  bool noratings = true;
  List<Widget> allRatings = [];
  double rat = 0.0;
  double totalRating = 0;
  int noOfRating = 0;
  bool addReview = true;


  @override
  void initState() {
    getAllRatings();
  }

  getAllRatings() async{
    setState(() {
      isHide = true;
      allRatings = [];
    });
    http.Response response = await http.post(Uri.parse(getReviewByTutorId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'tutor': widget.classData['tutor'],
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map reviewData = jsonDecode(response.body);
      List allReviews = reviewData['review'];
      int totalReview = 0;
      for(var i in allReviews){
        if(i['assigned'] == widget.classData['id']){
          setState(() {
            addReview = false;
          });
        }
        noOfRating += 1;
        totalRating += int.parse(i['rating']);
        if(i['review'] != ""){
          if(totalReview <= 3){
            Map userData = await getOneUserbyid(i['parent']);
            var a = oneReviewItem(userData: userData, ratingData: i);
            setState(() {
              allRatings.add(a);
            });
            totalReview += 1;
          }
        }
        if(allReviews.last == i){
          setState(() {
            isHide = false;
            noratings = false;
          });
          stateofReviewSection.setState(() {
            stateofReviewSection.isHide = false;
            stateofReviewSection.noratings = false;
            stateofReviewSection.ratingData = Row(
              children: [
                mainText((totalRating/noOfRating).toStringAsFixed(2), Colors.white, 40.0, FontWeight.bold, 1),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingStars(
                        starSize: 25,
                        maxValueVisibility: false,
                        valueLabelVisibility: false,
                        starColor: oneCardColor,
                        value: double.parse((totalRating/noOfRating).toStringAsFixed(2)),
                      ),
                      onlymainText("based on $noOfRating rating and reviews", lightWhite, 10.0, FontWeight.normal, 1),
                    ],
                  ),
                ),
              ],
            );
          });
        }
      }

    }
    else{
      setState(() {
        isHide= false;
        noratings = true;
        stateofReviewSection.setState(() {
          stateofReviewSection.isHide = false;
          stateofReviewSection.noratings = true;
        });
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0.0,
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Avatars(widget.tutorData['photo_url'], 0, "", 20.0),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mainTextFAQS(widget.tutorData['name'], textColor, 15.0, FontWeight.bold, 1),
                      mainTextFAQS('tutor', Colors.grey, 10.0, FontWeight.normal, 1),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),


        Visibility(
          visible: addReview,
          child: GestureDetector(
            onTap: (){
              CreateReview();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              color: oneCardColor,
              margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.add_circle,color: Colors.white,),
                    SizedBox(width: 5.0,),
                    onlymainText("Add Review", Colors.white, 10.0, FontWeight.bold, 1)
                  ],
                ),
              ),
            ),
          ),
        ),

        Column(
          children: allRatings,
        ),
        
        Visibility(
            visible: isHide,
            child: Container(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                color: secColor,
              ),
            )),

      ],
    );
  }

  Future<bool> CreateReview() async {

    final formKey = GlobalKey<FormState>();
    String review = "";
    double rating = 0.0;
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titleTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 20.0, color: greenColor,),
        contentTextStyle:
        TextStyle(fontFamily: 'mons', fontSize: 13.0, color: Colors.grey),
        alignment: Alignment.center,
        backgroundColor: Colors.white,
        actionsAlignment: MainAxisAlignment.center,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Row(
          children: [
            Spacer(),
            onlymainText("Add Review", secColor, 20.0, FontWeight.bold, 1),
            Spacer(),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            double rat = 4.0;
            return Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  PannableRatingBar(
                      rate: rating,
                      items: List.generate(5, (index) =>
                      RatingWidget(
                          selectedColor: oneCardColor,
                          unSelectedColor: Colors.grey,
                          child: Icon(CupertinoIcons.star_fill,size: 35.0,)),

                      ),
                  onChanged: (value){
                        setState(() {
                          rating = double.parse(value.round().toString());
                        });
                  },
                  ),
                  SizedBox(height: 10.0,),

                  TextFormField(
                    style: TextStyle(
                      fontFamily: 'mons',
                      fontSize: 15.0,
                      color:textColor,
                    ),

                    keyboardType: TextInputType.multiline,
                    maxLength: 200,
                    minLines: 1,
                    maxLines: 5,

                    decoration: InputDecoration(

                      counterText: "",
                      filled: true,
                      fillColor: lightWhite,
                      hintText: "Write Your Review",
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
                        return("Please Enter a Passing Marks");
                      }
                      else{
                        return null;
                      }
                    },
                    onChanged: (text){
                      review  = text;
                    },
                  ),

                  SizedBox(height: 10.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                    height: 50.0,
                    child:newiconbtnsss("POST REVIEW", () {
                      if(rating != 0.0) {
                        Navigator.of(context).pop(false);
                        PostReview(review, int.parse(rating.round().toString()));
                      }
                      else{
                        toaster(context, "Please Give a Rating");
                      }
                    }, oneCardColor,Colors.white,Iconsax.star,10.0),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    )) ?? false;
  }

  PostReview(String review,int rating) async{

    http.Response response = await http.post(Uri.parse(createReviewUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'parent':widget.classData['parent'],
        'child':widget.classData['child'],
        'tutor':widget.classData['tutor'],
        'assigned':widget.classData['id'],
        'review': review,
        'rating':rating.toString(),
        'creation':DateTime.now().toString(),
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      toaster(context, "Rating Posted Succesfully");
      stateofOneClass.setState(() {
        stateofOneClass.isHide = false;
      });
    }
    else{
      stateofOneClass.setState(() {
        stateofOneClass.isHide = false;
      });
    }
  }


}

class oneReviewItem extends StatefulWidget {
  Map userData;
  Map ratingData;
  oneReviewItem({Key? key,required this.userData,required this.ratingData}) : super(key: key);

  @override
  State<oneReviewItem> createState() => _oneReviewItemState();
}

class _oneReviewItemState extends State<oneReviewItem> {



  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 2.0),
      // height: MediaQuery.of(context).size.height * 0.20,
      child: Card(
        elevation: 0.0,
        color:Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            mainTextFAQS(widget.userData['name'], textColor, 15.0, FontWeight.bold, 1),
                            onlymainText('parent', Colors.grey, 10.0, FontWeight.normal, 1),
                            SizedBox(height: 5.0,),
                            RatingStars(
                              starSize: 15,
                              maxValueVisibility: false,
                              valueLabelVisibility: false,
                              starColor: oneCardColor,
                              value: double.parse(widget.ratingData['rating']),
                            ),
                          ],
                        ),
                      ),
                      mainTextFAQS(DateFormat("dd MMM yyyy").format(DateTime.parse(widget.ratingData['creation'])),
                          Colors.grey, 10.0, FontWeight.bold, 1),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  mainTextFAQS(widget.ratingData['review'], textLight, 15.0, FontWeight.normal, 10),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
