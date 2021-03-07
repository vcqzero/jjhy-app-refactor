import 'package:dio/dio.dart';

class MyDio {
  static const baseUrl = 'https://api.jjhycom.cn/api';
  static bool _inited = false;
  static Dio _instance = Dio();
  static Dio getInstance() {
    if (_inited == false) {
      _initInstance();
    }
    return _instance;
  }

  static _initInstance() {
    _instance = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 6000,
      receiveTimeout: 6000,
    ));
    _inited = true;
    // 配置拦截器
  }
}
