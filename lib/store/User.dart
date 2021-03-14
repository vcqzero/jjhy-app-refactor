import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';

GetStorage _getBox() => GetStorage('userStorage');

class User {
  /// 定义之后不可修改，
  static String storageKey = 'user';
  GetStorage get storageBox {
    return _getBox();
  }

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
  static Future<void> store(Map? userMap) async {
    String userJson = jsonEncode(userMap);
    try {
      await _getBox().write(storageKey, userJson);
      print('保存user success');
    } catch (e) {
      print('保存user 数据出错');
      print(e);
    }
  }

  /// 从storage读取数据
  User.build() {
    Map map = {};
    try {
      String? mapJson = _getBox().read(storageKey);
      if (mapJson != null) map = jsonDecode(mapJson);

      _setBasicInfo(map);
      _setRole(map);
      _setWorkyard(map);
      _setCompany(map);
      _setJpush(map);
    } catch (e) {
      log('BUILD USER ERROR', error: e);
    }
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
    hasPassword = map['has_password'] ?? false;
    superAdmin = map['super_admin'] ?? false;
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
