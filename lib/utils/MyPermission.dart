import 'dart:developer';
import 'dart:io';

import 'package:app/utils/MyMethodChannel.dart';

class MyPermission {
  /// 判断是否有安装apk权限,only for android
  Future<bool> haveInstallPermission() async {
    bool res = true;
    try {
      if (Platform.isAndroid == false) return res;
      res = await myMethodChannel.invokeMethod('haveInstallPermission');
    } catch (e) {
      log('获取权限错误', error: e);
    }
    return res;
  }

  Future<void> requestInstallPermission() async {
    try {
      if (Platform.isAndroid == false) return;
      await myMethodChannel.invokeMethod('requestInstallPermission');
    } catch (e) {
      log('请求权限错误', error: e);
    }
  }
}
