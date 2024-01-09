

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:student/Backend/backend.dart';
import 'package:student/Usefull/Backgrounds.dart';
import 'package:student/Usefull/Buttons.dart';
import 'package:iconsax/iconsax.dart';

import '../Usefull/Colors.dart';



final _messangerKey = GlobalKey<ScaffoldMessengerState>();


class otp extends StatefulWidget {
  String number;
  String vId;
  otp({Key? key,required this.number,required this.vId}) : super(key: key);

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  bool isHide = false;
  final formKey = GlobalKey<FormState>();
  Timer? _timer;
  String phone = "";
  String OTP = "";

  Color btnbg = bgColor;
  Color btntext = mainColor;

  bool resend = false;
  int _start = 30;
  String app_sign = "";

  FirebaseAuth _auth = FirebaseAuth.instance;

  var pinController = TextEditingController();
  final focusNode = FocusNode();

  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = new TextEditingController(text: "");


  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _getSignatureCode();
    _startListeningSms();
    // listner();
    phone = widget.number;
    setState(() {
      pinController = TextEditingController(text: '434332');
    });
  }

  // listner() async{
  //   await SmsAutoFill().listenForCode().then((value) {
  //     print("Listened");
  //
  //   });
  // }

  _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  /// listen sms
  _startListeningSms()  {
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        OTP = SmsVerification.getCode(message, intRegex);
        textEditingController.text = OTP;
        LoginwithOTP();
      });
    });
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            blurStyle: BlurStyle.outer
        ),
      ],
      color: bgColor,
      border: Border.all(color: bgColor,width: 0.0),
      borderRadius: BorderRadius.circular(7.0),
    );
  }



  @override
  Widget build(BuildContext context) {
    var fillColor = Colors.white;
    var borderColor = mainColor;


    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              bgcircles(context, secColor),
              Blur(context, 80),
              SingleChildScrollView(
                padding: mainPadding,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Iconsax.arrow_left,color: textColor,)),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 20.0,),
                    Row(
                      children: [
                        mainTextFAQS("OTP verification", textColor, 20.0, FontWeight.w700, 2),
                        Spacer(),
                      ],
                    ),

                    SizedBox(height: 50.0,),
                    Image.asset("Assets/otp.png",height: 150 ,),

                    SizedBox(height: 30.0,),

                    Row(
                      children: [
                        Spacer(),
                        onlymainText("code sent to ${widget.number}",textLight, 12.0, FontWeight.normal, 2),
                        Spacer(),
                      ],
                    ),

                    SizedBox(height:10.0,),

                    Form(
                      key: formKey,
                      child: (
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              TextFieldPin(
                                  textController: textEditingController,

                                  autoFocus: true,
                                  codeLength: 6,
                                  alignment: MainAxisAlignment.spaceEvenly,
                                  defaultBoxSize: 40.0,
                                  margin: 5,
                                  selectedBoxSize: 40.0,
                                  textStyle: TextStyle(fontSize: 16,fontFamily: 'mons'),
                                  defaultDecoration: _pinPutDecoration,
                                  selectedDecoration: _pinPutDecoration.copyWith(
                                    color: lightsecColor,
                                  ),

                                  onChange: (code) {
                                    setState(() {
                                      OTP = code;
                                      btnChanger(code);
                                    });
                                  }),

                              SizedBox(height: 10.0,),
                              Row(
                                children: [
                                  Spacer(),
                                  onlymainText("Didn't recive code", textLight, 12.0, FontWeight.normal, 1),

                                  Visibility(
                                      visible: !resend,
                                      child: TextButton(
                                          onPressed: (){

                                          },
                                          child: onlymainText("Resend Otp in $_start", mainColor, 12.0, FontWeight.normal, 1))),
                                  Visibility(
                                    visible: resend,
                                    child: TextButton(onPressed: (){
                                      resendotp();
                                    },
                                      child: onlymainText("Resend OTP", mainColor, 12.0, FontWeight.normal,1),),
                                  ),

                                  Spacer(),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50.0,
                                margin: EdgeInsets.fromLTRB(10, 20.0, 10.0,0.0),
                                child: custombtnsss("Verify", () {LoginwithOTP();}, secColor, bgColor,30.0),),



                            ],
                          )
                      ),
                    ),


                  ],
                ),
              ),

              loaderss(isHide,"Please Wait",true, context)
            ],
          ),
        ),
      ),
    );
  }



  Future LoginwithOTP() async{
    if(OTP.length == 6) {
      setState(() {
        isHide = true;
      });
      var _cred = PhoneAuthProvider.credential(
          verificationId: widget.vId,
          smsCode: OTP);
      _auth.signInWithCredential(_cred).then((value) =>
      {


        Future.delayed(const Duration(seconds: 1),(){
          checker(_auth.currentUser!.uid, context);
          // newChecker(context,_auth.currentUser!.uid);
        })


      }).catchError((e) {
        Snacker("Something Went Wrong", _messangerKey);
        setState(() {
          isHide = false;
        });
      });
    }
    else{
      Snacker("Please Enter OTP", _messangerKey);
    }
  }

  Future resendotp() async{
    if(formKey.currentState!.validate()){
      setState((){
        isHide = true;
      });
      print("Batman" + phone);
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: _onVerificationCompleted,
          verificationFailed: _onVerificationFailed,
          codeSent: _onCodeSent,
          codeAutoRetrievalTimeout: _onCodeTimeout);
    }
  }


  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      // this.otpCode.text = authCredential.smsCode!;
    });
    if (authCredential.smsCode != null) {
      try{
        UserCredential credential =
        await user!.linkWithCredential(authCredential);
      }on FirebaseAuthException catch(e){
        if(e.code == 'provider-already-linked'){
          await _auth.signInWithCredential(authCredential);
        }
      }
      setState(() {
        isHide = false;
      });
    }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      setState((){
        isHide = false;
      });
      Snacker("Please Enter an Valid Phone Number", _messangerKey);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    verificationId = verificationId;
    print(forceResendingToken);
    setState(() {
      isHide = false;
    });
    Snacker("OTP Sent Succesfully", _messangerKey);
  }

  _onCodeTimeout(String timeout) {
    return null;
  }


  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            if(_start <= 1){
              resend = true;
            }
          });
        }
      },
    );
  }

  void btnChanger (String a){
    if(a.isEmpty){
      setState((){
        btnbg = bgColor;
        btntext = mainColor;
      });    }
    else if(a.length < 6){
      setState((){
        btnbg = bgColor;
        btntext = mainColor;
      });
    }
    else if(a.length == 6){
      setState((){
        btnbg = mainColor;
        btntext = bgColor;
      });
    }
  }
}
