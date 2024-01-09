import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cherry_toast/cherry_toast.dart' as cherry;
import 'package:lottie/lottie.dart';









// Color mainColor = Color(0xFF8000FF);
// Color secColor = Color(0xFF982BFF);

Color mainColor = Color(0xFF264588);
Color lightmainColor = Color(0xFF3257A6);
Color secColor = Color(0xFF01A0E2);
Color lightsecColor = Color(0xFF47C8FF);

Color bgColor = Color(0xFFF6F8FE);

// Color bgColor = Color(0xFFEADBFF);
Color textColor = Color(0xFF262626);
Color textLight = Color(0xFF3A3A3A);

Color errorColor = Color(0xFFDC0000);


Color oneCardColor =   Color(0xFFFAA542);
Color oneCardCircleColor = Color(0xFFC47800);

    Color transparent_overlay = Color(0xFFFFFF);
Color lightGrenn = Color(0xA3BCFFAB);
Color lightRed = Color(0xA3FF8A8A);

Color verylightGrenn = Color(0xA3D8FFCD);


Color redColor = Color(0xFFFF0062);

Color greenColor = Color(0xFF5DDD93);

Color lightWhite = Color(0xFFF1F1F1);
Color morelightWhite = Color(0xFFFAFAFA);
Color superTransparent = Color(0x11FAFAFA);

List allColors = [
  Color(0xFF633974),
  Color(0xFF1A5276),
  Color(0xFF21618C),
  Color(0xFF117864),
  Color(0xFF0E6655),
  Color(0xFF196F3D),
  Color(0xFF1D8348),
  Color(0xFF9A7D0A),
  Color(0xFF9C640C),
  Color(0xFF935116),
  Color(0xFF873600),
  Color(0xFF7B241C),
  Color(0xFF943126),
  Color(0xFFBA4A00),
  Color(0xFFCA6F1E),
  Color(0xFFD68910),
  Color(0xFFD4AC0D),
  Color(0xFF28B463),
  Color(0xFF229954),
  Color(0xFF138D75),
  Color(0xFF17A589),
  Color(0xFF5B2C6F),
  Color(0xFF2E86C1),
  Color(0xFF2471A3),
  Color(0xFF7D3C98),
  Color(0xFF884EA0),
  Color(0xFFCB4335),
  Color(0xFFA93226),
  Color(0xFFD35400),
  Color(0xFFE67E22),
  Color(0xFFF39C12),
  Color(0xFFF1C40F),
  Color(0xFF2ECC71),
  Color(0xFF27AE60),
  Color(0xFF1ABC9C),
  Color(0xFF3498DB),
];

List goodColors = [
  Color(0xFF2E86C1),
  Color(0xFF2471A3),
  Color(0xFF7D3C98),
  Color(0xFF884EA0),
  Color(0xFFCB4335),
  Color(0xFFA93226),
  Color(0xFFD35400),
  Color(0xFFE67E22),
  Color(0xFFF39C12),
  Color(0xFFF1C40F),
  Color(0xFF2ECC71),
  Color(0xFF27AE60),
  Color(0xFF1ABC9C),
  Color(0xFF3498DB),
];




String mainFont = 'mons';


EdgeInsetsGeometry mainPadding = EdgeInsets.symmetric(horizontal: 25.0,vertical: 25.0);

//TEXTS...

AutoSizeText mainText(String text, Color c, double size, FontWeight w,int lines) {
  return AutoSizeText(
    text,
    textAlign: TextAlign.center,
    maxLines: lines,
    style: TextStyle(
      color: c,
      letterSpacing: 0.5,
      fontSize: size,
      fontFamily: mainFont,
      fontWeight: w,
    ),
  );
}


Text onlymainText(String text, Color c, double size, FontWeight w,int lines) {
  return Text(
    text,
    maxLines: lines,
    style: TextStyle(
      color: c,
      letterSpacing: 0.5,
      fontSize: size,
      fontFamily: mainFont,
      fontWeight: w,
    ),
  );
}

Text onlymainTextCenter(String text, Color c, double size, FontWeight w, int lines) {
  return Text(

    text,
    textAlign: TextAlign.center,
    maxLines: lines,
    style: TextStyle(

      color: c,
      letterSpacing: 0.5,
      fontSize: size,
      fontFamily: mainFont,
      fontWeight: w,
    ),
  );
}


AutoSizeText mainTextFAQS(String text, Color c, double size, FontWeight w,int lines) {
  return AutoSizeText(
    text,
    textAlign: TextAlign.start,
    maxLines: lines,
    style: TextStyle(
      color: c,
      letterSpacing: 0.5,
      fontSize: size,
      fontFamily: mainFont,
      fontWeight: w,

    ),
  );
}

Text mainTextLeft(String text, Color c, double size, FontWeight w,int lines) {
  return Text(

    text,
    textAlign: TextAlign.start,
    maxLines: lines,
    softWrap: false,
    overflow: TextOverflow.fade,
    style: TextStyle(
      color: c,
      letterSpacing: 0.5,
      fontSize: size,
      fontFamily: mainFont,
      fontWeight: w,
    ),
  );
}


