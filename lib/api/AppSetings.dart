import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

class AppSetings {
  /// 获取banners
  static MyResponse getBanners() {
    final dio = MyDio.getInstance();
    CancelToken cancelToken = CancelToken();
    final future = dio.get('/app/banners', cancelToken: cancelToken);
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
