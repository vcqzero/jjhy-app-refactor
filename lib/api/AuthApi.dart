import 'dart:io';

import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

Dio _dio = MyDio.getInstance();

class AuthApi {
  /// 用户名或手机号登录
  static MyResponse authByPassword({
    required String username,
    required String password,
  }) {
    CancelToken cancelToken = CancelToken();
    return MyResponse(
      future: _dio.post(
        '/auth/username',
        cancelToken: cancelToken,
        data: {
          'username': username,
          'password': password,
        },
      ),
      cancelToken: cancelToken,
    );
  }

  /// 手机验证登录
  static MyResponse authByCode({
    required String phone,
    required String code,
  }) {
    CancelToken cancelToken = CancelToken();
    Future<Response> future = _dio.post(
      '/auth/tel',
      cancelToken: cancelToken,
      data: {
        'tel': phone,
        'code': code,
      },
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }

  /// 退出登录
  static MyResponse logout() {
    String platform = Platform.isAndroid ? 'android' : 'ios';
    CancelToken cancelToken = CancelToken();
    Future<Response> future = _dio.delete(
      '/auth/app/$platform',
      cancelToken: cancelToken,
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
