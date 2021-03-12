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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: (val) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: '手机号',
            helperText:
                (_showHelper && _controller.text.isEmpty) ? '请输入手机号' : null,
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
            if (_controller.text.isEmpty) {
              setState(() {
                _showHelper = true;
              });
            }
          },
        )
      ],
    );
  }
}
