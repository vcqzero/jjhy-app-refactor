import 'dart:developer';

import 'package:app/api/AuthApi.dart';
import 'package:app/config/Config.dart';
import 'package:app/main.dart';
import 'package:app/pages/about/Index.dart';
import 'package:app/pages/security/SafetyVerificationPage.dart';
import 'package:app/pages/settings/EditUserInfoPage.dart';
import 'package:app/pages/settings/UserRoleListPage.dart';
import 'package:app/pages/settings/widges/TheAvatarTile.dart';
import 'package:app/store/Token.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDialog.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyLoading.dart';
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
    MyLoading.hide();
    super.dispose();
  }

  /// 从上一页返回本页面
  @override
  void didPopNext() {
    setState(() => _user = User.cached());
    super.didPopNext();
  }

  Future<void> _handleLogout() async {
    MyLoading.showLoading('退出中...');
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
      MyLoading.hide();
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
              trailingString: _user.nickname,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserInfoPage(
                      val: _user.nickname,
                    ),
                  ),
                );
              }),
          Divider(height: 1),
          SizedBox(height: 15),
          // 角色
          MyTile(
            title: '我的角色',
            trailingWidget: Text('查看'),
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
              trailingWidget: Text(_user.telEncryption ?? '未绑定')),
          Divider(height: 1),
          // 账号
          MyTile(title: '我的账号', trailingWidget: Text(_user.username ?? '')),
          Divider(height: 1),
          // 账号密码
          MyTile(
            title: '账号密码',
            trailingString: '修改密码',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SafetyVerificationPage(),
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
