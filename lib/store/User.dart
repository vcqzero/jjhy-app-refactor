import 'dart:convert';
import 'dart:developer';
import 'package:app/api/UserApi.dart';
import 'package:app/config/Config.dart';
import 'package:app/store/Token.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyString.dart';
import 'package:get_storage/get_storage.dart';

GetStorage _getBox() => GetStorage();

class User {
  /// 定义之后不可修改，
  static String _storageKey = 'storage_key_user';
  // basic info

  /// 是否登录
  bool login = false;
  int? id;
  String? username;
  String? tel;
  String? telEncryption;
  String? avatar;
  String? realname;
  String? nickname;

  /// 是否设置过密码
  bool hasPassword = false;

  /// 是否是超级管理员
  bool isSuperAdmin = false;

  //role
  /// 所有的角色名称
  List? roleNames;

  /// 所有的角色聚合信息
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

  static User? _cached;

  /// 将user map数据保存到storage中
  static Future<void> store(Map? userMap) async {
    String userJson = jsonEncode(userMap);
    try {
      await _getBox().write(_storageKey, userJson);
      _cached = null;
      String? username = userMap!['username'];
      log('User-> 已将用户 $username 信息更新至storage');
    } catch (e) {
      log('error 保存user 数据出错', error: e);
    }
  }

  /// 清空user数据
  static Future<void> clear() async {
    try {
      await _getBox().remove(_storageKey);
      _cached = null;
    } catch (e) {
      print(e);
    }
  }

  /// 重新读取并new User对象
  User.build() {
    Map map = {};
    try {
      String? mapJson = _getBox().read(_storageKey);
      if (mapJson != null) map = jsonDecode(mapJson);

      _setBasicInfo(map);
      _setRole(map);
      _setWorkyard(map);
      _setCompany(map);
      _setJpush(map);
      _cached = this;
    } catch (e) {
      log('BUILD USER ERROR', error: e);
    }
  }

  /// 读取已构建完成的user实例
  factory User.cached() {
    if (_cached != null) {
      log('读取用户缓存数据');
      return _cached!;
    }
    return User.build();
  }

  /// 从服务器重新刷新用户数据
  /// 然后调用User.cached()
  static Future<void> reload() async {
    try {
      // 判断是否存在token
      String? token = Token().val;
      if (token == null || token.isEmpty) return log('User-> token无效，无法加载用户');
      MyResponse res = UserApi.querySignedUser();
      Map userMap = await res.future.then((value) => value.data['user']);
      await User.store(userMap);
    } catch (e) {
      log('User-> 用户加载失败', error: e);
    }
  }

  _setBasicInfo(Map map) {
    id = map['id'];
    username = map['username'];
    tel = map['tel'];
    if (tel != null) telEncryption = MyString.encryptPhone(tel!);

    // avatar_path为相对路径
    String? avatarPath = map['avatar_path'];
    avatar = avatarPath != null ? Config.getBaseUrl() + avatarPath : null;

    realname = map['realname'];
    nickname = map['nickname'];
    hasPassword = map['has_password'] ?? false;
    isSuperAdmin = map['super_admin'] ?? false;
    login = id != null ? id! > 0 : false;
  }

  _setRole(Map map) {
    roleNames = map['roles'];
    rolesAll = map['rolesAll'];
  }

  _setWorkyard(Map map) {
    // int? workyardId;
    // Map? workyard;
    // List? workyards;
    workyardId = map['workyard_id'];
    workyard = map['belong_workyard'];
    workyards = map['workyards'];
  }

  _setCompany(Map map) {
    // Map? company;
    // int? companyId;
    company = map['belong_company'];
    companyId = map['company_id'];
  }

  _setJpush(Map map) {
    // List? jpushDevices;
    jpushDevices = map['jpush_devices'];
  }
}
