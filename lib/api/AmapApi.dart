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
      // ignore: unnecessary_brace_in_string_interps
      queryParameters: {
        'location': '$longitude,$latitude',
        'key': Config.amapWebServiceKey,
      },
    );
    return MyResponse(future: future, cancelToken: cancelToken);
  }
}
