import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';

class MyDeviceInfo {
  late int versionRelease;
  // _getAndroidInfo(AndroidDeviceInfo device) {
  //   // device.version.c
  // }
  static test() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo device = await DeviceInfoPlugin().androidInfo;
        log('------');
        log(device.version.codename);
        log(device.version.release);
      }
    } catch (e) {
      log('message', error: e);
    }
  }
}
