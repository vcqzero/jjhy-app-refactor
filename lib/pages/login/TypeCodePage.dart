import 'package:app/utils/MyReg.dart';
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
  String code = ''; // 保存输入的验证码
  _toSafety(String phone) {
    return phone.replaceRange(3, 7, '****');
  }

  _getCodeBoxes() {
    const count = 6;
    List<String> codeList = code.split('');
    List<Widget> boxes = [];
    int len = codeList.length;
    for (var i = 0; i < count; i++) {
      final number = len - 1 >= i ? codeList[i] : '';
      boxes.add(_TheCodeBox(number: number));
    }
    return boxes;
  }

  @override
  Widget build(BuildContext context) {
    LoginTypeCodePageArguments argus = ModalRoute.of(context)!
        .settings
        .arguments as LoginTypeCodePageArguments;
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
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _getCodeBoxes(),
                ),
                TextField(
                  showCursor: false,
                  keyboardType: TextInputType.number,
                  onChanged: (String val) {
                    setState(() {
                      code = val.replaceAll(RegExp(r'[^\d]'), '');
                    });
                  },
                  style: TextStyle(fontSize: 0),
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
            // 隐藏的textFiled
          ],
        ),
      ),
    );
  }
}

class _TheCodeBox extends StatelessWidget {
  final String number;
  const _TheCodeBox({
    Key? key,
    this.number = '',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.0,
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Text(
        MyReg.isNumber(number) ? number : '',
        style: TextStyle(
          fontSize: 25,
          // color: Colors.blueGrey,
        ),
      ),
    );
  }
}
