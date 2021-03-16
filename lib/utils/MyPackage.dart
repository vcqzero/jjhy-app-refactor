import 'dart:developer';

import 'package:app/api/AppSetings.dart';
import 'package:app/utils/MyDio.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  final String? buildCode;
  final String? version;
  final String? downloadUrl;
  final String? appStoreUrl;
  const AppVersion({
    this.appStoreUrl,
    this.buildCode,
    this.downloadUrl,
    this.version,
  });
}

class MyPackage {
  /// 获取package
  Future<PackageInfo?> getPackageInfo() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo;
    } catch (e) {
      log('message', error: e);
    }
  }

  /// 是否有新版本
  Future<AppVersion?> checkVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String buildCode = packageInfo.buildNumber;
      MyResponse res = AppSetings.checkVersion(buildCode: buildCode);
      Map? version = await res.future.then((value) => value.data['version']);
      if (version == null) return null;
      return AppVersion(
        buildCode: version['version_code'].toString(),
        version: version['version_name'],
        downloadUrl: version['download_url'],
        appStoreUrl: version['app_store_url'],
      );
    } on DioError catch (e) {
      log('MyPackage 检查版本错误', error: e);
    }
  }
}
