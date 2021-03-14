import 'package:app/store/Token.dart';
import 'package:dio/dio.dart';

const bool _inProduction = const bool.fromEnvironment("dart.vm.product");
const String _baseUrlProd = 'https://api.jjhycom.cn';
const String _baseUrlDev = 'http://192.168.0.117:3000';

class MyResponse {
  Future<Response> future;
  CancelToken? cancelToken;
  MyResponse({required this.future, this.cancelToken});
}

class MyDio {
  static const baseUrl =
      _inProduction ? _baseUrlProd + '/api' : _baseUrlDev + '/api';
  static bool _inited = false;
  static Dio _instance = Dio();
  static Dio getInstance() {
    if (_inited == false) {
      _initInstance();
      _configInterceptors(); // 配置拦截器
    }
    return _instance;
  }

  static _initInstance() {
    _instance = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 6000,
        receiveTimeout: 6000,
      ),
    );
    _inited = true;
  }

  static _configInterceptors() {
    _instance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          // Do something before request is sent
          String? token = Token().val;
          if (token != null)
            options.headers['Authorization'] = 'Bearer ' + token;
          return options;
        },
        onResponse: (Response response) async {
          /// [responseType] indicates the type of data that the server will respond with
          /// options which defined in [ResponseType] are `JSON`, `STREAM`, `PLAIN`.
          ///
          /// The default value is `JSON`, dio will parse response string to json object automatically
          /// when the content-type of response is "application/json".
          ///
          /// If you want to receive response data with binary bytes, for example,
          /// downloading a image, use `STREAM`.
          ///
          /// If you want to receive the response data with String, use `PLAIN`.
          return response; // continue
        },
        onError: (DioError e) async {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx and is also not 304.
          // if (e.response != null) {
          // } else {
          //   // Something happened in setting up or sending the request that triggered an Error
          // }
          return e; //continue
        },
      ),
    );
    // 请求日志
    if (!_inProduction) {
      _instance.interceptors.add(LogInterceptor(
        requestHeader: true,
        responseHeader: false,
        responseBody: true,
      ));
    }
  }
}
