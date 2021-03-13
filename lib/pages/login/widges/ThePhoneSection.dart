import 'package:app/pages/login/TypeCodePage.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/widgets/button/MyElevatedButton.dart';
import 'package:flutter/material.dart';

class ThePhoneSection extends StatefulWidget {
  ThePhoneSection({Key? key}) : super(key: key);

  @override
  _ThePhoneSectionState createState() => _ThePhoneSectionState();
}

class _ThePhoneSectionState extends State<ThePhoneSection> {
  TextEditingController _controller = TextEditingController();
  bool _showHelper = false;
  String _helperText = '';

  _getHelperText() {
    if (!_showHelper || _helperText.isEmpty) return null;
    return _helperText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: false,
          keyboardType: TextInputType.phone,
          controller: _controller,
          onChanged: (val) {
            setState(() {
              _showHelper = false;
            });
          },
          decoration: InputDecoration(
            hintText: '手机号',
            helperText: _getHelperText(),
            prefixIcon: Icon(
              Icons.phone_android,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        MyElevatedButton(
          label: '发送验证码',
          onPressed: () {
            final String phone = _controller.text;
            if (phone.isEmpty) {
              return setState(() {
                _showHelper = true;
                _helperText = "请输入手机号";
              });
            }
            if (!MyReg.isChinaPhoneLegal(phone)) {
              return setState(() {
                _showHelper = true;
                _helperText = "请输入正确手机号";
              });
            }
            // 进入输入验证码页面
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginTypeCodePage(
                  phone: phone,
                  delaySeconds: 10,
                  codeLen: 6,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
