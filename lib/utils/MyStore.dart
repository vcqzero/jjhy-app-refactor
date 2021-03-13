import 'dart:convert';
import 'package:get_storage/get_storage.dart';

final _storage = GetStorage();

class User {
  int id;
  String username;
  String tel;
  List<String>? roles;
  Map? workyard;
  Map? jpush;
  List? workyards;
  User({
    required this.id,
    required this.tel,
    required this.username,
    this.jpush,
    this.roles,
    this.workyard,
    this.workyards,
  });
}

class MyStore {
  String _userKey = 'jjhy_user_store_key';

  Future<void> saveUser(User user) {
    String userJson = jsonEncode(user.toString());
    print(userJson);
    return _storage.write(_userKey, userJson);
  }

  getUser() {
    var user = jsonDecode(_storage.read(_userKey));
    return user;
  }
}
