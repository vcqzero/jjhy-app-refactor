import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  static String routeName = 'PrivacyPage';
  PrivacyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(title: '隐私政策'),
      body: Container(
        child: Text('隐私'),
      ),
    );
  }
}
