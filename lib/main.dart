import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'package:student/Auth/EnterMobile.dart';
import 'package:student/Auth/EnterOTP.dart';
import 'package:student/Auth/WelcomeScreen.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/GetStarted/GetStarted.dart';
import 'package:student/GetStarted/UserType.dart';
import 'package:student/SWOT/OneSWOT.dart';
import 'package:student/Tutor/TutorSliders.dart';
import 'package:student/Usefull/Functions.dart';
import 'package:student/phoneOTPVerification.dart';
import 'OnBoarding/OnboardingCarousal.dart';
import 'Usefull/Colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: const FirebaseOptions(
      //     apiKey: "AIzaSyD-9NAetPJPYPdjklcrn4IUIJgd1zPRXls",
      //     authDomain: "project-i-1e130.firebaseapp.com",
      //     projectId: "project-i-1e130",
      //     storageBucket: "project-i-1e130.appspot.com",
      //     messagingSenderId: "402542887500",
      //     appId: "1:402542887500:web:6f1cb6147f2dffb0f22ae9",
      //     measurementId: "G-JF63V3XR31"
      // )
  );
  runApp(MaterialApp(
    home: splash(),
    // home: PhoneOTPVerification(),
    // home: oneSwot(),
    // home: userType(),
    // home: TutorSlider(),
    // home: getStarted(),
    // home: otp(number: "9493092309", vId: ""),
    // home: welcomeScreen(),
  ));
}

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getdd();
    Future.delayed(Duration(seconds: 3),(){
      check();
    });
  }

  check() async{
    FirebaseAuth user = FirebaseAuth.instance;
    if(user.currentUser != null){
      checker(_auth.currentUser!.uid, context);
    }
    else{
      navScreen(onBoardingCarousal(), context, false);
    }
  }

  getdd() async{
    await OneSignal.shared.setAppId(oneSignalID);
    await OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {
      print("accepted");
    });
    OneSignal.shared.setSubscriptionObserver((changes) {
      print("hello");
      print(changes);
    });
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    String device = osUserID.toString();
    print('device');
    print(device);
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  children: [
                    Spacer(),
                    Image.asset("Assets/icon.png",width: 90.0,),
                    Spacer(),
                  ],
                ),

                // Row(
                //   children: [
                //     Spacer(),
                //     Image.asset('Assets/ilogo.png',width: 60.0,color: mainColor,),
                //     // mainText(" be one", mainColor, 25.0, FontWeight.normal, 1),
                //     Spacer(),
                //   ],
                // ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  
}

