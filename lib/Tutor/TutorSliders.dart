import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/DummyData/dummyData.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Usefull/Colors.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Usefull/Buttons.dart';
import 'package:flutter/services.dart';
// import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;













late _TutorSliderState stateofTutorSlider;

class TutorSlider extends StatefulWidget {
  List allTutorData;
  Map enquiryData;
  TutorSlider({Key? key,required this.allTutorData,required this.enquiryData}) : super(key: key);

  @override
  State<TutorSlider> createState() {
    stateofTutorSlider = _TutorSliderState();
    return stateofTutorSlider;
  }
}

class _TutorSliderState extends State<TutorSlider> with SingleTickerProviderStateMixin{
  bool isHide = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool notFound = false;
  bool isHorray = false;
  bool assigned = false;
  Widget assignedCard = Column();


  final formKey = GlobalKey<FormState>();

  bool showUp = true;
  CardSwiperController _cardSwiperController = CardSwiperController();

  late AnimationController lottieController;



  @override
  void initState() {
    print("enquiry ${widget.enquiryData}");
    lottieController = AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    if(widget.allTutorData.length == 1){
      setState(() {
        widget.allTutorData.add(widget.allTutorData[0]);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
            children: [
              Visibility(
                visible: !assigned,
                child: CardSwiper(
                  controller: _cardSwiperController,
                  cardsCount: widget.allTutorData.length,
                  cardBuilder: (ctx,index,x,y){
                  return tutorCard(data: widget.allTutorData[index]);
                },
                onSwipe: (i,ii,d){
                    print(d.name);
                    if(d.name == "top"){
                      print("Tops");
                      swipeUp(i);
                    }
                    return true;
                },
                ),
              ),
              Visibility(
                visible: showUp,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      showUp = !showUp;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("Assets/up.json",
                          width: 300.0,
                          frameRate: FrameRate.max,
                          repeat: true,
                          alignment: Alignment.center,
                        ),
                        Card(
                            color: secColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: mainText("Swipe up to book a tutor", Colors.white, 10.0, FontWeight.bold, 1),
                            )),
                      ],
                    ),
                  ),
                ),
              ),

              Visibility(
                  visible: assigned,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      assignedCard,

                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 0.0),
                        height: 50.0,
                        child: custombtnsss("TUTOR ASSIGNED", () {
                          // setState(() {
                          //   isHide = true;
                          // });
                          // checker(_auth.currentUser!.uid, context);
                        }, greenColor, Colors.white,10.0),
                      ),
                      TextButton(onPressed: (){
                        setState(() {
                          isHide = true;
                        });
                        checker(_auth.currentUser!.uid, context);
                      },
                          child: mainText("Go back to HomeScreen", secColor, 10.0, FontWeight.bold, 1))
                    ],
                  )),
              Visibility(
                visible: isHorray,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: Lottie.asset('Assets/horray.json',
                    repeat: false,
                    controller: lottieController,
                    width: MediaQuery.of(context).size.width,
                    onLoaded: (composition) {
                      lottieController.duration = composition.duration;
                      lottieController.forward();
                    },
                    frameRate: FrameRate.max,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              loaderss(isHide, "Please Wait", true, context)

            ],
          );
  }

  swipeUp(int index) async{
    assignedShit(index);
    double days = double.parse(widget.enquiryData['frequency']) * 4;
    double credits = days * double.parse(widget.enquiryData['duration'].toString().split(" ")[0]);
    double bill = 200;

    if(widget.allTutorData[index]['bill'] != null) {
      bill = double.parse(widget.allTutorData[index]['bill']);
    }
    double amount = bill * credits;
    Map aData = {
      'parent':widget.enquiryData['parent'].toString(),
      'child':widget.enquiryData['child'].toString(),
      'tutor':widget.allTutorData[index]['tutor_id'].toString(),
      'enquiry':widget.enquiryData['id'].toString(),
      'start_date':widget.enquiryData['startdate'].toString(),
      'credits':credits.toString(),
      'amount':amount.toString(),
      'duration':widget.enquiryData['duration'],
      'time':widget.enquiryData['time'],
      'status':'pending',

    };
    print(aData);
    http.Response response = await http.post(Uri.parse(completeEnquiry),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'parent':widget.enquiryData['parent'].toString(),
        'child':widget.enquiryData['child'].toString(),
        'tutor':widget.allTutorData[index]['tutor_id'].toString(),
        'enquiry':widget.enquiryData['id'].toString(),
        'start_date':widget.enquiryData['startdate'].toString(),
        'credits':credits.toString(),
        'amount':amount.toString(),
        'duration':widget.enquiryData['duration'],
        'time':widget.enquiryData['time'],
        'status':'pending',
        'frequency':widget.enquiryData['frequency']
      }),
    );
    print("complete ${response.statusCode}");
    print(response.body);
    postNotification(widget.allTutorData[index]['player_id'], "A new class has been assigned to you", "New Class added");
  }

  assignedShit(int index)  async{
    setState(() {
      isHorray = true;
      assigned = true;
      assignedCard = assignedtutorCard(data: widget.allTutorData[index],);
      lottieController.reset();
      lottieController.forward();

      Future.delayed(Duration(seconds: 2),(){
        setState(() {
         isHorray = false;
        });
      });
    });
  }
}

