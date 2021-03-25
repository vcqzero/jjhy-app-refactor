import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
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
  TextEditingController _textEditingController = TextEditingController();
  String? _helper;
  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.val ?? '';
  }

  _handleInputChange(String val) {
    bool isOverLen = val.length > 20;
    setState(() {
      // 按钮是否disabled
      _disabled = val.isEmpty || val == widget.val || isOverLen;
      // 是否长度
      _helper = isOverLen ? '长度不可超过20个字符' : null;
    });
  }

  _handleUpdate() {
    String val = _textEditingController.text;
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
              )
            ],
          ),
        ));
  }
}
