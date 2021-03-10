import 'package:flutter/material.dart';

class MyWidgets {
  /// 获取appBar
  static getAppBar({bool hidden = false, String title = '标题'}) {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: hidden == true ? 0 : null,
      title: Text(title),
      centerTitle: true,
    );
  }

  static getOutlineButton({void Function()? onPressed, required String lable}) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
      ),
      onPressed: onPressed,
      child: Text(
        lable,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
