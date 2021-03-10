import 'dart:ui';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/widgets/MyWidgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'LoginPage';
  @override
  _LoginIndexState createState() => _LoginIndexState();
}

class _LoginIndexState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgets.getAppBar(
        title: '登录',
        hidden: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[500],
            height: 200,
            alignment: Alignment.center,
            child: Container(
              width: 120,
              child: Image.asset(
                ImageAssets.logoInLogin,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: _ThePasswordSection(),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}

class _ThePasswordSection extends StatefulWidget {
  _ThePasswordSection({Key? key}) : super(key: key);

  @override
  _ThePasswordSectionState createState() => _ThePasswordSectionState();
}

class _ThePasswordSectionState extends State<_ThePasswordSection> {
  bool _passShowSwitch = false;
  String? _username;
  String? _password;
  bool _showHelper = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (String? val) {
            _username = val;
          },
          decoration: InputDecoration(
            hintText: '用户名或手机号',
            helperText:
                (_showHelper && (_username == null || _username!.isEmpty))
                    ? '请输入用户名或手机号'
                    : null,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          onChanged: (String? val) {
            _password = val;
          },
          decoration: InputDecoration(
            hintText: '登录密码',
            helperText:
                (_showHelper && (_password == null || _password!.isEmpty))
                    ? '请输入登录密码'
                    : null,
            suffixIcon: GestureDetector(
              child: Icon(Icons.remove_red_eye),
              onTap: () {
                setState(() {
                  _passShowSwitch = !_passShowSwitch;
                });
              },
            ),
          ),
          obscureText: _passShowSwitch,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: MyWidgets.getOutlineButton(
                  lable: '立即登录',
                  onPressed: () {
                    setState(() {
                      _showHelper = true;
                    });
                    print(_username);
                    print(_password);
                  }),
            )
          ],
        )
      ],
    );
  }
}
