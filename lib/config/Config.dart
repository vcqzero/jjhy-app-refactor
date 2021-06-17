import 'package:app/utils/MyMode.dart';
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
  static String baseUrlProduction = 'https://api.jjhycom.cn';
  static String baseUrlDevelopment = 'http://10.231.92.57:3000/';

  /// 获取baseurl
  static String getBaseUrl() {
    return MyMode.inProduction
        ? Config.baseUrlProduction
        : Config.baseUrlDevelopment;
  }

  /// 页面背景色
  static Color pageBackgroudColor = Colors.grey.shade100;

  /// 高德地图web服务key
  static String amapWebServiceKey = '44bfff89d035bbc7b7c698974fe4bf5e';
}
