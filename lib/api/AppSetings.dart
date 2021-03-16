import 'dart:io';

import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

final _dio = MyDio.getInstance();

class AppSetings {
  /// 获取banners
  static MyResponse getBanners() {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get('/app/banners', cancelToken: cancelToken);
    return MyResponse(future: future, cancelToken: cancelToken);
  }

  /// 判断app版本
  static MyResponse checkVersion({required String buildCode}) {
    CancelToken cancelToken = CancelToken();
    final future = _dio
        .get('/app/version/check', cancelToken: cancelToken, queryParameters: {
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'version_code': int.parse(buildCode)
    });
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
