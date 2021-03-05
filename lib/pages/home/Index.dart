import 'package:flutter/material.dart';
import 'package:app/widgets/MyWidgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: MyWidgets.getAppBar(hidden: true),
      ),
    );
  }
}
