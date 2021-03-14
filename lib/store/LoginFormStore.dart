import 'package:get_storage/get_storage.dart' show GetStorage;

GetStorage _box = GetStorage();

class LoginFormStore {
  static const String _usernameKey = 'storage_key_login_username';
  static const String _phoneKey = 'storage_key_login_phone';
  String? get username {
    return _box.read<String>(_usernameKey);
  }

  String? get phone {
    return _box.read<String>(_phoneKey);
  }

  Future<void> saveUsername(String val) async {
    try {
      await _box.write(_usernameKey, val);
    } catch (e) {
      print(e);
    }
  }

  Future<void> savePhone(String val) async {
    try {
      await _box.write(_phoneKey, val);
    } catch (e) {
      print(e);
    }
  }
}
