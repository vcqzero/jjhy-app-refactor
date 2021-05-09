import 'dart:developer';

import 'package:app/api/AuthApi.dart';
import 'package:app/api/UserApi.dart';
import 'package:app/config/Config.dart';
import 'package:app/main.dart';
import 'package:app/pages/about/Index.dart';
import 'package:app/pages/common/TheSingleInputPage.dart';
import 'package:app/pages/security/SafetyVerificationPage.dart';
import 'package:app/pages/settings/EditUserPhone.dart';
import 'package:app/pages/settings/UserRoleListPage.dart';
import 'package:app/pages/settings/widges/TheAvatarTile.dart';
import 'package:app/store/Token.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDialog.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyEasyLoading.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "SettingsPage";
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with RouteAware {
  User _user = User.cached();
  CancelToken? _cancelToken;

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!); //订阅
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    if (_cancelToken != null) _cancelToken!.cancel();
    MyEasyLoading.hide();
    super.dispose();
  }

  /// 从上一页返回本页面
  @override
  void didPopNext() {
    setState(() => _user = User.cached());
    super.didPopNext();
  }

  Future<void> _handleLogout() async {
    MyEasyLoading.loading('退出中...');
    MyResponse res = AuthApi.logout();
    _cancelToken = res.cancelToken;
    try {
      await res.future.then((value) => null);
      await User.clear();
      await Token.clear();
      Navigator.of(context).pop();
    } catch (e) {
      log('退出登录错误', error: e);
    } finally {
      MyEasyLoading.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.pageBackgroudColor,
      appBar: MyAppBar.build(
        title: '设置',
        actions: [
          IconButton(
            icon: Text('关于'),
            tooltip: "关于",
            onPressed: () {
              Navigator.of(context).pushNamed(AboutPage.routeName);
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20),
        children: [
          Divider(height: 1),
          // 头像
          TheAvatarTile(),
          Divider(height: 1),
          // 昵称
          MyTile(
              title: '昵称',
              trailingString: _user.nickname ?? '未设置',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TheSingleInputPage(
                      val: _user.nickname,
                      title: '修改昵称',
                      placeholder: '请输入新昵称',
                      regValidFun: MyReg.validNickname,
                      onSubmit: (String nickname) async {
                        MyResponse res =
                            UserApi.updateBasicInfo(nickname: nickname);
                        _cancelToken = res.cancelToken;
                        await res.future.then((value) => null);
                        await User.reload();
                        return TheInputDioRes(success: true);
                      },
                      cancelTokenOnPop: () {
                        if (_cancelToken != null) _cancelToken!.cancel();
                      },
                    ),
                  ),
                );
              }),
          Divider(height: 1),
          SizedBox(height: 15),
          // 角色
          MyTile(
            title: '我的角色',
            trailingString: '查看',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserRoleListPage()),
              );
            },
          ),
          Divider(height: 1),
          SizedBox(height: 15),
          // 绑定手机
          MyTile(
            title: '绑定手机',
            trailingWidget: Text(_user.telEncryption ?? '未绑定'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SafetyVerificationPage(
                    redirectPage: SettingsEditUserPhone(),
                  ),
                ),
              );
            },
          ),

          Divider(height: 1),
          // 账号
          MyTile(
            title: '我的账号',
            trailingString: _user.username,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TheSingleInputPage(
                    val: _user.username,
                    title: '修改用户名',
                    placeholder: '请输入新用户名',
                    regValidFun: MyReg.validUsername,

                    /// 提交数据
                    onSubmit: (String username) async {
                      MyResponse res =
                          UserApi.updateBasicInfo(username: username);
                      _cancelToken = res.cancelToken;
                      await res.future.then((value) => null);
                      await User.reload();
                      return TheInputDioRes(success: true);
                    },

                    /// 远程验证
                    remoteValidFun: (String username) async {
                      MyResponse res = UserApi.validUsername(username);
                      _cancelToken = res.cancelToken;
                      bool valid =
                          await res.future.then((value) => value.data['valid']);
                      return TheInputDioRes(success: valid, errMsg: '用户名已占用');
                    },

                    /// cancel token
                    cancelTokenOnPop: () {
                      if (_cancelToken != null) _cancelToken!.cancel();
                    },
                  ),
                ),
              );
            },
          ),
          Divider(height: 1),
          // 账号密码
          MyTile(
            title: '账号密码',
            trailingString: _user.hasPassword ? '修改' : '未设置',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SafetyVerificationPage(
                    redirectPage: TheSingleInputPage(
                      title: '设置新密码',
                      placeholder: '请输入新密码',

                      /// 验证
                      regValidFun: MyReg.validPassword,

                      /// 修改
                      onSubmit: (String password) async {
                        MyResponse res =
                            UserApi.updateBasicInfo(password: password);
                        _cancelToken = res.cancelToken;
                        await res.future.then((value) => null);
                        await User.reload();
                        return TheInputDioRes(success: true);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          Divider(height: 1),
          // 推送功能
          SizedBox(height: 15),
          MyTile(title: '推送功能'),
          Divider(height: 1),
          // 安全退出
          SizedBox(height: 15),
          MyTile(
            title: '退出登录',
            titleColor: Colors.red,
            onTap: () {
              MyDialog(
                context,
                title: '提示',
                textChildren: [Text('确认退出当前账号！')],
                onConfirm: () => _handleLogout(),
              ).open();
            },
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
}