class tutorCard extends StatelessWidget {
  Map data;
  tutorCard({Key? key,required this.data}) : super(key: key);

  int age = 0;

  List<Widget> allSubs = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 00.0,vertical: 00.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Avatars(data['photo_url'], 0, "", 50.0),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mainText(data['name'], textColor, 25.0, FontWeight.bold, 1),
                  // Icon(Iconsax.verify,color: secColor,),
                ],
              ),
              SizedBox(height: 0.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mainText(data['gender'] + ", ", Colors.grey, 10.0, FontWeight.normal, 1),
                  mainText("${calculateAge(DateTime.parse(data['dob']))} years", Colors.grey, 10.0, FontWeight.normal, 1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.verify,color: secColor,size: 15.0,),
                  mainText(" verified tutor", secColor, 10.0, FontWeight.normal, 1),
                ],
              ),
              SizedBox(height: 10.0,),
              Wrap(
                children: jsonDecode(data['subject']).map<Widget>((i) =>
                    smallbtnsss(stateofHomeScreen.widget.subjectData[i]['title'],
                            () { }, lightWhite,Colors.grey)).toList(),
                spacing: 3.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.center,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.all(15.0),
                height: 50.0,
                child: custombtnsss("SELECT TUTOR", () {
                  stateofTutorSlider._cardSwiperController.swipeTop();
                }, greenColor, Colors.white,10.0),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  child: allRatings(data: data,),
                ),
              ),

          ],),
        ),
      ),
    );
  }
}

class allRatings extends StatefulWidget {
  Map data;
  allRatings({Key? key,required this.data}) : super(key: key);

  @override
  State<allRatings> createState() => _allRatingsState();
}

class _allRatingsState extends State<allRatings> {
  bool isHide = false;
  bool norating = false;
  bool noReview = false;
  List<Widget> allRatings = [];
  double totalRating = 0;
  int noOfRating = 0;

