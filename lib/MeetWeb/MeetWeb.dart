import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dio/dio.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:student/Usefull/Colors.dart';







class meetWeb extends StatefulWidget {
  String url;
  meetWeb({Key? key,required this.url}) : super(key: key);

  @override
  State<meetWeb> createState() => _meetWebState();
}

class _meetWebState extends State<meetWeb> {
  late InAppWebViewController _viewController;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isHide = true;


  @override
  void initState() {
    CheckChange();
    updatePermission();
  }

  updatePermission() async{
    await Permission.camera.request();
    await Permission.microphone.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                // initialFile: widget.url,

                initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                ),
                // navigationDelegate: (NavigationRequest request) {
                //   if (request.url.toString() == "https://meet.tdpvista.com:3000/newcall") {
                //     print("ho gya");
                //     return w.NavigationDecision.prevent;
                //   }
                //   else{
                //     return w.NavigationDecision.navigate;
                //
                //   }
                // },
                androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
                  return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                },
                onWebViewCreated: (InAppWebViewController controller) {
                  _viewController = controller;
                  setState(() {
                    isHide = false;
                  });
                },

              ),

              loaderss(isHide, "Please Wait", true, context)


            ],
          ),
        ),
      ),
    );
  }


  CheckChange(){
    bool hello = true;
    print("kem choo");
    if(hello) {
      Timer.periodic(Duration(seconds: 3), (timer) {
        _viewController.getUrl().then((value) =>
        {
          print("Batman ${value.toString()}"),
          if(value.toString() == "https://meet.tdpvista.com/newcall"){
            setState(() {
              isHide = true;
              hello = false;
              Navigator.pop(context);
            })
          }
        });
      });
    }
  }






}

