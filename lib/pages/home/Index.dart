import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
        title: Text('首页'),
      )),
    );
  }
}