//LOADERS...

class loader extends StatelessWidget {
  String msg;
  Color bg;
  Color lc;
  BuildContext ctx;

  loader(
      {Key? key,
        this.msg = "",
        required this.bg,
        required this.lc,
        required this.ctx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(ctx).size.height,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        width: 130.0,
        height: 130.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          elevation: 10.0,
          child: Stack(
            children: [
              // custimBlur(context, Colors.white, 0.2, 20),
              Center(
                child: Column(
                  children: [
                    Lottie.asset("Assets/ani.json",
                      width: 100.0,
                      fit: BoxFit.cover,
                      frameRate: FrameRate.max,
                      repeat: true,
                      alignment: Alignment.center,
                    ),
                    onlymainTextCenter(msg, secColor, 10.0, FontWeight.normal, 1)
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


Widget loaderss(bool a,String msg,bool white,BuildContext context){

  Color bg = mainColor;
  Color lc = Colors.white;

  if(white){
    bg = Colors.white;
    lc = mainColor;
  }

  return Visibility(
      visible: a,
      child: Stack(
        children: [
          Visibility(
            visible: a,
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.withOpacity(0.1),
                alignment: Alignment.center,
              ),
            ),
          ),
          Visibility(visible: a, child: loader(msg: msg,bg: bg,lc: lc,ctx: context,))
        ],
      ));
}



//MESSAGES

void Snacker(String title,GlobalKey<ScaffoldMessengerState> aa){
  final snackBar = SnackBar(
      elevation: 0,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: secColor,
      content:Text(title) );
  aa.currentState?.showSnackBar(snackBar);
  // messangerKey.currentState?.showSnackBar(snackBar);
}

void snacker(String s, BuildContext c){
  ScaffoldMessenger.of(c).showSnackBar(SnackBar(
      elevation: 0,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: secColor,
      content:
      Text(s)));
}

toaster(BuildContext context,String msg){

  cherry.CherryToast(
    themeColor: mainColor,
    backgroundColor: bgColor,
    icon: Iconsax.info_circle,
    shadowColor: textLight,

    iconColor: mainColor,
    title: onlymainText(msg, secColor, 13.0
        , FontWeight.bold, 2),
    animationDuration: Duration(milliseconds: 300),
    toastDuration: Duration(milliseconds: 2000),
  ).show(context);

  // Fluttertoast.showToast(msg: msg,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     textColor: Colors.white,
  //     backgroundColor: mainColor);

}



Image logImg(double x){
  return Image(
    image: const AssetImage('Assets/map.png'),
    width: x,
    height: x,
  );
}

List allAvatars = ['Assets/1.jpg','Assets/2.jpg'];

Widget profileAvatar(
    String img, int index, String file, double radius, VoidCallback callback) {
  if (file != "") {
    return Container(
      height: radius * 2,
      width: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: mainColor,
            child: ClipOval(
                child: Image.file(
                  File(file),
                  fit: BoxFit.cover,
                )),
          ),
          Positioned(
              bottom: -10,
              right: -40,
              child: RawMaterialButton(
                onPressed: callback,
                child: Icon(
                  Iconsax.edit,
                  color: mainColor,
                ),
                fillColor: Colors.white,
                shape: CircleBorder(),
              ))
        ],
      ),
    );
  } else if (img.length > 10 && img != "null") {
    return Container(
      height: radius * 2,
      width: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: mainColor,
            child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: img,
                  fit:BoxFit.cover,
                  placeholder: (context, url) => shimmerCircle(context, radius),
                )),
          ),
          Positioned(
              bottom: -10,
              right: -40,
              child: RawMaterialButton(
                onPressed: callback,
                child: Icon(
                  Iconsax.edit,
                  color: mainColor,
                ),
                fillColor: Colors.white,
                shape: CircleBorder(),
              ))
        ],
      ),
    );
  } else {
    return Container(
      height: radius * 2,
      width: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            radius: radius,
            child: ClipOval(
              child: Image.asset(
                allAvatars[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              bottom: -10,
              right: -40,
              child: RawMaterialButton(
                onPressed: callback,
                child: Icon(
                  Iconsax.edit,
                  color: mainColor,
                ),
                fillColor: Colors.white,
                shape: CircleBorder(),
              ))
        ],
      ),
    );
  }
}
Widget Avatars(
    String img,
    int index,
    String file,
    double radius,
    ) {
  if (img.length > 10 && img != "null") {
    return CircleAvatar(
      radius: radius,
      backgroundColor: mainColor,
      child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: img,
            fit:BoxFit.cover,
            placeholder: (context, url) => shimmerCircle(context, radius),
          )),
    );
  } else if (file != "") {
    return Container(
      height: radius * 2,
      width: radius * 2,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: mainColor,
            child: ClipOval(
                child: Image.file(
                  File(file),
                  fit: BoxFit.cover,
                )),
          ),
        ],
      ),
    );
  } else {
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.asset(
          allAvatars[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Widget shimmerCircle(BuildContext context,double r){
  return Shimmer.fromColors(
      baseColor: lightWhite,
      highlightColor: secColor,
      child: CircleAvatar(
        radius: r,
        backgroundColor: lightWhite,
        child: ClipOval(),
      )
  );
}


Widget notFound(bool a,String msg,BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height,
    alignment: Alignment.center,
    child: Visibility(
      visible: a,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('Assets/nf.png',width: 150.0,),
          mainText(msg, mainColor, 10.0, FontWeight.normal, 1),
        ],
      ),
    ),
  );
}

