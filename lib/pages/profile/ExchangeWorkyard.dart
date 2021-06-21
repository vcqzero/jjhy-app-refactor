import 'dart:developer';

import 'package:app/api/UserApi.dart';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDialog.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyEasyLoading.dart';
import 'package:app/utils/MyRoles.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ExchangeWorkyard extends StatefulWidget {
  ExchangeWorkyard({Key? key}) : super(key: key);

  @override
  _ExchangeWorkyardState createState() => _ExchangeWorkyardState();
}

class _ExchangeWorkyardState extends State<ExchangeWorkyard> {
  late User _user;
  CancelToken? _cancelToken;
  bool _loading = false;

  @override
  void initState() {
    _user = User.cached();
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }

  _exchangeWrokyard(int? wid) async {
    try {
      if (_loading || wid == null) return;
      _loading = true;

      MyEasyLoading.loading('切换中...');
      MyResponse res = UserApi.exchangeWorkyard(wid);
      _cancelToken = res.cancelToken;
      await res.future.then((value) => null);
      await User.reload();
      setState(() {
        _user = User.cached();
      });
      MyEasyLoading.success('操作成功');
    } catch (e) {
      log('错误', error: e);
    } finally {
      _loading = false;
      MyEasyLoading.hide();
    }
  }

  Widget _getItemTile(int index, BuildContext context) {
    Map workyard = _user.workyards?[index] ?? {};
    String? name = workyard['name'];
    int? wid = workyard['id'];
    Map? pivot = workyard['pivot'];
    String? roleName = pivot?['role'];
    String roleLabel = MyRoles().getLabel(roleName);
    bool isUsing = wid != null &&
        _user.workyard?['id'] != null &&
        wid == _user.workyard?['id'];

    return MyTile(
      title: name ?? '',
      subtitle: roleLabel,
      trailingWidget: isUsing
          ? Text(
              '正在使用',
              style: TextStyle(color: Colors.green),
            )
          : Text('切换'),
      onTap: isUsing
          ? null
          : () {
              MyDialog(
                context,
                title: '提示',
                textChildren: [Text('切换至此项目?')],
                onConfirm: () => {_exchangeWrokyard(wid)},
              ).open();
            },
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
          itemBuilder: (c, index) {
            return _getItemTile(index, context);
          },
          itemCount: _user.workyards?.length,
        ),
      ),
    );
  }
}
