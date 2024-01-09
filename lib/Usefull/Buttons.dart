import 'package:flutter/material.dart';

import 'Colors.dart';
import 'package:iconsax/iconsax.dart';


double borderRadius = 10.0;

class custombtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;
  double borderRadius;

  custombtnsss(this.title,this.callback,this.main,this.text,this.borderRadius);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: mainText(
            title, text, 13.0, FontWeight.normal,1),
      ),
      style: ButtonStyle(
          foregroundColor:
          MaterialStateProperty.all<Color>(
              main),
          backgroundColor:
          MaterialStateProperty.all<Color>(main),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  side: BorderSide(color: main)))),
      onPressed: callback,
    );
  }
}
class iconbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;
  double borderRadius;
  IconData id;

  iconbtnsss(this.title,this.callback,this.main,this.text,this.borderRadius,this.id);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(id,color: text,),
            SizedBox(width: 10.0,),
            mainText(
                title, text, 13.0, FontWeight.normal,1),
          ],
        ),
      ),
      style: ButtonStyle(
          foregroundColor:
          MaterialStateProperty.all<Color>(
              main),
          backgroundColor:
          MaterialStateProperty.all<Color>(main),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  side: BorderSide(color: main)))),
      onPressed: callback,
    );
  }
}

class customborderbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;
  double borderRadius;

  customborderbtnsss(this.title,this.callback,this.main,this.text,this.borderRadius);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: mainText(
            title, text, 13.0, FontWeight.normal,1),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0.0),
          foregroundColor:
          MaterialStateProperty.all<Color>(
              main),
          backgroundColor:
          MaterialStateProperty.all<Color>(main),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  side: BorderSide(color: text,width: 2.0)))),
      onPressed: callback,
    );
  }
}


class btnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  btnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: mainText(
            title, text, 13.0, FontWeight.normal,1),
      ),
      style: ButtonStyle(
          foregroundColor:
          MaterialStateProperty.all<Color>(
              main),
          backgroundColor:
          MaterialStateProperty.all<Color>(main),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  side: BorderSide(color: main)))),
      onPressed: callback,
    );
  }
}

class borderbgbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  borderbgbtnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mainText(
                title, text, 13.0, FontWeight.normal,1),
          ],
        ),
      ),
      style: ButtonStyle(
          foregroundColor:
          MaterialStateProperty.all<Color>(
              main),
          backgroundColor:
          MaterialStateProperty.all<Color>(main),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  side: BorderSide(color: text,
                    width: 2.0
                  )))),
      onPressed: callback,
    );
  }
}


class fullbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  fullbtnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: Row(
          children: [
            Spacer(),
            mainText(
                title, text, 13.0, FontWeight.normal,1),
            Spacer()
          ],
        ),
      ),
      style: ButtonStyle(
          foregroundColor:
          MaterialStateProperty.all<Color>(
              main),
          backgroundColor:
          MaterialStateProperty.all<Color>(main),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  side: BorderSide(color: main)))),
      onPressed: callback,
    );
  }
}

class fullBigbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  fullBigbtnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
          child: Row(
            children: [
              Spacer(),
              mainText(
                  title, text, 15.0, FontWeight.normal,1),
              Spacer()
            ],
          ),
        ),
        style: ButtonStyle(
            foregroundColor:
            MaterialStateProperty.all<Color>(
                main),
            backgroundColor:
            MaterialStateProperty.all<Color>(main),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0),
                    side: BorderSide(color: text,
                    width: 2.0
                    )))),
        onPressed: callback,
      ),
    );
  }
}

class fullborderbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;
  Widget icon;

  fullborderbtnsss(this.title,this.callback,this.main,this.text,this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            children: [
              icon,
              SizedBox(width: 5.0,),
              mainText(
                  title, text, 15.0, FontWeight.normal,1),
              Spacer(),
            ],
          ),
        ),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            foregroundColor:
            MaterialStateProperty.all<Color>(
                transparent_overlay),
            backgroundColor:
            MaterialStateProperty.all<Color>(transparent_overlay),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0),
                    side: BorderSide(color: text,
                      width: 1.0,
                    )))),
        onPressed: callback,
      ),
    );
  }
}

class fullonlyborderbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  fullonlyborderbtnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            children: [
              Spacer(),
              mainText(
                  title, text, 15.0, FontWeight.normal,1),
              Spacer(),
            ],
          ),
        ),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            foregroundColor:
            MaterialStateProperty.all<Color>(
                transparent_overlay),
            backgroundColor:
            MaterialStateProperty.all<Color>(transparent_overlay),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0),
                    side: BorderSide(color: text,
                      width: 1.0,
                    )))),
        onPressed: callback,
      ),
    );
  }
}


class fullborderbtnssslocation extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;
  Widget icon;

  fullborderbtnssslocation(this.title,this.callback,this.main,this.text,this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Row(
            children: [
              icon,
              SizedBox(width: 5.0,),
              Expanded(
                child: mainTextFAQS(
                    title, text, 15.0, FontWeight.normal,2),
              ),
            ],
          ),
        ),
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            foregroundColor:
            MaterialStateProperty.all<Color>(
                transparent_overlay),
            backgroundColor:
            MaterialStateProperty.all<Color>(transparent_overlay),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0),
                    side: BorderSide(color: text,
                      width: 1.0,
                    )))),
        onPressed: callback,
      ),
    );
  }
}


class borderbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  borderbtnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: mainText(
            title, text, 13.0, FontWeight.normal,1),
      ),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0.0),
          foregroundColor:
          MaterialStateProperty.all<Color>(
              transparent_overlay),
          backgroundColor:
          MaterialStateProperty.all<Color>(transparent_overlay),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(borderRadius),
                  side: BorderSide(color: text,
                    width: 2.0,
                  )))),
      onPressed: callback,
    );
  }
}

class pdbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  pdbtnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      child: ElevatedButton(

        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
          child: Row(
            children: [
              Spacer(),
              mainText(
                  title.toUpperCase(), text, 13.0, FontWeight.normal,1),
              Spacer()
            ],
          ),
        ),
        style: ButtonStyle(
            foregroundColor:
            MaterialStateProperty.all<Color>(
                main),
            backgroundColor:
            MaterialStateProperty.all<Color>(main),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0),
                    side: BorderSide(color: main)))),
        onPressed: callback,
      ),
    );
  }
}


class kmbtnsss extends StatelessWidget {
  VoidCallback callback;
  String utitle;
  String title;
  Color main;
  Color text;

  kmbtnsss(this.title,this.utitle,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            onlymainText(utitle.toUpperCase(), textColor, 7.0, FontWeight.bold,1),
            mainTextFAQS(title.toUpperCase(), textColor, 15.0, FontWeight.bold,1),
            onlymainText("km away", textLight, 5.0, FontWeight.normal,1),
          ],
        ),
        style: ButtonStyle(
            foregroundColor:
            MaterialStateProperty.all<Color>(
                main),
            backgroundColor:
            MaterialStateProperty.all<Color>(main),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0),
                    side: BorderSide(color: main)))),
        onPressed: callback,
      ),
    );
  }
}


class circularBtn extends StatelessWidget {
  VoidCallback callback;
  IconData i;
  Color main;
  Color text;
  bool mini;

  circularBtn(this.i,this.callback,this.main,this.text,this.mini);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: main,
        mini: mini,
        child: Icon(i,color: text,),
        onPressed: callback);
  }
}

class smallbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;

  smallbtnsss(this.title,this.callback,this.main,this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      height: 20.0,
      child: ElevatedButton(
        
        child: Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
          child: onlymainText(
              title, text, 10.0, FontWeight.normal,1),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
            foregroundColor:
            MaterialStateProperty.all<Color>(
                main),
            backgroundColor:
            MaterialStateProperty.all<Color>(main),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                    side: BorderSide(color: main)))),
        onPressed: callback,
      ),
    );
  }
}

class newiconbtnsss extends StatelessWidget {
  VoidCallback callback;
  String title;
  Color main;
  Color text;
  IconData i;
  double r;

  newiconbtnsss(this.title,this.callback,this.main,this.text,this.i,this.r);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
        child: Row(
          children: [
            Spacer(),
            Icon(i,color: text,),
            SizedBox(width: 5.0,),
            onlymainText(
                title, text, 14.0, FontWeight.normal,1),
            Spacer(),
          ],
        ),
      ),
      style: ButtonStyle(
          foregroundColor:
          MaterialStateProperty.all<Color>(
              main),
          backgroundColor:
          MaterialStateProperty.all<Color>(main),
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(r),
                  side: BorderSide(color: main)))),
      onPressed: callback,
    );
  }
}





