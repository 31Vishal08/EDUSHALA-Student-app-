import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent/android_intent.dart';

import 'Colors.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

navScreen(Widget a,BuildContext context,bool replace){
  if(replace){
    Navigator.pushReplacement(context,MaterialPageRoute(builder:
        (context){
      return a;
    }));
  }
  else {
    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context){
      return a;
    }));
    // Navigator.push(context,rootN MaterialPageRoute(builder:
    //     (context) {
    //   return a;
    // }));
  }
}


String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

String generateRandomStringonly(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

Future<void> mailIt(String _url) async {
  if (!await launchUrl(Uri.parse('mailto:' + _url))) {
    throw 'Could not launch $_url';
  }
}

Future<void> callIt(String _url) async {
  if (!await launchUrl(Uri.parse('tel:' + _url))) {
    throw 'Could not launch $_url';
  }
}

LaunchIt(String _url) async {
  await launchUrl(Uri.parse(_url));
}

locationPermission(BuildContext c) async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    print('not');
    toaster(c,"Turn On Device Location to Use App");
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  } else {
    print("yo");
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}

Future<String?> getCurrenLocation(Map lat, Map lng) async {
  String id = "\$numberDecimal";
  double latc = double.parse(lat[id]);
  double lngc = double.parse(lng[id]);
  final coordinates = Coordinates(latc, lngc);
  var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var first = address.first;
  return first.addressLine;
}

Future<String?> getLocationString(double lat, double lng) async {
  double latc = double.parse(lat.toString());
  double lngc = double.parse(lng.toString());
  final coordinates = Coordinates(latc, lngc);
  var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var first = address.first;
  return first.addressLine;
}

Future<File> compressImage({
  required File image,
  int quality = 100,
  int percentage = 70,
}) async {
  var path = await FlutterNativeImage.compressImage(image.absolute.path,
      quality: quality, percentage: percentage);
  return path;
}


double radiusCalculate(lat1, lon1, lat2, lon2){
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 +
      c(lat1 * p) * c(lat2 * p) *
          (1 - c((lon2 - lon1) * p))/2;
  return 12742 * asin(sqrt(a));
}

calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}



