import 'dart:convert';
import 'package:get_storage/get_storage.dart';

final _storage = GetStorage();

class User {
  static String storageKey = 'jjhy_user_store_key';
  // basic info
  int? id;
  String? username;
  String? tel;
  String? avatar;
  String? realname;
  String? nickname;
  bool hasPassword = false; // 是否设置过密码
  bool superAdmin = false; // 是否是超级管理员

  //role
  List? roles;
  List? rolesAll;

  //workyard
  int? workyardId;
  Map? workyard;
  List? workyards;

  // company
  Map? company;
  int? companyId;

  // jpush
  List? jpushDevices;

  /// 将user map数据保存到storage中
  static Future<void> saveStorage(Map? userMap) async {
    String userJson = jsonEncode(userMap);
    try {
      await _storage.write(storageKey, userJson);
      print('保存user success');
    } catch (e) {
      print('保存user 数据出错');
      print(e);
    }
  }

  /// 从storage读取数据
  User.readStorage() {
    Map map = {};
    try {
      map = jsonDecode(_storage.read(storageKey)) ?? {};
    } catch (e) {
      print('解析user\'s map 数据出错');
      print(e);
    }
    _setBasicInfo(map);
    _setRole(map);
    _setWorkyard(map);
    _setCompany(map);
    _setJpush(map);
  }

  _setBasicInfo(Map map) {
    // int? id;
    // String? username;
    // String? tel;
    // String? avatar;
    // String? realname;
    // String? nickname;
    // bool hasPassword; // 是否设置过密码
    // bool superAdmin; // 是否是超级管理员
    id = map['id'];
    username = map['username'];
    tel = map['tel'];
    avatar = map['avatar'];
    realname = map['realname'];
    nickname = map['nickname'];
    hasPassword = map['has_password'];
    superAdmin = map['super_admin'];
  }

  _setRole(Map map) {
    // List<String>? roles;
    // List? rolesAll;
    roles = map['roles'];
    rolesAll = map['rolesAll'];
  }

  _setWorkyard(Map map) {
    // int? workyardId;
    // Map? workyard;
    // List? workyards;
    workyardId = map['workyard_id'];
    workyard = map['workyard'];
    workyards = map['workyards'];
  }

  _setCompany(Map map) {
    // Map? company;
    // int? companyId;
    company = map['company'];
    companyId = map['company_id'];
  }

  _setJpush(Map map) {
    // List? jpushDevices;
    jpushDevices = map['jpush_devices'];
  }
}
