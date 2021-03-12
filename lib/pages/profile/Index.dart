import 'package:app/pages/login/Index.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: MyAppBar.build(title: '我的'),
        body: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, LoginPage.routeName);
          },
          child: Text('登录'),
        ),
      ),
    );
  }
}
