

import 'package:flutter/material.dart';
import 'package:student/Usefull/Colors.dart';

Future<bool> dialogs(BuildContext context,String title,
    String sub,String yes,String no,
    VoidCallback callback) async {
  return (await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      titleTextStyle:
      TextStyle(fontFamily: 'mons', fontSize: 15.0, color: textColor),
      contentTextStyle:
      TextStyle(fontFamily: 'mons', fontSize: 13.0, color: Colors.grey),
      alignment: Alignment.center,
      backgroundColor: Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: new Text(title),
      content: new Text(sub),
      actions: <Widget>[
        TextButton(
          onPressed: callback,
          child: new Text(
            yes,
            style: TextStyle(color: mainColor, fontFamily: 'mons'),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: new Text(
            no,
            style: TextStyle(color: mainColor, fontFamily: 'mons'),
          ),
        ),
      ],
    ),
  )) ?? false;
}