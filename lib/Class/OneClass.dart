import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Chats/chatss.dart';
import 'package:student/Class/AttendanceReport.dart';
import 'package:student/Class/HolidayRequest.dart';
import 'package:student/Class/PTM.dart';
import 'package:student/Class/Review.dart';
import 'package:student/Homes/Children.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/MeetWeb/MeetWeb.dart';
import 'package:student/SWOT/SWOT.dart';
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






final _messangerKey = GlobalKey<ScaffoldMessengerState>();


late _oneClassState stateofOneClass;
class oneClass extends StatefulWidget {
  Map tutorData;
  Map classData;
  Map childData;
 oneClass({Key? key,required this.tutorData,required this.childData,required this.classData}) : super(key: key);


  @override
  State<oneClass> createState() {
    stateofOneClass = _oneClassState();
    return stateofOneClass;
  }
}

class _oneClassState extends State<oneClass> {
  bool isHide = false;
  final formKey = GlobalKey<FormState>();
  List<Widget> allAttendance = [];

  FirebaseAuth _auth = FirebaseAuth.instance;
  String qrString = "";
  List allDates = [];
  String meetLink = "";
  List<DateTime> classAttended = [];


  DateTime startDate = DateTime.now();
  DateTime lastWorkingDate = DateTime.now();
  int totalDays = 0;
  int remaining_days = 0;
  List allAttendanceData = [];
  List<Widget> holidayList = [];
  List<Widget> upcomingHolidays = [];

  int attendClass = 0;
  int totalClass = 0;
  Map currentAttendance = {};




  @override
  void initState() {
    getHoliday();
    makeQR();
    getAttendance();
    setState(() {
      meetLink = "https://meet.tdpvista.com/join/" + widget.classData['id'] + widget.classData['child'] + widget.classData['tutor'];
    });
  }

  getHoliday() async{
    setState(() {
      holidayList = [];
    });
    http.Response response = await http.post(Uri.parse(getHolidaybyAssignid),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'assigned': widget.classData['id'],
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      List hd = aa['holidays'];
      for(var i in hd) {
        if (i['request'] != "parent") {
          if (i['status'] == "pending") {
            var a = holidayRequest(data: i);
            setState(() {
              holidayList.add(a);
            });
          }
          else if (i['status'] == "approved") {
            print("approved");
            if (DateTime.parse(i['date']).isAfter(DateTime.now()) ||
                DateTime.parse(i['date']).isAtSameMomentAs(DateTime.now())) {
              var a = iconSmallCard(
                  title: DateFormat("EEE, dd MMM yyyy").format(startDate),
                  sub: "Upcoming Holiday",
                  iconData: Iconsax.calendar_tick,
                  bg: lightWhite,
                  texts: textLight);
              upcomingHolidays.add(a);
            }
          }
        }
        else{
          if (DateTime.parse(i['date']).isAfter(DateTime.now()) ||
              DateTime.parse(i['date']).isAtSameMomentAs(DateTime.now())) {
            var a = myholidayRequest(data: i);
            setState(() {
              holidayList.add(a);
            });

            if (i['status'] == "approved") {
              print("approved");
              if (DateTime.parse(i['date']).isAfter(DateTime.now()) ||
                  DateTime.parse(i['date']).isAtSameMomentAs(DateTime.now())) {
                var a = iconSmallCard(
                    title: DateFormat("EEE, dd MMM yyyy").format(startDate),
                    sub: "Upcoming Holiday",
                    iconData: Iconsax.calendar_tick,
                    bg: lightWhite,
                    texts: textLight);
                upcomingHolidays.add(a);
              }
            }
          }
        }
      }

    }
  }

  makeQR(){
    setState(() {
      qrString = stateofHomeScreen.userCode.toString() + "&" + widget.childData['id'].toString() + "&" + widget.classData['id']
          + "&" + DateTime.now().toString().split(" ")[0];
    });
  }

