import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class SafetyVerificationPage extends StatefulWidget {
  static const routeName = "SafetyVerificationPage";
  SafetyVerificationPage({Key? key}) : super(key: key);

  @override
  _SafetyVerificationPageState createState() => _SafetyVerificationPageState();
}

class _SafetyVerificationPageState extends State<SafetyVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(title: '安全验证'),
    );
  }
}
