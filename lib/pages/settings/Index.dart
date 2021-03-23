import 'package:app/Config.dart';
import 'package:app/pages/about/Index.dart';
import 'package:app/store/User.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyTile.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "SettingsPage";
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late User _user;
  @override
  void initState() {
    super.initState();
    _user = User.cache();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
            MyTile(
              title: '头像',
              trailingWidget: CircleAvatar(
                radius: 20,
                backgroundImage:
                    NetworkImage(_user.avatar ?? Config.defaultAvatar),
              ),
            ),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}
