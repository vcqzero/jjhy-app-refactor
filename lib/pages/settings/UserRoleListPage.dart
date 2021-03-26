import 'package:app/app/Config.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyRoles.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyTile.dart';
import 'package:flutter/material.dart';

class UserRoleListPage extends StatefulWidget {
  static const routeName = "UserRoleIistPage";
  final User _user = User.cached();

  UserRoleListPage({
    Key? key,
  }) : super(key: key);

  @override
  _UserRoleListPageState createState() => _UserRoleListPageState();
}

class _UserRoleListPageState extends State<UserRoleListPage> {
  List<Widget> _handleGetRolesChileren() {
    MyRoles myRoles = MyRoles();
    List<Widget> children = [];
    // 项目管理员
    if (widget._user.isSuperAdmin) {
      children.add(MyTile(title: myRoles.getLabel('super_admin') ?? ''));
    }
    // 项目相关角色

    // 公司相关角色
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Config.pageBackgroudColor,
        appBar: MyAppBar.build(title: '我的角色'),
        body: Container(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            children: _handleGetRolesChileren(),
          ),
        ));
  }
}
