import 'dart:developer';

import 'package:app/utils/MyEasyLoading.dart';
import 'package:app/utils/MyReg.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TheInputDioRes {
  /// 执行结果
  final bool success;
  final String? errMsg;
  final String? successMsg;
  TheInputDioRes({
    required this.success,
    this.errMsg,
    this.successMsg,
  });
}

class TheSingleInputPage extends StatefulWidget {
  static const routeName = "TheSingleInputPage";

  /// input default value
  final String? val; // input value
  /// page title
  final String? title; // page title
  /// input placeholder
  final String? placeholder;

  /// 正则验证
  final bool Function(String str)? regValidFun;

  /// 远程验证
  final Future<TheInputDioRes> Function(String str)? remoteValidFun;

  /// 数据修改
  final Future<TheInputDioRes> Function(String sta)? onSubmit;

  final void Function()? cancelTokenOnPop;

  TheSingleInputPage({
    Key? key,
    this.val,
    this.title,
    this.placeholder,
    this.regValidFun,
    this.remoteValidFun,
    this.onSubmit,
    this.cancelTokenOnPop,
  }) : super(key: key);

  @override
  _TheSingleInputPageState createState() => _TheSingleInputPageState();
}

class _TheSingleInputPageState extends State<TheSingleInputPage> {
  bool _disabled = true;
  bool _loading = false;
  TextEditingController _textEditingController = TextEditingController();
  String? _helper;

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.val ?? '';
  }

  @override
  void dispose() {
    if (widget.cancelTokenOnPop != null) widget.cancelTokenOnPop!();
    super.dispose();
  }

  _handleInputChange(String val) {
    setState(() {
      bool valid = true;
      if (widget.regValidFun != null) valid = widget.regValidFun!(val);
      _disabled = val.isEmpty || val == widget.val || valid == false;
      _helper = MyReg.errMsg;
    });
  }

  Future<void> _handleClickButton() async {
    String val = _textEditingController.text;

    // 远程验证
    if (widget.remoteValidFun != null) {
      try {
        setState(() => {_loading = true});
        TheInputDioRes res = await widget.remoteValidFun!(val);

        if (res.success != true) {
          if (res.errMsg != null) MyEasyLoading.toast(res.errMsg!);
          return;
        }
      } catch (e) {
        log('远程验证发送错误', error: e);
      } finally {
        setState(() => {_loading = false});
      }
    }

    /// 提交数据
    if (widget.onSubmit != null) {
      try {
        setState(() => {_loading = true});
        TheInputDioRes res = await widget.onSubmit!(val);
        if (res.success) {
          /// 修改成功
          MyEasyLoading.toast(res.successMsg ?? '修改成功');
          Navigator.of(context).pop();
        } else {
          MyEasyLoading.toast(res.errMsg ?? '系统错误，请重试');
        }
      } catch (e) {
        log('远程提交发送错误', error: e);
      } finally {
        setState(() => {_loading = false});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.grey.shade100,
        appBar: MyAppBar.build(title: widget.title ?? '修改信息'),
        body: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              SizedBox(height: 10),

              /// 输入框
              TextField(
                controller: _textEditingController,
                onChanged: _handleInputChange,
                decoration: InputDecoration(
                  helperText: _helper,
                  hintText: widget.placeholder,
                ),
              ),
              SizedBox(height: 10),

              /// 按钮
              MyButton.elevated(
                label: '确认提交',
                onPressed: _handleClickButton,
                disabled: _disabled,
                loading: _loading,
              )
            ],
          ),
        ));
  }
}
