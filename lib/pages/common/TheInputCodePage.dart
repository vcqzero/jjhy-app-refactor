import 'dart:async';
import 'package:app/api/AuthApi.dart';
import 'package:app/api/PhoneApi.dart';
import 'package:app/api/UserApi.dart';
import 'package:app/main.dart';
import 'package:app/pages/settings/Index.dart';
import 'package:app/store/LoginFormStore.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyEasyLoading.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/store/Token.dart';
import 'package:app/utils/MyString.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// 输入全部code之后，下一步动作
enum ActionhOnInputCode {
  /// 登录
  auth,

  /// 验证验证码
  valid,

  /// 修改手机号
  updateUserPhone,
}

/// 输入手机验证码页面
class TheInputCodePage extends StatefulWidget {
  static String routeName = 'TheInputCodePage';

  final String phone; // 手机号
  final int delaySeconds; // 再次发送需延长时间
  final int codeLen; // 验证码位数
  final ActionhOnInputCode action;

  TheInputCodePage({
    Key? key,
    required this.phone,
    required this.delaySeconds,
    required this.codeLen,
    required this.action,
  }) : super(key: key);

  @override
  _TheInputCodePage createState() => _TheInputCodePage();
}

class _TheInputCodePage extends State<TheInputCodePage> {
  String _code = ''; // 保存输入的验证码
  late int _resendDelaySeconds; // 重新发送剩余时间 秒
  late String _phoneSafety;
  late Timer _resendTimer;
  late int _codeLen;
  bool _resondLoading = false;
  CancelToken? _cancelToken;
  FocusNode _focusNode = FocusNode();
  bool _submitLoading = false; // 验证或登录loading

  @override
  void initState() {
    _phoneSafety = MyString.encryptPhone(widget.phone);
    _resendDelaySeconds = widget.delaySeconds;
    _codeLen = widget.codeLen;
    _startResendTimer();
    super.initState();
  }

  /// 重新设置state
  void _handleResetState({
    required int delaySeconds,
    required int codeLen,
  }) {
    _resendDelaySeconds = delaySeconds;
    _codeLen = codeLen;
    if (_resendTimer.isActive) _resendTimer.cancel();
    _startResendTimer();
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
        if (_resendDelaySeconds <= 0) timer.cancel();
      });
    });
  }

  @override
  void dispose() {
    if (_resendTimer.isActive) _resendTimer.cancel();
    if (_cancelToken != null) _cancelToken!.cancel();
    super.dispose();
  }

  /// 通过手机验证码登录
  _handleAuthByCode({required String code}) async {
    if (_submitLoading) return;
    // start loading
    _submitLoading = true;
    MyEasyLoading.loading("登录中...");

    // api
    String phone = widget.phone;
    MyResponse res = AuthApi.authByCode(phone: phone, code: code);
    final future = res.future;
    _cancelToken = res.cancelToken;
    try {
      final data = await future.then((value) => value.data);
      // 登录成功后操作
      await Token().store(data['token']); // save token
      await User.store(data['user']);
      // 返回
      MyToast.show('登录成功');
      Navigator.of(context).popUntil(ModalRoute.withName(MainPage.routeName));
      // 写入storage
      LoginFormStore().savePhone(phone);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) return;
      MyToast.show('手机号或验证码错误');
    } finally {
      // hide loading
      _submitLoading = false;
      MyEasyLoading.hide();
    }
  }

  /// 验证手机和验证码是否正确
  _validPhoneCode({required String code}) async {
    if (_submitLoading) return;
    // start loading
    _submitLoading = true;
    MyEasyLoading.loading("验证中...");

    // api
    String phone = widget.phone;
    MyResponse res = PhoneApi.validCode(phone: phone, code: code);
    final future = res.future;
    _cancelToken = res.cancelToken;
    try {
      final valid = await future.then((value) => value.data['valid']);
      if (valid != true) throw new Error();

      // 返回
      MyToast.show('验证成功');
      Navigator.of(context).pop();
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) return;
      MyToast.show('手机号或验证码错误');
    } finally {
      // hide loading
      _submitLoading = false;
      MyEasyLoading.hide();
    }
  }

  /// 修改用户手机号
  _updateUserPhone({required String code}) async {
    if (_submitLoading) return;
    // start loading
    _submitLoading = true;
    MyEasyLoading.loading("提交中...");

    // api
    String phone = widget.phone;
    MyResponse res = UserApi.updatePhone(phone: phone, code: code);
    _cancelToken = res.cancelToken;
    try {
      await res.future.then((value) => value.data);

      // 返回
      MyToast.show('修改成功');
      await User.reload();
      Navigator.of(context)
          .popUntil(ModalRoute.withName(SettingsPage.routeName));
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) return;
      MyToast.show('手机号或验证码错误');
    } finally {
      // hide loading
      _submitLoading = false;
      MyEasyLoading.hide();
    }
  }

  _handleResendCode() async {
    try {
      if (_resondLoading) return;
      MyResponse res = PhoneApi.sendCode(phone: widget.phone);
      _cancelToken = res.cancelToken;

      // loading
      _resondLoading = true;
      MyEasyLoading.loading('发送中...');
      final data = await res.future.then((value) => value.data);
      int codeCount = data['codeCount'];
      int delaySeconds = data['delaySeconds'];
      _handleResetState(codeLen: codeCount, delaySeconds: delaySeconds);

      // loading
      MyEasyLoading.hide();
      MyEasyLoading.success('发送成功');
    } on DioError catch (e) {
      MyEasyLoading.hide();
      if (e.type == DioErrorType.cancel) return;
      MyToast.show('网络错误，请稍后重试');
    } finally {
      _resondLoading = false;
    }
  }

  _handleTextFiledChange(String val) {
    val = val.replaceAll(RegExp(r'[^\d]'), '');
    if (val.length > _codeLen || _code == val) return;
    setState(() => {_code = val});
    if (val.length < _codeLen) return;

    // 验证码输入完整，进行下一步动作
    _focusNode.unfocus();
    switch (widget.action) {
      case ActionhOnInputCode.auth:
        _handleAuthByCode(code: val);
        break;
      case ActionhOnInputCode.valid:
        _validPhoneCode(code: val);
        break;
      case ActionhOnInputCode.updateUserPhone:
        _updateUserPhone(code: val);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(title: '输入验证码'),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('验证码已发送至：', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 5),
                Text(
                  _phoneSafety,
                  style: TextStyle(color: Colors.grey[700], fontSize: 28),
                ),
              ],
            ),
            SizedBox(height: 30),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: _codeLen > 4
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceEvenly,
                  children: _getCodeBoxes(),
                ),
                TextField(
                  focusNode: _focusNode,
                  toolbarOptions: const ToolbarOptions(),
                  showCursor: false,
                  keyboardType: TextInputType.number,
                  onChanged: _handleTextFiledChange,
                  style: TextStyle(fontSize: 0),
                  autofocus: true,
                  decoration: InputDecoration(border: InputBorder.none),
                )
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('请输入验证码', style: TextStyle(color: Colors.grey.shade500)),
                Container(
                  child: _resendDelaySeconds > 0
                      ? Text(
                          '${_resendDelaySeconds.toString()}秒后重新发送',
                          style: TextStyle(color: Colors.grey.shade500),
                        )
                      : GestureDetector(
                          child: Text('重新发送',
                              style: TextStyle(color: Colors.blue)),
                          onTap: _handleResendCode,
                        ),
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
        style: TextStyle(fontSize: 25),
      ),
    );
  }
}
