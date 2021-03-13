import 'dart:async';
import 'package:app/api/AuthApi.dart';
import 'package:app/api/PhoneApi.dart';
import 'package:app/main.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyLoading.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoginTypeCodePageArguments {
  /// 手机号码
  String phone;
  LoginTypeCodePageArguments({required this.phone});
}

class LoginTypeCodePage extends StatefulWidget {
  static String routeName = 'LoginTypeCodePage';

  final String phone; // 手机号
  final int delaySeconds; // 再次发送需延长时间
  final int codeLen; // 验证码位数

  LoginTypeCodePage({
    Key? key,
    required this.phone,
    required this.delaySeconds,
    required this.codeLen,
  }) : super(key: key);

  @override
  _LoginTypeCodePage createState() => _LoginTypeCodePage();
}

class _LoginTypeCodePage extends State<LoginTypeCodePage> {
  String _code = ''; // 保存输入的验证码
  late int _resendDelaySeconds; // 重新发送剩余时间 秒
  late String _phoneSafety;
  late Timer _resendTimer;
  late int _codeLen;
  bool _resondLoading = false;
  CancelToken? _cancelToken;
  FocusNode _focusNode = FocusNode();
  bool _authLoging = false;

  @override
  void initState() {
    _phoneSafety = _toSafety(widget.phone);
    _resendDelaySeconds = widget.delaySeconds;
    _codeLen = widget.codeLen;
    _startResendTimer();
    super.initState();
  }

  /// 重新设置state
  void _resetState({
    required int delaySeconds,
    required int codeLen,
  }) {
    _resendDelaySeconds = delaySeconds;
    _codeLen = codeLen;
    if (_resendTimer.isActive) _resendTimer.cancel();
    _startResendTimer();
  }

  String _toSafety(String phone) {
    if (phone.length < 4) return '';
    return phone.replaceRange(3, 7, '****');
  }

  List<Widget> _getCodeBoxes() {
    List<String> codeList = _code.split('');
    List<Widget> boxes = [];
    int len = codeList.length;
    for (var i = 0; i < _codeLen; i++) {
      final number = len - 1 >= i ? codeList[i] : '';
      boxes.add(_TheCodeBox(number: number));
    }
    return boxes;
  }

  void _startResendTimer() {
    const duration = Duration(seconds: 1);
    _resendTimer = Timer.periodic(duration, (timer) {
      setState(() {
        _resendDelaySeconds--;
        if (_resendDelaySeconds <= 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    if (_resendTimer.isActive) _resendTimer.cancel();
    if (_cancelToken != null) _cancelToken!.cancel();
    super.dispose();
  }

  _authByCode({required String code, context}) {
    if (_authLoging) return;
    // start loading
    _authLoging = true;
    MyLoading.showLoading("登录中...");

    // api
    MyResponse res = AuthApi.authByCode(phone: widget.phone, code: code);
    final future = res.future;
    _cancelToken = res.cancelToken;
    future.then((res) {
      MyToast.show('登录成功');
      // 返回/
      Navigator.of(context).popUntil(ModalRoute.withName(MainPage.routeName));
    }).catchError((err) {
      MyToast.show('手机号或验证码错误');
      // 返回上一页
      Navigator.of(context).pop();
    }).whenComplete(() {
      // hide loading
      _authLoging = false;
      MyLoading.dismiss();
    });
  }

  GestureDetector _renderResendButton() {
    return GestureDetector(
      child: Text(
        '重新发送',
        style: TextStyle(color: Colors.blue),
      ),
      onTap: () {
        if (_resondLoading) return print('重新发送');
        MyResponse res = PhoneApi.sendCode(phone: widget.phone);
        _cancelToken = res.cancelToken;
        // loading
        _resondLoading = true;
        MyLoading.showLoading('发送中...');
        res.future.then(
          (res) {
            int codeCount = res.data['codeCount'];
            int delaySeconds = res.data['delaySeconds'];
            _resetState(codeLen: codeCount, delaySeconds: delaySeconds);
          },
        ).catchError(
          (err) {
            DioErrorType type = (err as DioError).type;
            if (type == DioErrorType.cancel) return;
            MyToast.show('网络错误，请稍后重试');
          },
        ).whenComplete(() {
          _resondLoading = false;
          MyLoading.dismiss();
          MyLoading.success('发送成功');
        });
      },
    );
  }

  Container _renderTextFiled() {
    return Container(
      padding: EdgeInsets.only(left: 15),
      child: TextField(
        focusNode: _focusNode,
        toolbarOptions: const ToolbarOptions(),
        showCursor: false,
        keyboardType: TextInputType.number,
        onChanged: (String val) {
          val = val.replaceAll(RegExp(r'[^\d]'), '');
          if (val.length > _codeLen || _code == val) return;
          setState(() {
            _code = val;
            // 是否输入完成
            if (_code.length >= _codeLen) {
              print('输入完成');
              _focusNode.unfocus();
              // 发送请求
              _authByCode(code: _code, context: context);
            }
          });
        },
        style: TextStyle(fontSize: 0),
        autofocus: true,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  _phoneSafety,
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
                  mainAxisAlignment: _codeLen > 4
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceEvenly,
                  children: _getCodeBoxes(),
                ),
                _renderTextFiled(),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '请输入验证码',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
                Container(
                  child: _resendDelaySeconds > 0
                      ? Text(
                          '${_resendDelaySeconds.toString()}秒后重新发送',
                          style: TextStyle(color: Colors.grey.shade500),
                        )
                      : _renderResendButton(),
                ),
              ],
            ),
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
