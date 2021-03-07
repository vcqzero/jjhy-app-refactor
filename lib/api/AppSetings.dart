import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

class AppSetings {
  /// 获取banners
  static Future<Response> getBanners() {
    final dio = MyDio.getInstance();
    return dio.get('/app/banners');
  }
}
