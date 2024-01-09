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

// import 'package:syncfusion_flutter_calendar/calendar.dart';



import '../Usefull/Colors.dart';




final _messangerKey = GlobalKey<ScaffoldMessengerState>();


class classSchedule extends StatefulWidget {
  List classData;
  classSchedule({Key? key,required this.classData}) : super(key: key);

  @override
  State<classSchedule> createState() => _classScheduleState();
}

class _classScheduleState extends State<classSchedule> {
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

  getAttendance() async{
    http.Response response = await http.post(Uri.parse(getAttendacneByParent),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'parent': stateofHomeScreen.userCode.toString(),
      }),
    );
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      Map aa = jsonDecode(response.body);
      List allAt = aa['attendance'];
      attendanceList = allAt;
      // makeEvents();
    }
  }


  makeEvents(){
    setState(() {
      int ii = 0;
      for(var i in widget.classData){
        DateTime n = DateTime.now();
        int hour = int.parse(i['time'].toString().split(":")[0]);
        int minute = int.parse(i['time'].toString().split(":")[1]);
        DateTime start = DateTime(n.year,n.month,n.day,hour,minute);
        int duration = int.parse((double.parse(i['duration'].toString().split(" ")[0]) * 60).toString().split(".")[0]);
        var a = NeatCleanCalendarEvent(stateofHomeScreen.widget.childData[i['child']]['name'] ,
            description: 'Tution',
            startTime: start,
            endTime: start.add(Duration(minutes: duration)),
            color: allColors[ii],
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
