import 'package:app/api/PhoneApi.dart';
import 'package:app/pages/login/TypeCodePage.dart';
import 'package:app/store/LoginFormStore.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
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
  bool _loading = false;
  CancelToken? cancelToken;
  FocusNode _focusNode = FocusNode();

  _getHelperText() {
    if (!_showHelper || _helperText.isEmpty) return null;
    return _helperText;
  }

  @override
  void initState() {
    String? phone = LoginFormStore().phone;
    if (phone != null) _controller.text = phone;
    super.initState();
  }

  @override
  void dispose() {
    if (cancelToken != null) cancelToken!.cancel();
    super.dispose();
  }

  bool _handleValidPhone(String phone) {
    if (phone.isEmpty) {
      setState(() {
        _showHelper = true;
        _helperText = "请输入手机号";
      });
      return false;
    }
    if (!MyReg.isChinaPhoneLegal(phone)) {
      setState(() {
        _showHelper = true;
        _helperText = "请输入正确手机号";
      });
      return false;
    }
    return true;
  }

  /// 发送验证码
  _handleSendCode(String phone) async {
    // start loading
    setState(() => {_loading = true});

    MyResponse res = PhoneApi.sendCode(phone: phone);
    cancelToken = res.cancelToken;
    try {
      final data = await res.future.then((value) => value.data);
      int codeCount = data['codeCount'];
      int delaySeconds = data['delaySeconds'];
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
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) return;
      MyToast.show('网络错误，请稍后重试');
    } finally {
      if (mounted) setState(() => {_loading = false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: true,
          keyboardType: TextInputType.phone,
          controller: _controller,
          focusNode: _focusNode,
          onChanged: (val) {
            setState(() => {_showHelper = false});
          },
          decoration: InputDecoration(
            hintText: '手机号',
            helperText: _getHelperText(),
            prefixIcon: Icon(Icons.phone_android),
          ),
        ),
        SizedBox(height: 15),
        MyButton.elevated(
          loading: _loading,
          label: '发送验证码',
          onPressed: () async {
            final String phone = _controller.text;
            if (!_handleValidPhone(phone)) return;
            _focusNode.unfocus(); // 关闭键盘
            _handleSendCode(phone);
          },
        )
      ],
    );
  }
}
