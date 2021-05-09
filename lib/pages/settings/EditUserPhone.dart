import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:flutter/material.dart';

class SettingsEditUserPhone extends StatefulWidget {
  SettingsEditUserPhone({Key? key}) : super(key: key);

  @override
  SettingsEditUserPhoneState createState() => SettingsEditUserPhoneState();
}

class SettingsEditUserPhoneState extends State<SettingsEditUserPhone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(title: '设置新手机'),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '请输入新手机号',
              ),
            ),
            SizedBox(height: 10),
            // 输入code
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(),
                ),
                Expanded(
                  flex: 1,
                  child: MyButton.elevated(
                    label: '重新发送',
                    onPressed: () {},
                    fullWidth: false,
                  ),
                ),
                // Text('data')
              ],
            )
          ],
        ),
      ),
    );
  }
}
