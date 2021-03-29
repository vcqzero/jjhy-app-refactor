import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:app/utils/MyPackage.dart';
import 'package:app/utils/MyPermission.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TheVersionList extends StatefulWidget {
  TheVersionList({Key? key}) : super(key: key);

  @override
  _TheVersionListState createState() => _TheVersionListState();
}

class _TheVersionListState extends State<TheVersionList> {
  AppVersion? _newVersion; // 是否有新版本，非空 代表有新版本
  String? _curVersionName;

  @override
  void initState() {
    super.initState();
    _handleInitPackageInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleInitPackageInfo() async {
    MyPackage package = MyPackage();
    PackageInfo? packageInfo = await package.getPackageInfo();
    AppVersion? newVersion = await package.checkVersion();
    if (packageInfo != null) {
      setState(() {
        _curVersionName = packageInfo.version;
        _newVersion = newVersion;
      });
    }
  }

  _handleInstall(filename) async {
    bool hasPermission = await MyPermission().haveInstallPermission();
    if (hasPermission == false) {
      await MyPermission().requestInstallPermission();
    } else {
      OpenResult res = await OpenFile.open(filename);
      print(res.message);
      print(res.type);
    }
  }

  _handleDownloadApk() async {
    if (_newVersion == null) return;
    if (Platform.isIOS) {
      return;
    }
    // 请求权限
    bool res = await Permission.storage.request().isGranted;
    if (!res) return;
    String? url = _newVersion!.downloadUrl;
    String? version = _newVersion!.version;
    Directory? dir = await getExternalStorageDirectory();
    if (dir == null || url == null || version == null) return;
    String filename = dir.path + '/jingjiu_$version.apk';
    log(filename);
    // 判断是否存在
    File _apkFile = File(filename);
    bool exists = await _apkFile.exists();
    if (exists) return _handleInstall(filename);
    // 不存在则重新下载
    await Dio().download(
      url,
      filename,
      onReceiveProgress: (received, total) {
        print('$received/$total');
        if (received >= total) {
          print('下载完成');
          _handleInstall(filename);
        }
      },
    );
    try {} catch (e) {
      log('download 错误', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNewVersion = _newVersion != null;
    return ListTile(
      leading: Icon(
        Icons.copyright_sharp,
        color: Colors.blue,
      ),
      title: Text("版本: v${_curVersionName ?? ''}"),
      trailing: hasNewVersion
          ? Container(
              width: 100,
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Chip(
                    padding: EdgeInsets.all(0),
                    backgroundColor: Colors.deepPurple,
                    label: Text('新版本', style: TextStyle(color: Colors.white)),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            )
          : Text(
              '已是最新',
              style: TextStyle(color: Colors.grey),
            ),
      onTap: hasNewVersion ? _handleDownloadApk : null,
    );
  }
}
