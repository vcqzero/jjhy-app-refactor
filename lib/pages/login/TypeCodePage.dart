import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class LoginTypeCodePageArguments {
  /// 手机号码
  String phone;
  LoginTypeCodePageArguments({required this.phone});
}

class LoginTypeCodePage extends StatefulWidget {
  static String routeName = 'LoginTypeCodePage';
  LoginTypeCodePage({Key? key}) : super(key: key);

  @override
  _LoginTypeCodePage createState() => _LoginTypeCodePage();
}

class _LoginTypeCodePage extends State<LoginTypeCodePage> {
  _toSafety(String phone) {
    return phone.replaceRange(3, 7, '****');
  }

  @override
  Widget build(BuildContext context) {
    LoginTypeCodePageArguments argus = ModalRoute.of(context)!
        .settings
        .arguments as LoginTypeCodePageArguments;
    print(argus.phone);
    final phone = _toSafety(argus.phone);
    return Scaffold(
      appBar: MyAppBar.build(
        title: '输入验证码',
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '验证码已发送至：',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TheCodeInputItem(),
                _TheCodeInputItem(),
                _TheCodeInputItem(),
                _TheCodeInputItem(),
                _TheCodeInputItem(),
                _TheCodeInputItem(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TheCodeInputItem extends StatelessWidget {
  const _TheCodeInputItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      child: TextField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        cursorHeight: 25,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontSize: 25,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
}
