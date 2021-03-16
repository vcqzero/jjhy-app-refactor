import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  static String routeName = 'AboutPage';
  AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(title: '关于'),
    );
  }
}
