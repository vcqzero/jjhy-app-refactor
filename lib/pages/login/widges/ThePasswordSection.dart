import 'package:app/api/AuthApi.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyStorage.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:flutter/material.dart';

class ThePasswordSection extends StatefulWidget {
  ThePasswordSection({Key? key}) : super(key: key);

  @override
  ThePasswordSectionState createState() => ThePasswordSectionState();
}

class ThePasswordSectionState extends State<ThePasswordSection> {
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
            prefixIcon: Icon(Icons.person),
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
            prefixIcon: Icon(Icons.lock),
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
        MyButton.elevated(
          label: '立即登录',
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
              MyStorage.setToken(res.data['token']);
            }).catchError((err) {
              print('err');
              print(err.type);
            });
          },
        )
      ],
    );
  }
}