  @override
  void initState() {
    getAllRatings();
    print(widget.data);
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
        'tutor': widget.data['tutor_i']
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map reviewData = jsonDecode(response.body);
      List allReviews = reviewData['review'];
      int totalReview = 0;
      for(var i in allReviews){
        noOfRating += 1;
        totalRating += int.parse(i['rating']);
        if(i['review'] != ""){
          if(totalReview <= 4){
            Map userData = await getOneUserbyid(i['parent']);
            var a = commentsItem(userData: userData, data: i,);
            setState(() {
              allRatings.add(a);
            });
            totalReview += 1;
          }
        }
        if(allReviews.last == i){
          setState(() {
            isHide = false;
            norating = false;
          });
          if(allRatings.isEmpty){
            setState(() {
              noReview = true;
            });
          }
        }
      }

    }
    else{
      setState(() {
        isHide= false;
        norating = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: !norating && !isHide,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 0.0,
                  color: morelightWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        mainText((totalRating/noOfRating).toStringAsFixed(2), textColor, 30.0, FontWeight.bold, 1),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RatingStars(
                              starSize: 25,
                              maxValueVisibility: false,
                              valueLabelVisibility: false,
                              starColor: oneCardColor,
                              value: double.parse((totalRating/noOfRating).toStringAsFixed(2)),
                            ),
                            onlymainText(" based on $noOfRating rating", Colors.grey, 10.0, FontWeight.normal, 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !noReview,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          mainTextFAQS("Reviews",textColor, 15.0, FontWeight.bold,1),
                          Spacer(),
                        ],
                      ),
                      Column(
                        children: allRatings,
                      ),

                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: noReview,
                  child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: mainText("No Review for this tutor", secColor, 15.0, FontWeight.bold, 1)))

            ],
          ),
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
        Visibility(
            visible: norating && !isHide,
            child: Column(
              children: [
                Image.asset("Assets/notfound.png",width: 140.0,),
                mainText("No Review for this Tutor", secColor, 10.0, FontWeight.bold, 1)
              ],
            )),
      ],
    );
  }


}




class assignedtutorCard extends StatefulWidget {
  Map data;
  assignedtutorCard({Key? key,required this.data}) : super(key: key);

  @override
  State<assignedtutorCard> createState() => _assignedtutorCardState();
}

class _assignedtutorCardState extends State<assignedtutorCard> {
  int age = 0;
  List<Widget> allSubs = [];


  @override
  void initState() {
    getUpdates();
  }

  getUpdates(){
    DateTime dob = DateTime.parse(widget.data['dob']);
    setState(() {
      age = calculateAge(dob);
    });
    getSubjects();
  }

  getSubjects() async {
    List subs = jsonDecode(widget.data['subject']);
    for(var i in subs){
      var a = smallbtnsss(stateofHomeScreen.widget.subjectData[i]['title'], () { }, lightWhite,Colors.grey);
      setState(() {
        allSubs.add(a);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatars(widget.data['photo_url'], 0, "", 50.0),
              SizedBox(height: 10.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mainText(widget.data['name'], textColor, 25.0, FontWeight.bold, 1),
                  // Icon(Iconsax.verify,color: secColor,),
                ],
              ),
              SizedBox(height: 0.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mainText(widget.data['gender'] + ", ", Colors.grey, 10.0, FontWeight.normal, 1),
                  mainText("$age years", Colors.grey, 10.0, FontWeight.normal, 1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.verify,color: secColor,size: 15.0,),
                  mainText(" verified tutor", secColor, 10.0, FontWeight.normal, 1),
                ],
              ),
              SizedBox(height: 10.0,),
              Wrap(
                children: allSubs,
                spacing: 3.0,
                runSpacing: 10.0,
                alignment: WrapAlignment.center,
              ),

            ],),
        ),
      ),
    );
  }
}




class commentsItem extends StatefulWidget {
  Map data;
  Map userData;
  commentsItem({Key? key,required this.data,required this.userData}) : super(key: key);

  @override
  State<commentsItem> createState() => _commentsItemState();
}

class _commentsItemState extends State<commentsItem> {
  double rating = 0.0;
  String date = "";
  @override
  void initState() {
    setState(() {
      rating = double.parse(widget.data['rating']);
      date = DateFormat("d MMM yyyy").format(DateTime.parse(widget.data['creation']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        color: morelightWhite,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  mainText(rating.toString() + " ",textColor , 10.0, FontWeight.bold, 1),
                  RatingStars(
                    starSize: 10,
                    maxValueVisibility: false,
                    valueLabelVisibility: false,
                    starColor: oneCardColor,
                    value: rating,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: mainTextFAQS(widget.data['review'], textLight, 10.0, FontWeight.normal, 10)),
                ],
              ),
              onlymainText(date, Colors.grey, 10.0, FontWeight.normal, 10),
            ],
          ),
        ),
      ),
    );
  }
}



