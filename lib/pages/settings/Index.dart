import 'package:app/pages/about/Index.dart';
import 'package:app/pages/settings/widges/TheAvatarTile.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "SettingsPage";
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
    );
  }
}
