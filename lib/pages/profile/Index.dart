import 'package:app/main.dart';
import 'package:app/pages/about/Index.dart';
import 'package:app/pages/profile/widges/TheAvatarSection.dart';
import 'package:app/pages/profile/widges/TheListSection.dart';
import 'package:app/store/User.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyLoginButton.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/settings/Index.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  late User _user;

  @override
  void initState() {
    _user = User.cached();
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!); //订阅
    super.didChangeDependencies();
  }

  /// 从上一页返回本页面
  @override
  void didPopNext() {
    setState(() => _user = User.build());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    bool _login = _user.login;
    return Container(
      child: Scaffold(
          appBar: MyAppBar.build(
            title: '我的',
            centerTitle: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: Text(_login ? '设置' : '关于'),
                tooltip: "关于",
                onPressed: () {
                  String _routeName =
                      _login ? SettingsPage.routeName : AboutPage.routeName;
                  Navigator.of(context).pushNamed(_routeName);
                },
              )
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 头像区域部分
              Container(
                color: Colors.blue,
                width: double.infinity,
                height: 100,
                // alignment: Alignment.center,
                child: TheAvatarSection(
                  username: _user.username,
                  phone: _user.tel,
                  avatar: _user.avatar,
                ),
              ),
              // body内容
              Expanded(
                flex: 1,
                child: _login
                    ? TheListSection()
                    // 未登录时
                    : Container(
                        alignment: Alignment.center,
                        child: MyLoginButton(),
                      ),
              ),
            ],
          )),
    );
  }
}
