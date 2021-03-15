import 'package:app/main.dart';
import 'package:app/pages/profile/widges/TheAvatarSection.dart';
import 'package:app/pages/profile/widges/TheListSection.dart';
import 'package:app/store/User.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyLoginButton.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with RouteAware {
  late User user;

  @override
  void initState() {
    user = User.build();
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

  @override
  void didPopNext() {
    setState(() => user = User.build());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: MyAppBar.build(
            title: '我的',
            centerTitle: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: Text('关于'),
                tooltip: "搜索",
                onPressed: () {
                  print("搜索");
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
                  username: user.username,
                  phone: user.tel,
                  avatar: user.avatar,
                ),
              ),
              Expanded(
                flex: 1,
                child: !user.login
                    ? TheListSection()
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
