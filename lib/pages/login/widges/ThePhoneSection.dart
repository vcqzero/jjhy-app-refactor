import 'package:app/api/PhoneApi.dart';
import 'package:app/pages/login/TypeCodePage.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ThePhoneSection extends StatefulWidget {
  ThePhoneSection({Key? key}) : super(key: key);

  @override
  _ThePhoneSectionState createState() => _ThePhoneSectionState();
}

class _ThePhoneSectionState extends State<ThePhoneSection> {
  TextEditingController _controller = TextEditingController();
  bool _showHelper = false;
  String _helperText = '';
  bool _loading = false;
  CancelToken? cancelToken;
  FocusNode _focusNode = FocusNode();

  _getHelperText() {
    if (!_showHelper || _helperText.isEmpty) return null;
    return _helperText;
  }

  @override
  void dispose() {
    if (cancelToken != null) cancelToken!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: false,
          keyboardType: TextInputType.phone,
          controller: _controller,
          focusNode: _focusNode,
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
        MyButton.elevated(
          loading: _loading,
          label: '发送验证码',
          onPressed: () async {
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
            // 验证正确
            _focusNode.unfocus(); // 关闭键盘
            // 请求接口
            MyResponse res = PhoneApi.sendCode(phone: phone);
            cancelToken = res.cancelToken;
            setState(() {
              _loading = true;
            });
            res.future.then(
              (res) {
                int codeCount = res.data['codeCount'];
                int delaySeconds = res.data['delaySeconds'];
                // 进入输入验证码页面
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginTypeCodePage(
                      phone: phone,
                      delaySeconds: delaySeconds,
                      codeLen: codeCount,
                    ),
                  ),
                );
              },
            ).catchError(
              (err) {
                DioErrorType type = (err as DioError).type;
                if (type == DioErrorType.cancel) return;
                MyToast.show('网络错误，请稍后重试');
              },
            ).whenComplete(() {
              if (mounted) {
                setState(() {
                  _loading = false;
                });
              }
            });
          },
        )
      ],
    );
  }
}
