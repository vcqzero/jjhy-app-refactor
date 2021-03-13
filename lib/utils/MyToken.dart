import 'package:get_storage/get_storage.dart';

final _storage = GetStorage();

const _TOKEN_KEY = 'jjhy_app_auth_token_key';

class MyToken {
  /// 写入token
  static Future<void> setToken(String token) {
    return _storage.write(_TOKEN_KEY, token);
  }

  /// 读取token
  static String? getToken() {
    return _storage.read<String>(_TOKEN_KEY);
  }

  /// 清空token
  static void clearToken() {
    _storage.remove(_TOKEN_KEY);
  }
}
