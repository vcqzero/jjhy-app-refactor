import 'package:flutter/material.dart';

class MyAppBar {
  static build({bool hidden = false, required String title}) {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: hidden == true ? 0 : null,
      title: Text(title),
      centerTitle: true,
    );
  }
}
