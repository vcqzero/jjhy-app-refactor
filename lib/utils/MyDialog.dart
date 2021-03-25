import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog {
  BuildContext context;
  String title;
  List<Text>? textChildren;
  void Function()? onCancel;
  void Function()? onConfirm;

  MyDialog(
    this.context, {
    required this.title,
    required this.textChildren,
    this.onCancel,
    this.onConfirm,
  });
  open() {
    if (Platform.isAndroid) {
      _openAndroidStyleDialog();
    } else {
      _openIosStyleDialog();
    }
  }

  _openIosStyleDialog() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: textChildren != null
              ? SingleChildScrollView(
                  child: ListBody(
                  children: textChildren!,
                ))
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel!();
              },
            ),
            CupertinoDialogAction(
              child: Text('确认'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) onConfirm!();
              },
            ),
          ],
        );
      },
    );
  }

  _openAndroidStyleDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: textChildren != null
              ? SingleChildScrollView(
                  child: ListBody(
                  children: textChildren!,
                ))
              : null,
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancel != null) onCancel!();
              },
            ),
            TextButton(
              child: Text('确认'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) onConfirm!();
              },
            ),
          ],
        );
      },
    );
  }
}
