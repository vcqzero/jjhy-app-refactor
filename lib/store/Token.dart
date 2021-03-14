import 'package:get_storage/get_storage.dart';

GetStorage _getBox() => GetStorage();

class Token {
  static String _storageKey = 'storage_key_token';

  /// 获取token
  String? get val {
    return _getBox().read(_storageKey);
  }

  /// 保存token
  Future<void> store(String? token) async {
    try {
      await _getBox().write(_storageKey, token);
    } catch (e) {
      print('保存token错误');
      print(e);
    }
  }

  ///删除token
  static Future<void> clear() async {
    try {
      await _getBox().remove(_storageKey);
    } catch (e) {
      print('删除token错误');
      print(e);
    }
  }
}
