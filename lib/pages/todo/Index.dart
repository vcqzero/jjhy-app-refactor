import 'package:flutter/material.dart';

class TodoPage extends StatefulWidget {
  TodoPage({Key key}) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: 0,
          title: Text('待办'),
          centerTitle: true,
        ),
      ),
    );
  }
}
