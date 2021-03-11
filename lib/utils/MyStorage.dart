import 'package:get_storage/get_storage.dart';

const _TOKEN_KEY = 'token_key';

class MyStorage {
  static final _storage = GetStorage();

  /// 写入token
  static void setToken(String token) {
    _storage.write(_TOKEN_KEY, token);
  }

  /// 读取token
  static String? getToken(String token) {
    _storage.read<String>(_TOKEN_KEY);
  }

  /// 清空token
  static void clearToken() {
    _storage.remove(_TOKEN_KEY);
  }
}
