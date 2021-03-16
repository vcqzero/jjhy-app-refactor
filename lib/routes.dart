import 'package:app/main.dart';
import 'package:app/pages/about/Index.dart';
import 'package:app/pages/login/Index.dart';
import 'package:app/pages/profile/Settings.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  /// 主页面
  MainPage.routeName: (context) => MainPage(),

  /// 设置页面
  SettingsPage.routeName: (context) => SettingsPage(),

  /// 登录页面
  LoginPage.routeName: (context) => LoginPage(),

  /// 关于我们
  AboutPage.routeName: (c) => AboutPage(),
};
