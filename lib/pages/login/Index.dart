import 'dart:ui';
import 'package:app/api/AuthApi.dart';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/widgets/MyWidgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'LoginPage';
  @override
  _LoginIndexState createState() => _LoginIndexState();
}

enum LoginMethods {
  username, // 用户名或手机号
  code, // 手机号 + 验证码
}

class _LoginIndexState extends State<LoginPage> {
  LoginMethods _loginMethod = LoginMethods.username;
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

          // 登录表单
          Padding(
            padding: EdgeInsets.all(10),
            child: _ThePasswordSection(),
          ),

          // 登录方式切换按钮
          Container(
            margin: EdgeInsets.only(right: 10, top: 10),
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _loginMethod = _loginMethod == LoginMethods.code
                      ? LoginMethods.username
                      : LoginMethods.code;
                });
              },
              child: Text(
                _loginMethod == LoginMethods.code ? '密码登录' : '手机号快捷登录',
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.blue),
              ),
            ),
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
  bool _passShowSwitch = true;
  bool _showHelper = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (val) {
            setState(() {});
          },
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: '用户名或手机号',
            helperText: (_showHelper && _usernameController.text.isEmpty)
                ? '请输入用户名或手机号'
                : null,
            suffixIcon: _usernameController.text.isNotEmpty
                ? GestureDetector(
                    child: Icon(Icons.close),
                    onTap: () {
                      setState(() {
                        _usernameController.clear();
                      });
                    },
                  )
                : null,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          onChanged: (String? val) {
            setState(() {});
          },
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: '登录密码',
            helperText: (_showHelper && _passwordController.text.isEmpty)
                ? '请输入登录密码'
                : null,
            suffixIcon: _passwordController.text.isNotEmpty
                ? GestureDetector(
                    child: Icon(Icons.remove_red_eye),
                    onTap: () {
                      setState(() {
                        _passShowSwitch = !_passShowSwitch;
                      });
                    },
                  )
                : null,
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
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    if (username.isEmpty || password.isEmpty) {
                      return setState(() {
                        _showHelper = true;
                      });
                    }
                    // 进行登录
                    MyResponse res = AuthApi.authByPassword(
                      username: username,
                      password: password,
                    );
                    res.future.then((res) {
                      print(res);
                    }).catchError((err) {
                      print(err);
                    });
                  }),
            )
          ],
        )
      ],
    );
  }
}
