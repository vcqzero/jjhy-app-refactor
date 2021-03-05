import 'package:app/widgets/MyWidgets.dart';
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
    return Container(
      child: Scaffold(
        appBar: MyWidgets.getAppBar(title: '设置'),
      ),
    );
  }
}
