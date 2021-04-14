import 'package:app/config/Config.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyString.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:flutter/material.dart';

class SafetyVerificationPage extends StatefulWidget {
  SafetyVerificationPage({Key? key}) : super(key: key);

  @override
  _SafetyVerificationPageState createState() => _SafetyVerificationPageState();
}

class _SafetyVerificationPageState extends State<SafetyVerificationPage> {
  User _user = User.cached();
  bool _disabled = true;
  bool _verifyPassword = true;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _verifyPassword = _user.hasPassword;
    super.initState();
  }

  void _handleInputChange(String val) {
    setState(() {
      _disabled = val.isEmpty;
    });
  }

  void _handleClickConfirm() async {
    String val = _controller.text;
    bool valid = false;
    if (_verifyPassword) {
      // 验证密码
    } else {
      // 验证手机号
      valid = _user.tel == val;
    }
    if (!valid) {
      MyToast.show('验证错误');
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
              keyboardType: _verifyPassword ? null : TextInputType.phone,
              controller: _controller,
              decoration: InputDecoration(
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
              child: MyButton.text(
                label: _verifyPassword ? '验证手机号' : '验证密码',
                fullWidth: false,
                onPressed: () {
                  setState(() {
                    _verifyPassword = !_verifyPassword;
                    _controller.clear();
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
