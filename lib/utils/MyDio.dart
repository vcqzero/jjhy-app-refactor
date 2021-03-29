import 'dart:developer';

import 'package:app/config/Config.dart';
import 'package:app/store/Token.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyToast.dart';
import 'package:dio/dio.dart';

const bool _inProduction = const bool.fromEnvironment("dart.vm.product");

class MyResponse {
  Future<Response> future;
  CancelToken? cancelToken;
  MyResponse({required this.future, this.cancelToken});
}

class MyDio {
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
        baseUrl: Config.baseUrl + '/api',
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
          if (e.response != null) {
            switch (e.response!.statusCode) {
              case 401: // 认证失败或过期,需要清空用户信息
                await Token.clear();
                await User.clear();
                break;
              case 403: // 没有权限
                MyToast.show('没有权限!');
                break;
              default:
            }
          } else {
            // Something happened in setting up or sending the request that triggered an Error
            if (e.type != DioErrorType.cancel) {
              log('MyDio->request错误', error: e);
            }
          }
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
