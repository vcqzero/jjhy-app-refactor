import 'package:flutter/material.dart';
import 'package:www/pages/profile/Settings.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('我的'),
          centerTitle: true,
        ),
        body: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, SettingsPage.routeName);
          },
          child: Text('ceshi'),
        ),
      ),
    );
  }
}
