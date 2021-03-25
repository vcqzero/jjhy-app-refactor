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

  /// 修改用户头像
  static MyResponse updateAvatar(FormData formData) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.post(
      '/users/me/avatar',
      cancelToken: cancelToken,
      data: formData,
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }

  /// 修改用户username realname nickname password
  static MyResponse updateBasicInfo(Map<String, String> data) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.post(
      '/users/me',
      cancelToken: cancelToken,
      data: data,
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
