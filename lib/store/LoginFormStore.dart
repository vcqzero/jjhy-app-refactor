import 'package:get_storage/get_storage.dart';

GetStorage _getBox() => GetStorage('LoginFormStore');

class LoginFormStore {
  static String storageKey = 'loginForm';

  late ReadWriteValue<String?> _usernameVal;
  late ReadWriteValue<String?> _phoneVal;

  String? get username {
    return _usernameVal.val;
  }

  String? get phone {
    return _phoneVal.val;
  }

  set username(String? val) {
    _usernameVal.val = val;
  }

  set phone(String? val) {
    _phoneVal.val = val;
  }

  LoginFormStore() {
    _usernameVal = ReadWriteValue<String?>('username', null, _getBox);
    _phoneVal = ReadWriteValue<String?>('phone', null, _getBox);
  }
}
