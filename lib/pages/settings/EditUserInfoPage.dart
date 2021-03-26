import 'dart:developer';

import 'package:app/api/UserApi.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EditUserInfoPage extends StatefulWidget {
  static const routeName = "EditUserInfoPage";
  final String? val;
  EditUserInfoPage({
    Key? key,
    this.val,
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
    int maxLen = 20;
    bool isOverLen = val.length > maxLen;
    setState(() {
      // 按钮是否disabled
      _disabled = val.isEmpty || val == widget.val || isOverLen;
      // 是否长度
      _helper = isOverLen ? '长度不可超过$maxLen个字符' : null;
    });
  }

  Future<void> _handleUpdate() async {
    String val = _textEditingController.text;
    setState(() => {_loading = true});
    MyResponse res = UserApi.updateBasicInfo(nickname: val);
    _cancelToken = res.cancelToken;
    try {
      await res.future.then((value) => null);
      await User.reload();
      MyToast.show('修改成功');
      Navigator.of(context).pop();
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
                onPressed: _handleUpdate,
                disabled: _disabled,
                loading: _loading,
              )
            ],
          ),
        ));
  }
}
