import 'package:app/api/AuthApi.dart';
import 'package:app/main.dart';
import 'package:app/store/LoginFormStore.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/store/Token.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ThePasswordSection extends StatefulWidget {
  ThePasswordSection({Key? key}) : super(key: key);

  @override
  ThePasswordSectionState createState() => ThePasswordSectionState();
}

class ThePasswordSectionState extends State<ThePasswordSection> {
  bool _passShowSwitch = true;
  bool _showHelper = false;
  bool _authLoading = false;
  CancelToken? _cancelToken;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode _usernamefocusNode = FocusNode();
  FocusNode _passwordfocusNode = FocusNode();

  _handleAuth({required String username, required String password}) async {
    try {
      // start loading
      setState(() => {_authLoading = true});
      MyResponse res = AuthApi.authByPassword(
        username: username,
        password: password,
      );
      _cancelToken = res.cancelToken;
      Map data = await res.future.then((value) => value.data);
      // 登录成功后操作
      await Token().store(data['token']); // save token
      await User.store(data['user']);
      // 返回
      MyToast.show('登录成功');
      Navigator.of(context).popUntil(ModalRoute.withName(MainPage.routeName));
      // 将username写入storage
      LoginFormStore().username = username;
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) return;
      MyToast.show('用户名或密码错误，请重试');
    } finally {
      if (mounted) setState(() => {_authLoading = false});
    }
  }

  @override
  void dispose() {
    if (_cancelToken != null && mounted) _cancelToken!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // 读取上次登录的用户名
    String? username = LoginFormStore().username;
    if (username != null) _usernameController.text = username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: true,
          focusNode: _usernamefocusNode,
          onChanged: (val) => {setState(() {})},
          controller: _usernameController,
          keyboardType: TextInputType.emailAddress,
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
                      setState(() => {_usernameController.clear()});
                    })
                : null,
          ),
        ),
        SizedBox(height: 5),
        TextField(
          focusNode: _passwordfocusNode,
          onChanged: (String? val) => {setState(() {})},
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
                      setState(() => {_passShowSwitch = !_passShowSwitch});
                    })
                : null,
          ),
          obscureText: _passShowSwitch,
        ),
        SizedBox(height: 15),
        // 登录按钮
        MyButton.elevated(
          loading: _authLoading,
          label: '立即登录',
          onPressed: () {
            String username = _usernameController.text;
            String password = _passwordController.text;
            if (username.isEmpty || password.isEmpty) {
              return setState(() => {_showHelper = true});
            }
            // hide keyboard
            _usernamefocusNode.unfocus();
            _passwordfocusNode.unfocus();
            // auth
            _handleAuth(username: username, password: password);
          },
        )
      ],
    );
  }
}