  getAttendance() async{
    setState(() {
      currentAttendance= {};
      classAttended = [];
      allDates = [];
      allAttendance = [];
      attendClass = 0;
    });
    http.Response response = await http.post(Uri.parse(getAttendacneByAssignId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'assigned': widget.classData['id'],
      }),
    );
    print(response.statusCode);
    print(response.body);
    double totalCredits = double.parse(widget.classData['credits']);
    double currentCredits = 0.0;

    totalClass = 4 * int.parse(widget.classData['frequency']);
    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      List allAt = aa['attendance'];
      for(var i in allAt){
        DateTime startDate = DateTime.parse(i['startdate']);
        if(i['date'] != "") {
          var a = attendanceCard(date: i['date'],data:i);
          classAttended.add(DateTime.parse(i['date']));


          setState(() {
            attendClass += 1;
            allDates.add(i['date']);
            allAttendance.add(a);
          });
          currentCredits += double.parse(i['credit']);
          if (allAt.last == i) {
            getDays();
          }
        }
        else{
          currentAttendance = i;
        }
      }
    }
    else{
      getDays();
      setState(() {
        totalClass = 4 * int.parse(widget.classData['frequency']);
        attendClass = 0;
      });
    }
  }

  getDays() async{

    startDate = DateTime.parse(widget.classData['start_date']);

    lastWorkingDate = getLastWorkingDay();
    setState(() {

    });
  }

  DateTime getLastWorkingDay(){
    DateTime r = startDate;
    if(classAttended.isNotEmpty) {
      for (var i in classAttended) {
        if (i.isAfter(startDate)) {
          r = i;
        }
      }
    }
    return r;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        home:Scaffold(
            backgroundColor: bgColor,
            body: Stack(
              children: [
                DraggableHome(
                    headerExpandedHeight: 0.45,
                    stretchMaxHeight: 0.55,
                    leading: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Iconsax.arrow_left_2,color: Colors.white,)),
                    alwaysShowLeadingAndAction: true,
                    title: mainText("Class",bgColor, 15.0, FontWeight.normal, 1),
                    appBarColor: secColor,
                    headerWidget: Container(
                      color: secColor,
                      child: Stack(
                        children: [
                          // bgcircles(context, bgColor),
                          // Blur(context, 80),
                          SafeArea(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Spacer(),
                                    Image.asset('Assets/VS/threevs.png',width: MediaQuery.of(context).size.width * 0.99,),
                                    Spacer(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),



                    body:[SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    mainTextFAQS("Class by", textLight, 30.0, FontWeight.bold, 1),
                                    mainTextFAQS(widget.tutorData['name'], textLight, 15.0,FontWeight.bold, 1),
                                    onlymainText(stateofHomeScreen.widget.gradesData[widget.childData['grade']]['title'] +
                                        " " + stateofHomeScreen.widget.gradesData[widget.childData['grade']]['board'], Colors.grey, 10.0, FontWeight.bold, 1),
                                  ],
                                ),
                              ),
                              IconButton(onPressed: (){
                                navScreen(chat(data: widget.tutorData), context, false);
                              }, icon: Icon(Iconsax.message,color: secColor,size: 30.0,)),
                              IconButton(onPressed: (){
                                showQR(qrString);
                              }, icon: Icon(Iconsax.barcode,color: secColor,size: 30.0,))
                            ],
                          ),

                          SizedBox(height: 20.0,),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            child: Row(
                              children: [
                                Row(
                                  children: upcomingHolidays,
                                ),
                                (classAttended.isNotEmpty)?iconSmallCard(title: DateFormat("EEE, dd MMM yyyy").format(lastWorkingDate),
                                    sub: "last class day", iconData: Iconsax.calendar_1, bg: lightWhite, texts: textLight):
                                iconSmallCard(title: DateFormat("EEE, dd MMM yyyy").format(startDate),
                                    sub: "first class", iconData: Iconsax.calendar_1, bg: lightWhite, texts: textLight),

                                iconSmallCard(title: "$attendClass",
                                    sub: "Class Done", iconData: Iconsax.calendar_circle, bg: lightWhite, texts: textLight),

                                iconSmallCard(title: "${totalClass - attendClass}",
                                    sub: "Classes left", iconData: Iconsax.calendar_tick, bg: lightWhite, texts: textLight)
                              ],
                            ),
                          ),

                          Visibility(
                              visible: holidayList.isNotEmpty,
                              child: ExpansionTile(
                                title: mainTextFAQS("${holidayList.length} Holiday Requests", mainColor, 15.0, FontWeight.bold, 1),
                                children: holidayList,
                              )),

                          testSection(),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60.0,
                            child: iconbtnsss("JOIN ONLINE CLASS", () {joinMeet();}, oneCardColor, Colors.white,15.0, Iconsax.screenmirroring,),
                          ),
                          SizedBox(height: 20.0,),

                          ExpansionTile(
                              title: Row(
                                children: [
                                  Expanded(child: mainTextFAQS("Attendance", textLight, 15.0, FontWeight.bold, 1)),
                                 TextButton(
                                     onPressed: (){
                                       navScreen(attendanceReport(attendanceData: allAttendanceData, childData: widget.childData), context, false);
                                       },
                                     child: onlymainText("view report", secColor, 10.0, FontWeight.normal, 1)),
                                ],
                              ),
                            // trailing: TextButton(
                            //     onPressed: (){
                            //
                            //     },
                            //     child: onlymainText("view report", textLight, 10.0, FontWeight.normal, 1)),
                            children: [
                              Column(
                                children: allAttendance,
                              ),
                            ],
                          ),

                          SizedBox(height: 10.0,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: newiconbtnsss("REQUEST HOLIDAY", () {
                              navScreen(oneholidayRequest(classData: widget.classData), context, false);
                            }, secColor, Colors.white, Iconsax.aquarius,15.0),
                          ),
                          SizedBox(height: 10.0,),


                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: newiconbtnsss("VIEW PTM", () {
                              navScreen(PTMs(data: widget.tutorData,classData: widget.classData,), context, false);
                            }, oneCardColor, Colors.white, Iconsax.grammerly,15.0),
                          ),
                          reviewSection(classData: widget.classData,tutorData: widget.tutorData,),

                          onemoreMoreCard(title: "Book Swot", sub: "Book SWOT for this class", image: "Assets/SWOT/swot2.png",
                            c: redColor, callback: (){
                              navScreen(swotSliders(classData: widget.classData,TutorData: widget.tutorData,), context, false);
                            },
                          ),

                        ],
                      ),
                    ),]
                ),
                loaderss(isHide, "Hold onnn", true, context),
              ],
            )
        )
    );
  }

  joinMeet() async{
    navScreen(meetWeb(url: meetLink), context, false);
    http.Response response = await http.post(Uri.parse(editAssignedUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id': widget.classData['id'],
        'childlive':'1'
      }),
    );
    print(response.statusCode);
    print(response.body);

  }

  Future<bool> showQR(String qrData) async {


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
            onlymainText("MY QR", textColor, 20.0, FontWeight.bold, 1),
            Spacer(),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Spacer(),
                onlymainText("Mark your attendance with this QR", textLight, 13.0, FontWeight.normal, 1),
                Spacer(),
              ],
            ),
            SizedBox(height: 10.0,),

            Container(
              width: 200.0,
              height: 200.0,
              child:


              QrImageView(
                foregroundColor: textColor,
                data:qrData,
                version: QrVersions.auto,
                size: 300.0,
              ),
            ),
          ],
        ),

      ),
    )) ?? false;
  }
}

