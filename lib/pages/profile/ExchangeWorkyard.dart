import 'package:app/assets/ImageAssets.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyRoles.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyTile.dart';
import 'package:flutter/material.dart';

class ExchangeWorkyard extends StatefulWidget {
  ExchangeWorkyard({Key? key}) : super(key: key);

  @override
  _ExchangeWorkyardState createState() => _ExchangeWorkyardState();
}

class _ExchangeWorkyardState extends State<ExchangeWorkyard> {
  late User _user;

  @override
  void initState() {
    _user = User.cached();
    super.initState();
  }

  List _getWorkyardTiles() {
    List<Widget> tilss = [];
    _user.workyards?.forEach((workyard) {
      String? name = workyard['name'];
      int? id = workyard['id'];
      Map? pivot = workyard['pivot'];
      String? roleName = pivot?['role'];
      String roleLabel = MyRoles().getLabel(roleName);
      bool isUsing = id != null &&
          _user.workyard?['id'] != null &&
          id == _user.workyard?['id'];
      tilss.add(
        MyTile(
          title: name ?? '',
          subtitle: roleLabel,
          trailingString: isUsing ? '正在使用' : null,
          onTap: isUsing ? null : () {},
        ),
      );
    });
    return tilss;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: MyAppBar.build(
          title: '切换项目',
          actions: [
            IconButton(
              icon: Text('新增'),
              tooltip: "新增项目",
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Divider(height: 1),
            ..._getWorkyardTiles()
          ],
        ),
      ),
    );
  }
}
