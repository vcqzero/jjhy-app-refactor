import 'dart:developer';

import 'package:app/api/UserApi.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum EditUserInfoAttrs { username, nickname }

class EditUserInfoPage extends StatefulWidget {
  static const routeName = "EditUserInfoPage";
  final String? val;

  final EditUserInfoAttrs attrKey;

  EditUserInfoPage({
    Key? key,
    this.val,
    required this.attrKey,
  }) : super(key: key);

  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  bool _disabled = true;
  bool _loading = false;
  TextEditingController _textEditingController = TextEditingController();
  String? _helper;
  CancelToken? _cancelToken;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.val ?? '';
  }

  @override
  void dispose() {
    if (_cancelToken != null) _cancelToken!.cancel();
    super.dispose();
  }

  _handleInputChange(String val) {
    setState(() {
      bool valid = true;
      // 验证数据
      switch (widget.attrKey) {
        case EditUserInfoAttrs.nickname:
          valid = MyReg.validNickname(val);
          break;
        case EditUserInfoAttrs.username:
          valid = MyReg.validUsername(val);
          break;
        default:
      }
      _disabled = val.isEmpty || val == widget.val || valid == false;
      _helper = MyReg.errMsg;
    });
  }

  Future<bool> _handleUpdateUsername(String username) async {
    bool valid = true;
    MyResponse res;
    res = UserApi.validUsername(username);
    _cancelToken = res.cancelToken;
    valid = await res.future.then((value) => value.data['valid']);
    if (valid == false) {
      MyToast.show('该名称已占用，请更换！');
      return false;
    }
    // 更新
    res = UserApi.updateBasicInfo(username: username);
    _cancelToken = res.cancelToken;
    await res.future.then((value) => null);
    return true;
  }

  Future<bool> _handleUpdateNickname(String nickname) async {
    MyResponse res = UserApi.updateBasicInfo(nickname: nickname);
    _cancelToken = res.cancelToken;
    await res.future.then((value) => null);
    return true;
  }

  Future<void> _handleClickConfirm() async {
    String val = _textEditingController.text;
    setState(() => {_loading = true});

    bool success = false;
    try {
      switch (widget.attrKey) {
        case EditUserInfoAttrs.username:
          success = await _handleUpdateUsername(val);
          break;
        case EditUserInfoAttrs.nickname:
          success = await _handleUpdateNickname(val);
          break;
        default:
      }
      if (success == true) {
        await User.reload();
        MyToast.show('修改成功');
        Navigator.of(context).pop();
      }
    } catch (e) {
      log('更新用户信息错误', error: e);
      MyToast.show('系统错误，请重试');
    } finally {
      setState(() => {_loading = false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey.shade100,
        appBar: MyAppBar.build(title: '修改信息'),
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                controller: _textEditingController,
                onChanged: _handleInputChange,
                decoration: InputDecoration(helperText: _helper),
              ),
              SizedBox(height: 10),
              MyButton.elevated(
                label: '确认提交',
                onPressed: _handleClickConfirm,
                disabled: _disabled,
                loading: _loading,
              )
            ],
          ),
        ));
  }
}