class attendanceCard extends StatelessWidget {
  String date;
  Map data;
  attendanceCard({Key? key,required this.date,required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        color: lightWhite,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Iconsax.calendar_1,color: secColor,size: 40.0,),
              SizedBox(width: 10.0,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  onlymainText("Attendance Marked for", Colors.grey, 10.0, FontWeight.normal, 1),
                  mainTextFAQS(DateFormat("EEE, dd MMM yyyy").format(DateTime.parse(date)), textLight, 15.0, FontWeight.bold, 1),
                  Row(
                    children: [
                      mainTextFAQS("in ", secColor, 10.0, FontWeight.bold, 1),
                      mainTextFAQS(DateFormat("HH:mm").format(DateTime.parse(data['startdate'])), textLight, 10.0, FontWeight.bold, 1),
                      mainTextFAQS("  out ", secColor, 10.0, FontWeight.bold, 1),
                      mainTextFAQS(DateFormat("HH:mm").format(DateTime.parse(date)), textLight, 10.0, FontWeight.bold, 1),
                    ],
                  ),
                  Row(
                    children: [
                      mainTextFAQS("topic ", secColor, 10.0, FontWeight.bold, 1),
                      mainTextFAQS(data['topic'], textLight, 10.0, FontWeight.bold, 2),
                    ],
                  ),




                ],
              ),
            ],
          ),
        ),
      ),
    );


  }
}


