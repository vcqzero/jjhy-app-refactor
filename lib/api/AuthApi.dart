import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

Dio _dio = MyDio.getInstance();

class AuthApi {
  /// 用户名或手机号登录
  static MyResponse authByPassword({
    /// 用户名或手机号
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
}
