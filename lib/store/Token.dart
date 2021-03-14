import 'package:get_storage/get_storage.dart';

GetStorage _getBox() => GetStorage('TokenStore');

class Token {
  static String storageKey = 'token';

  /// 获取token
  String? get val {
    return _getBox().read(storageKey);
  }

  /// 保存token
  Future<void> store(String? token) async {
    try {
      await _getBox().write(storageKey, token);
    } catch (e) {
      print('保存token错误');
      print(e);
    }
  }

  ///删除token
  Future<void> removeToken() async {
    try {
      await _getBox().remove(storageKey);
    } catch (e) {
      print('删除token错误');
      print(e);
    }
  }
}
