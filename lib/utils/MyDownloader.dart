import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MyDownloader {
  ReceivePort _port = ReceivePort();
  MyDownloader() {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(_downloadCallback);
  }
  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      'downloader_send_port',
    );
    if (!isSuccess) {
      unbindBackgroundIsolate();
      // _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      // String id = data[0];
      // DownloadTaskStatus status = data[1];
      int progress = data[2];
      print(progress);
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void _downloadCallback(
    String id,
    DownloadTaskStatus status,
    int progress,
  ) {
    SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) send.send([id, status, progress]);
  }

  /// 下载文件
  downloadFile({
    required String url,
    required String filename,
  }) async {
    try {
      Directory tempDir = await getTemporaryDirectory(); // 获取临时目录
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
}