Widget India(double w){
  return Image.asset('Assets/mii.png',width: w,);
}

bottoms(BuildContext ctx,Widget w){
  showBarModalBottomSheet(context: ctx,

      builder: (context){
    return Container(
      // height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
      child: w,
    );
  });
}



newbottoms(BuildContext ctx,Widget w){

  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: ctx,
      isScrollControlled: true,
      builder: (context) =>
      Padding(
      padding: EdgeInsets.only(
  bottom: MediaQuery.of(context).viewInsets.bottom),
  child:Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
      child: w)));
}


Widget appLogo(double radius,){
    return CircleAvatar(
      radius: radius,
      backgroundColor: mainColor,
      child: ClipOval(
          child: Image.asset(
            "Assets/logo.png",
            fit:BoxFit.cover,
          )
      ),
    );
}

class notiswitch extends StatefulWidget {
  notiswitch({Key? key}) : super(key: key);

  @override
  State<notiswitch> createState() => _notiswitchState();
}

class _notiswitchState extends State<notiswitch> {

  late SharedPreferences prefs;
  bool textnoti = true;

  @override
  void initState() {
    getValues();
  }

  getValues() async{
    prefs = await SharedPreferences.getInstance();

    if(prefs.getBool('tN') != null){
      final bool? tN = prefs.getBool('tN',);
      print(tN);
      setState(() {
        textnoti = tN!;
      });
    }
    else{
      setState(() {
        textnoti = true;
      });
    }

    //////////////////////////////////////////////////////


  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      // thumb color (round icon)
      activeColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey,
      splashRadius: 50.0,
      // boolean variable value
      value: textnoti,
      // changes the state of the switch
      onChanged: (value) {
        setState(() {
          textnoti = value;
          nasyn(value);

        });
      },
    );
  }

  void nasyn(bool a) async{
    await prefs.setBool('tN',a);
    await OneSignal.shared.disablePush(!a);

  }

}

Widget circles(BuildContext context,Color c){
  return Stack(
    clipBehavior: Clip.hardEdge, children: [
    Container(
      // margin: EdgeInsets.only(),

      child:
      Transform.translate(
        offset: Offset(
          -70.0,
          -120.0,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 130.0,
        ),
      ),
    ),
    Container(
      // margin: EdgeInsets.only(),

      child:
      Transform.translate(
        offset: Offset(
          MediaQuery.of(context).size.width - 200.0,
          MediaQuery.of(context).size.height - 200.0,
        ),
        child: CircleAvatar(
          backgroundColor: c,
          radius: 130.0,
        ),
      ),
    ),

  ],
  );
}


Widget Blur(BuildContext context,double x){
  return BackdropFilter(filter: ImageFilter.blur(sigmaX:x, sigmaY: x),
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.withOpacity(0.1),
      alignment: Alignment.center,
    ),
  );
}
Widget custimBlur(BuildContext context,Color c, double o,double x){
  return BackdropFilter(filter: ImageFilter.blur(sigmaX:x, sigmaY: x),
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      color: c.withOpacity(o),
    ),
  );
}



AutoSizeText fontmainText(String text, Color c, double size, FontWeight w,int lines,String font) {
  return AutoSizeText(
    text,
    textAlign: TextAlign.center,
    maxLines: lines,
    style: TextStyle(
      color: c,
      letterSpacing: 0.5,
      fontSize: size,
      fontFamily: font,
      fontWeight: w,
    ),
  );
}

Widget customNotFound(bool a,String msg,String img,BuildContext context,Widget aa){
  return Container(
    height: MediaQuery.of(context).size.height,
    alignment: Alignment.center,
    child: Visibility(
      visible: a,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img,width: 200.0,),
          mainText(msg, mainColor, 10.0, FontWeight.normal, 1),
          aa,
        ],
      ),
    ),
  );
}
Widget BadgeMaker(String badge,double w){
  return Transform.rotate(
      angle: 0,
      child: Container(
        width: w,
        height: w,
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                child: Image.asset("Assets/badge.png",width: w,)),
            Center(child: mainText(badge, Colors.white, 15.0, FontWeight.bold, 1)),
          ],
        ),
      ));
}





