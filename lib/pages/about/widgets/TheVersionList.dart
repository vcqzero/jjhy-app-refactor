import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app/utils/MyPackage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
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
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _handleInitPackageInfo();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
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

  _handleDownloadApk() async {
    log('处理新版本');
    // 请求权限
    bool res = await Permission.storage.request().isGranted;
    if (!res) return;
    // 绑定回调函数
    // 判断权限
    // 下载
    // 监听下载

    String url = 'https://api.jjhycom.cn/storage/apks/jingjiu-v1.6.0.apk';
    String filename = 'jingjiu.apk';

    try {
      Directory? tempDir = await getExternalStorageDirectory(); // 获取临时目录
      /**
       * 需要添加读取权限
       * 和下载路径
       * permission_handler path_provider
       */
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: tempDir.path,
        fileName: filename,
        // showNotification: true,
        // openFileFromNotification: true,
      );
      // await FlutterDownloader.loadTasks();
    } catch (e) {
      log('download 错误', error: e);
    }
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      // _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print('UI Isolate Callback: $data');
    });
    log('bind success');
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasNewVersion = _newVersion != null;
    return ListTile(
      leading: Icon(Icons.copyright_sharp),
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
