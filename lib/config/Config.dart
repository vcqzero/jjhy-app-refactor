import 'package:flutter/material.dart';

class Config {
  /// 应用名称
  static String appName = "京9";

  /// 默认头像图片
  static String defaultAvatar =
      'https://api.jjhycom.cn/storage/avatars/default.png';

  ///隐私条款url
  static String privacyUrl = 'https://api.jjhycom.cn/privacy';

  /// 接口baseUrl
  // static String baseUrl = 'https://api.jjhycom.cn';
  static String baseUrl = 'http://10.220.123.66:3000/';

  /// 页面背景色
  static Color pageBackgroudColor = Colors.grey.shade100;

  /// amap android key
  static String amapAndroidKey = '8259a4e186cfd2998ee767e49900b43a';
}
