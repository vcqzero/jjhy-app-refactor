import 'package:get_storage/get_storage.dart';

final _storage = GetStorage();

class Token {
  static String storageKey = 'token';

  /// 写入token
  static Future<void> saveToken(String token) {
    return _storage.write(storageKey, token);
  }

  /// 读取token
  static String? getToken() {
    return _storage.read<String>(storageKey);
  }

  /// 清空token
  static void clearToken() {
    _storage.remove(storageKey);
  }
}
