import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

Dio _dio = MyDio.getInstance();

class SecurityApi {
  /// 验证密码是否正确
  static MyResponse validPassword(String password) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get(
      '/users/me/validation/password',
      cancelToken: cancelToken,
      queryParameters: {'password': password},
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
