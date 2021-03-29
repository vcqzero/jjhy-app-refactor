import 'package:app/config/Config.dart';
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
  List<Widget> _renderRolesTile() {
    MyRoles myRoles = MyRoles();
    List<Widget> children = [
      SizedBox(height: 15),
    ];

    // 项目管理员
    if (widget._user.isSuperAdmin) {
      children.add(MyTile(
        title: myRoles.getLabel('super_admin'),
      ));
    }

    // 项目相关角色
    List rolesAll = widget._user.rolesAll ?? [];
    List<Map> workyardRoles = myRoles.getWorkyardRoles(rolesAll);
    if (workyardRoles.isNotEmpty) {
      print(workyardRoles);
      children.add(SizedBox(height: 15));
      workyardRoles.forEach((Map item) {
        if (item['workyard'] != null) {
          children.add(MyTile(
            title: myRoles.getLabel(item['role']),
            trailingString: item['workyard']['name'],
          ));
          children.add(Divider(height: 1));
        }
      });
    }

    // 公司相关角色
    // List<Map> companyRoles = myRoles.getCompanyRoles(rolesAll);
    // if (workyardRoles.isNotEmpty) {
    //   children.add(SizedBox(height: 15));
    //   workyardRoles.forEach((Map item) {
    //     children.add(MyTile(
    //       title: myRoles.getLabel(item['role']),
    //     ));
    //     children.add(Divider(height: 1));
    //   });
    // }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.pageBackgroudColor,
      appBar: MyAppBar.build(title: '我的角色'),
      body: Column(
        children: _renderRolesTile(),
      ),
    );
  }
}