class iconSmallCard extends StatelessWidget {
  String title;
  String sub;
  IconData iconData;
  Color bg;
  Color texts;
  iconSmallCard({Key? key,required this.title,required this.sub,
    required this.iconData,required this.bg,required this.texts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: bg,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(iconData,color: texts,size: 30.0,),
              SizedBox(width: 5.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainTextFAQS(title, texts, 10.0, FontWeight.bold, 1),
                  onlymainText(sub, texts, 10.0, FontWeight.normal, 1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class testSection extends StatefulWidget {
  const testSection({Key? key}) : super(key: key);

  @override
  State<testSection> createState() => _testSectionState();
}

class _testSectionState extends State<testSection> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
        ),
        elevation: 0.0,
        color: lightWhite,
        child: ExpansionTile(
          title: Column(
            children: [
              Row(
                children: [
                  mainTextFAQS("Upcoming Tests", mainColor, 20.0, FontWeight.bold, 1),
                  ],
              ),
              SizedBox(height: 10.0,),

            ],
          ),
          children: [allTests()],
        ),
      ),
    );
  }
}

late _allTestsState stateofAllTests;
class allTests extends StatefulWidget {
  const allTests({Key? key}) : super(key: key);

  @override
  State<allTests> createState() {
    stateofAllTests = _allTestsState();
    return stateofAllTests;
  }
}

class _allTestsState extends State<allTests> {
  bool isHide = false;
  bool notest = true;
  List<Widget> assignedTest = [];


  @override
  void initState() {
    getAssignedTest();
  }

  getAssignedTest() async{
    setState(() {
      isHide = true;
      assignedTest = [];
    });
    http.Response response = await http.post(Uri.parse(getAssigendTestByAssignedId),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'assigned': stateofOneClass.widget.classData['id'],
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map testData = jsonDecode(response.body);
      List oneTestData = testData['test'];
      for(var i in oneTestData) {
        Map oneTestData = await getAssignedTestData(i['test']);
        var a = assignedTestItem(data: i, testData: oneTestData);
        setState(() {
          isHide = false;
          notest = false;
          assignedTest.add(a);
        });
      }
    }
    else{
      setState(() {
        isHide= false;
        notest = true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: assignedTest,
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
            visible: !isHide && notest,
            child: mainText("No Upcoming Test found", textLight, 15.0, FontWeight.bold, 1)),
      ],
    );
  }
}




class assignedTestItem extends StatefulWidget {
  Map data;
  Map testData;
  assignedTestItem({Key? key,required this.data,required this.testData}) : super(key: key);

  @override
  State<assignedTestItem> createState() => _assignedTestItemState();
}

class _assignedTestItemState extends State<assignedTestItem> {
  bool attempt = false;
  bool submit = false;
  bool approve = false;


