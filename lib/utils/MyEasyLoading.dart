import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyEasyLoading {
  // 配置loading
  static config() {
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.threeBounce;
    // ..loadingStyle = EasyLoadingStyle.light;
  }

  // 显示loading
  static loading(String? status) {
    EasyLoading.show(status: status);
  }

  // 关闭loading
  static void hide() {
    EasyLoading.dismiss();
  }

  // 显示success
  static success(status) {
    EasyLoading.showSuccess(status);
  }

  /// 显示toast
  static toast(String msg) {
    if (msg.isNotEmpty) EasyLoading.showToast(msg);
  }
}
