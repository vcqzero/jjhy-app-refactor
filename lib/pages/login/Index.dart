import 'dart:ui';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/pages/login/widges/ThePasswordSection.dart';
import 'package:app/pages/login/widges/ThePhoneSection.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'LoginPage';
  @override
  _LoginIndexState createState() => _LoginIndexState();
}

enum LoginMethods {
  password, // 密码登录
  code, // 验证码
}

class _LoginIndexState extends State<LoginPage> {
  LoginMethods _loginMethod = LoginMethods.password;

  @override
  Widget build(BuildContext context) {
    bool isPasswordMethod = _loginMethod == LoginMethods.password;
    return Scaffold(
      appBar: MyAppBar.build(title: '登录', hidden: true),
      body: Column(
        children: [
          // logo部分
          Container(
            color: Colors.blue[500],
            height: 200,
            alignment: Alignment.center,
            child: Container(
              width: 120,
              child: Image.asset(ImageAssets.logoInLogin, fit: BoxFit.contain),
            ),
          ),

          // 登录表单
          Padding(
            padding: EdgeInsets.all(10),
            child: isPasswordMethod ? ThePasswordSection() : ThePhoneSection(),
          ),

          // 登录方式切换按钮
          Container(
            margin: EdgeInsets.only(right: 10, top: 10),
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _loginMethod = _loginMethod == LoginMethods.code
                      ? LoginMethods.password
                      : LoginMethods.code;
                });
              },
              child: Text(
                isPasswordMethod ? '使用手机号登录' : '使用密码登录',
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
