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

  Widget _getItemTile(int index) {
    Map workyard = _user.workyards?[index] ?? {};
    String? name = workyard['name'];
    int? id = workyard['id'];
    Map? pivot = workyard['pivot'];
    String? roleName = pivot?['role'];
    String roleLabel = MyRoles().getLabel(roleName);
    bool isUsing = id != null &&
        _user.workyard?['id'] != null &&
        id == _user.workyard?['id'];

    return MyTile(
      title: name ?? '',
      subtitle: roleLabel,
      trailingWidget: isUsing
          ? Text(
              '正在使用',
              style: TextStyle(color: Colors.green),
            )
          : Text('切换'),
      onTap: isUsing ? null : () {},
    );
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
        body: ListView.builder(
          itemBuilder: (context, index) {
            return _getItemTile(index);
          },
          itemCount: _user.workyards?.length,
        ),
      ),
    );
  }
}
