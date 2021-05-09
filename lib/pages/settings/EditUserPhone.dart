import 'package:app/api/PhoneApi.dart';
import 'package:app/pages/common/TheInputCodePage.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyEasyLoading.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SettingsEditUserPhone extends StatefulWidget {
  SettingsEditUserPhone({Key? key}) : super(key: key);

  @override
  SettingsEditUserPhoneState createState() => SettingsEditUserPhoneState();
}

class SettingsEditUserPhoneState extends State<SettingsEditUserPhone> {
  TextEditingController _controller = TextEditingController();
  String? _helper;
  bool _disabled = true;
  bool _loading = false;
  CancelToken? _cancelToken;
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    if (_cancelToken != null) _cancelToken!.cancel();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    setState(() => {_loading = true});
    try {
      MyResponse res;
      String phone = _controller.text;
      // 首先验证该手机号是否已存在，不可修改为已存在的手机号
      res = PhoneApi.isExists(phone: phone);
      _cancelToken = res.cancelToken;
      bool exists = await res.future.then((value) => value.data['exists']);
      setState(() => {_loading = false});
      if (exists) {
        MyEasyLoading.toast('该手机号已被注册，请更换');
        return;
      }

      // send code
      res = PhoneApi.sendCode(phone: phone);
      _cancelToken = res.cancelToken;
      final data = await res.future.then((value) => value.data);
      int codeCount = data['codeCount'];
      int delaySeconds = data['delaySeconds'];

      // 隐藏输入框
      _focusNode.unfocus();

      // 进入输入验证码页面
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => TheInputCodePage(
            phone: phone,
            delaySeconds: delaySeconds,
            codeLen: codeCount,
            action: ActionhOnInputCode.updateUserPhone,
          ),
        ),
      );
    } catch (e) {
      print(e);
      MyEasyLoading.toast('系统错误，请重试');
    } finally {
      setState(() => {_loading = false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(title: '设置新手机'),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '请输入新手机号',
                helperText: _helper,
              ),
              autofocus: true,
              onChanged: (val) {
                setState(() {
                  _disabled = !MyReg.isChinaPhoneLegal(val);
                  _helper = MyReg.errMsg;
                });
              },
            ),
            SizedBox(height: 10),
            MyButton.elevated(
              label: '验证手机号',
              disabled: _disabled,
              loading: _loading,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
