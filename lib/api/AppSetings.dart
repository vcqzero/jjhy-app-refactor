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
}
