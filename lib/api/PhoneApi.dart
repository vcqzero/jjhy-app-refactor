import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

Dio _dio = MyDio.getInstance();

class PhoneApi {
  /// 发送验证码
  static MyResponse sendCode({required String phone}) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.post(
      '/phone/code',
      cancelToken: cancelToken,
      data: {'tel': phone},
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }

  /// 验证验证码是否匹配
  static MyResponse validCode({
    required String phone,
    required String code,
  }) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get(
      '/phone/code/validation',
      cancelToken: cancelToken,
      queryParameters: {'tel': phone, 'code': code},
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }

  /// 验证手机号是否存在
  static MyResponse isExists({
    required String phone,
  }) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get(
      '/phone/existence',
      cancelToken: cancelToken,
      queryParameters: {'tel': phone},
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