  @override
  void initState() {
    setState(() {
      attempt = widget.data['status'] == 'attempt';
      submit = widget.data['status'] == 'submit';
      approve = widget.data['status'] == 'approved';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      // height: MediaQuery.of(context).size.height * 0.20,
      child: Card(
        elevation: 0.0,
        color:Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
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
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                mainTextFAQS(widget.testData['title'], textColor, 20.0, FontWeight.bold, 2),
                                Row(
                                  children: [
                                    Icon(Iconsax.building_3,color: Colors.grey,),
                                    onlymainText("${stateofHomeScreen.widget.gradesData[widget.testData['grade']]['title']} "
                                        "${stateofHomeScreen.widget.gradesData[widget.testData['grade']]['board']}", Colors.grey, 10.0, FontWeight.normal, 1),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Iconsax.teacher,color: Colors.grey,),
                                    onlymainText("${stateofHomeScreen.widget.subjectData[widget.testData['subject']]['title']}"
                                        , Colors.grey, 10.0, FontWeight.normal, 1),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            elevation: 0.0,
                            color: secColor,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: onlymainText("${widget.testData['mode']}"
                                  , Colors.white, 15.0, FontWeight.bold, 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Icon(Iconsax.calendar,color: textLight,),
                          onlymainText("${DateFormat("EEEE dd MMM yyyy").format(DateTime.parse(widget.data['date']))}"
                              , textLight, 15.0, FontWeight.normal, 1),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Iconsax.clock,color: textLight,),
                          onlymainText("${widget.data['time']}"
                              , textLight, 15.0, FontWeight.normal, 1),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Iconsax.timer_1,color: textLight,),
                          onlymainText("${widget.data['duration']} minutes"
                              , textLight, 15.0, FontWeight.normal, 1),
                        ],
                      ),

                      Visibility(
                        visible: widget.testData['mode'] == "mcq",
                        child: Column(
                          children: [
                            Visibility(
                              visible: !attempt && !submit,
                              child: Container(
                                height: 40.0,
                                margin: EdgeInsets.only(top: 10.0),
                                child: iconbtnsss("ATTEMPT", () {navScreen(oneTest(data: widget.data, testData: widget.testData),
                                    context, false); }, greenColor, Colors.white, 10.0, Iconsax.tick_circle),
                              ),
                            ),

                            Visibility(
                              visible: attempt,
                              child: Container(
                                height: 40.0,
                                margin: EdgeInsets.only(top: 10.0),
                                child: iconbtnsss("ATTEMPTED", () {toaster(context, "You Have Already Attempted");},
                                    oneCardColor, Colors.white, 10.0, Iconsax.arrow_up),
                              ),
                            ),

                            Visibility(
                              visible: submit,
                              child: Container(
                                height: 40.0,
                                margin: EdgeInsets.only(top: 10.0),
                                child: iconbtnsss("VIEW REPORT", () {
                                  navScreen(testReport(data: widget.data, testData: widget.testData), context, false);
                                },
                                    secColor, Colors.white, 10.0, Iconsax.book),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: widget.testData['mode'] != "mcq",
                        child: Column(
                          children: [
                            Visibility(
                              visible: !submit && !approve,
                              child: Container(
                                height: 40.0,
                                margin: EdgeInsets.only(top: 10.0),
                                child: iconbtnsss("ATTEMPT", () {navScreen(oneTest(data: widget.data, testData: widget.testData),
                                    context, false); }, greenColor, Colors.white, 10.0, Iconsax.tick_circle),
                              ),
                            ),

                            Visibility(
                              visible: attempt,
                              child: Container(
                                height: 40.0,
                                margin: EdgeInsets.only(top: 10.0),
                                child: iconbtnsss("ATTEMPTED", () {toaster(context, "You Have Already Attempted");},
                                    oneCardColor, Colors.white, 10.0, Iconsax.arrow_up),
                              ),
                            ),

                            Visibility(
                              visible: submit,
                              child: Container(
                                height: 40.0,
                                margin: EdgeInsets.only(top: 10.0),
                                child: iconbtnsss("SUBMITTED", () {
                                  toaster(context, "Test Submitted waiting for report");
                                },
                                    oneCardColor, Colors.white, 10.0, Iconsax.book),
                              ),
                            ),
                            Visibility(
                              visible: approve,
                              child: Container(
                                height: 40.0,
                                margin: EdgeInsets.only(top: 10.0),
                                child: iconbtnsss("VIEW REPORT", () {
                                  navScreen(PDFtestReport(data: widget.data, testData: widget.testData), context, false);
                                },
                                    secColor, Colors.white, 10.0, Iconsax.book),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class holidayRequest extends StatelessWidget {
  Map data;
  holidayRequest({Key? key,required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.0,
        color: lightWhite,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              mainTextFAQS("by ${data['request']}", Colors.grey, 10.0, FontWeight.normal, 1),
              mainTextFAQS("Reason", Colors.grey, 10.0, FontWeight.normal, 1),
              mainTextFAQS(data['reason'], textLight, 15.0, FontWeight.bold, 1),
              SizedBox(height: 10.0,),
              mainTextFAQS("Date", Colors.grey, 10.0, FontWeight.normal, 1),
              mainTextFAQS(DateFormat("EEE dd MMM yyyy").format(DateTime.parse(data['date'])), textLight, 15.0, FontWeight.bold, 1),
            SizedBox(height: 10.0,),
              Row(
                children: [
                  Expanded(
                    child: custombtnsss("Approve",(){
                      approveRequest();
                    },greenColor,Colors.white,10.0),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: custombtnsss("Reject",(){
                      rejectRequest();
                    },redColor,Colors.white,10.0),
                  ),
                ],
              ),
            ],

          ),

        ),
      ),

    );
  }

  approveRequest() async{
    http.Response response = await http.post(Uri.parse(updateHolidayUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id': data['id'],
        'status':'approved',
        'allowedby':'parent',
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      // toaster(context, "Holiday request Approved");
      stateofOneClass.getHoliday();
    }
  }
  rejectRequest() async{
    http.Response response = await http.post(Uri.parse(updateHolidayUrl),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'id': data['id'],
        'status':'reject',
        'allowedby':'parent',
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      // toaster(context, "Holiday request Approved");
      stateofOneClass.getHoliday();
    }
  }
}

class myholidayRequest extends StatelessWidget {
  Map data;
  myholidayRequest({Key? key,required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.0,
        color: (data['status'] == "pending")?oneCardColor:(data['status'] == "reject")?redColor:greenColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainTextFAQS((data['status'] == "pending")?"pending":(data['status'] == "reject")?"rejected":"Approved",
                  Colors.white, 10.0, FontWeight.normal, 1),
              mainTextFAQS("by ${data['request']}", Colors.white, 10.0, FontWeight.normal, 1),
              mainTextFAQS(data['reason'], textLight, 15.0, FontWeight.bold, 1),
              mainTextFAQS(DateFormat("EEE dd MMM yyyy").format(DateTime.parse(data['date'])), textLight, 15.0, FontWeight.bold, 1),

            ],

          ),

        ),
      ),

    );
  }
}

class oneMoreCard extends StatelessWidget {
  Icon icon;
  String title;
  String sub;
  String image;
  Color c;
  VoidCallback callback;
  oneMoreCard({Key? key,required this.icon,required this.title,
    required this.sub,required this.image,required this.c,required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: c,
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(image,height: 70.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mainText(title, Colors.white, 20.0, FontWeight.bold, 1),
                    Row(
                      children: [
                        Expanded(child: onlymainTextCenter(sub, Colors.white, 10.0, FontWeight.normal, 1)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class onemoreMoreCard extends StatelessWidget {
  String title;
  String sub;
  String image;
  Color c;
  VoidCallback callback;
  onemoreMoreCard({Key? key,required this.title,
    required this.sub,required this.image,required this.c,required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        child: Card(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  width: 200.0,
                  child: Image.asset(image,alignment: Alignment.center,width: 200.0,)),
              custimBlur(context, c, 0.6, 5.0),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          mainText(title, Colors.white, 30.0, FontWeight.bold, 1),
                          onlymainText(sub, Colors.white, 10.0, FontWeight.normal, 1),
                        ],
                      ),
                    ),
                    Image.asset(image,height: 200.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





