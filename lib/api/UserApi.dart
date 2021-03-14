import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

Dio _dio = MyDio.getInstance();

class UserApi {
  /// 获取当前登录用户信息
  static MyResponse querySignedUser() {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get(
      '/users/me',
      cancelToken: cancelToken,
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
