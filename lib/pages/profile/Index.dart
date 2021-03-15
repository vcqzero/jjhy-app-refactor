import 'package:app/main.dart';
import 'package:app/pages/login/Index.dart';
import 'package:app/store/User.dart';
import 'package:app/widgets/MyAppBar.dart';
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
          appBar: MyAppBar.build(title: '我的'),
          body: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginPage.routeName);
                },
                child: Text('登录'),
              ),
              Text(user.login ? '已登录' : '未登录'),
              Text(user.username ?? ''),
            ],
          )),
    );
  }
}
