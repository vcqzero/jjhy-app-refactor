import 'package:flutter/material.dart';

class MyAppBar {
  static build({
    bool hidden = false,
    required String title,
    List<Widget>? actions,
    bool centerTitle = true,
    Widget? flexibleSpace,
    double? elevation,
  }) {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: hidden == true ? 0 : null,
      title: Text(title),
      centerTitle: centerTitle,
      actions: actions,
      flexibleSpace: flexibleSpace,
      elevation: elevation,
    );
  }
}
