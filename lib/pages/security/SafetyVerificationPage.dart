import 'package:app/api/Security.dart';
import 'package:app/config/Config.dart';
import 'package:app/pages/common/TheSingleInput.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyEasyLoading.dart';
import 'package:app/utils/MyString.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SafetyVerificationPage extends StatefulWidget {
  final Widget? replacePage;
  SafetyVerificationPage({
    Key? key,
    this.replacePage,
  }) : super(key: key);

  @override
  _SafetyVerificationPageState createState() => _SafetyVerificationPageState();
}

class _SafetyVerificationPageState extends State<SafetyVerificationPage> {
  User _user = User.cached();
  bool _disabled = true;
  bool _verifyPassword = true;
  TextEditingController _controller = TextEditingController();
  CancelToken? _cancelToken;

  @override
  void initState() {
    _verifyPassword = _user.hasPassword;
    super.initState();
  }

  @override
  void dispose() {
    if (_cancelToken != null) _cancelToken!.cancel();
    super.dispose();
  }

  void _handleInputChange(String val) {
    setState(() {
      _disabled = val.isEmpty;
    });
  }

  void _handleClickConfirm() async {
    setState(() => {_disabled = true});
    String val = _controller.text;
    bool valid = false;
    if (_verifyPassword) {
      // 验证密码
      try {
        MyResponse res = SecurityApi.validPassword(val);
        _cancelToken = res.cancelToken;
        valid = await res.future.then((value) => value.data['valid']);
      } catch (e) {
        valid = false;
      }
    } else {
      // 验证手机号
      valid = _user.tel == val;
    }
    if (!valid) {
      MyEasyLoading.toast('验证错误');
      setState(() => {_disabled = false});
      return;
    } else {
      // 验证成功
      if (widget.replacePage == null) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (content) {
            return widget.replacePage!;
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.pageBackgroudColor,
      appBar: MyAppBar.build(title: '安全验证'),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              keyboardType: _verifyPassword ? null : TextInputType.phone,
              controller: _controller,
              decoration: InputDecoration(
                hintText: '输入验证内容',
                helperText: _verifyPassword
                    ? '请输入密码'
                    : '请补全手机号' + MyString.encryptPhone(_user.tel ?? ''),
              ),
              obscureText: _verifyPassword,
              onChanged: _handleInputChange,
            ),
            SizedBox(height: 10),
            MyButton.elevated(
              label: '下一步',
              disabled: _disabled,
              onPressed: _handleClickConfirm,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: _user.hasPassword && _user.tel != null
                  ? MyButton.text(
                      label: _verifyPassword ? '验证手机号' : '验证密码',
                      fullWidth: false,
                      onPressed: () {
                        setState(() {
                          _verifyPassword = !_verifyPassword;
                          _controller.clear();
                        });
                      },
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }
}
