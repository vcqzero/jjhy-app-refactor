import 'package:flutter/material.dart';
import 'package:app/widgets/MyWidgets.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key? key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: MyWidgets.getAppBar(title: '待办'),
      ),
    );
  }
}
