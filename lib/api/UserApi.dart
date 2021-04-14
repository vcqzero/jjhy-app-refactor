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

  /// 验证用户名是否可用
  static MyResponse validUsername(String username) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get(
      '/users/validation/username',
      cancelToken: cancelToken,
      queryParameters: {'username': username},
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }

  /// 修改用户username realname nickname password
  static MyResponse updateBasicInfo({
    String? username,
    String? realname,
    String? nickname,
    String? password,
  }) {
    // 构建数据
    Map<String, String> data = {};
    if (username != null) data['username'] = username;
    if (realname != null) data['realname'] = realname;
    if (nickname != null) data['nickname'] = nickname;
    if (password != null) data['password'] = password;
    // dio
    CancelToken cancelToken = CancelToken();
    final future = _dio.put(
      '/users/me',
      cancelToken: cancelToken,
      data: data,
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
