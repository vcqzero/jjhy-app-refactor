import 'package:app/config/Config.dart';
import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';

Dio _dio = MyDio.getInstance();

class AmapApi {
  /// 逆地理编码
  static MyResponse regeo(
      {required double longitude, required double latitude}) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get(
      'https://restapi.amap.com/v3/geocode/regeo',
      cancelToken: cancelToken,
      queryParameters: {
        'key': Config.amapWebServiceKey,
        'location': '$longitude,$latitude',
      },
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }

  /// 通过关键字查询
  static MyResponse search({
    required String keywords,
  }) {
    CancelToken cancelToken = CancelToken();
    final future = _dio.get(
      'https://restapi.amap.com/v3/place/text',
      cancelToken: cancelToken,
      queryParameters: {
        'key': Config.amapWebServiceKey,
        'keywords': keywords,
        'offset': 10,
        'citylimit': true,
      },
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
