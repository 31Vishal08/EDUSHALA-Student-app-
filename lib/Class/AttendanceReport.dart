import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:iconsax/iconsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Homes/HomeScreen.dart';
import 'package:student/Homes/Homes.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Auth/EnterOTP.dart';
import 'package:student/Auth/RegisterNow.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:intl/intl.dart';

// import 'package:syncfusion_flutter_calendar/calendar.dart';



import '../Usefull/Colors.dart';




final _messangerKey = GlobalKey<ScaffoldMessengerState>();


class attendanceReport extends StatefulWidget {
  List attendanceData;
  Map childData;
  attendanceReport({Key? key,required this.attendanceData,required this.childData}) : super(key: key);

  @override
  State<attendanceReport> createState() => _attendanceReportState();
}

class _attendanceReportState extends State<attendanceReport> {
  bool isHide = false;
  final formKey = GlobalKey<FormState>();
  List<NeatCleanCalendarEvent> _eventList = [];


  FirebaseAuth _auth = FirebaseAuth.instance;
  List attendanceList = [];

  @override
  void initState() {
    // getAttendance();
    makeEvents();
  }

  // getAttendance() async{
  //   http.Response response = await http.post(Uri.parse(getAttendacneByParent),
  //     headers: <String,String>{
  //       'Content-Type': 'application/json; charset=UTF-8'
  //     },
  //     body: jsonEncode(<String, String>{
  //       'parent': stateofHomeScreen.userCode.toString(),
  //     }),
  //   );
  //   print(response.statusCode);
  //   print(response.body);
  //   if(response.statusCode == 200){
  //     Map aa = jsonDecode(response.body);
  //     List allAt = aa['attendance'];
  //     attendanceList = allAt;
  //     // makeEvents();
  //   }
  // }


  makeEvents(){
    print(widget.attendanceData);
    setState(() {
      int ii = 0;
      for(var i in widget.attendanceData){
        DateTime n = DateTime.now();
        String date = DateFormat("EEE, dd MMM yyyy").format(
            DateTime.parse(i['date']));
        DateTime start = DateTime.parse(i['date']);
          var a = NeatCleanCalendarEvent( date,
            description: widget.childData['name'],
            startTime: start,
            isAllDay: false,
            endTime: start,
            isDone: true,
            color: greenColor,
            isMultiDay: false);
        ii += 1;
        setState(() {
          _eventList.add(a);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              bgcircles(context, secColor),
              Blur(context, 80),
              Calendar(
                selectedTodayColor: secColor,
                startOnMonday: true,
                eventsList: _eventList,
                weekDays: ['Mon', 'Tue','Wed','Thus','Fri','Sat','Sun'],
                isExpandable: true,
                expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                datePickerType: DatePickerType.date,
              ),

              loaderss(isHide,"Please Wait",true, context)
            ],
          ),
        ),
      ),
    );
  }

}
