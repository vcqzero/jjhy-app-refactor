import 'package:app/config/Config.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyString.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:flutter/material.dart';

class SecurityPage extends StatefulWidget {
  SecurityPage({Key? key}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _verifyPassword = true;
  User _user = User.cached();
  bool _disabled = true;
  String? _helperText;
  TextEditingController _controller = TextEditingController();

  void _handleInputChange(String val) {
    if (val.isEmpty) {
      return setState(() {
        _helperText = _verifyPassword
            ? '请输入密码'
            : '请补全手机号' + MyString.encryptPhone(_user.tel ?? '');
      });
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
              controller: _controller,
              decoration: InputDecoration(
                helperText: _helperText,
              ),
              obscureText: _verifyPassword,
              onChanged: _handleInputChange,
            ),
            SizedBox(height: 10),
            MyButton.elevated(
              label: '下一步',
              disabled: _disabled,
              onPressed: () {},
            ),
            Container(
              alignment: Alignment.centerRight,
              child: MyButton.text(
                label: _verifyPassword ? '验证手机号' : '验证密码',
                fullWidth: false,
                onPressed: () {
                  setState(() {
                    _helperText = null;
                    _verifyPassword = !_verifyPassword;
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
