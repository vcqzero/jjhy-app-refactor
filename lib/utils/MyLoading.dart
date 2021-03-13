import 'package:flutter_easyloading/flutter_easyloading.dart';

class MyLoading {
  // 配置loading
  static config() {
    EasyLoading.instance..indicatorType = EasyLoadingIndicatorType.threeBounce;
    // ..loadingStyle = EasyLoadingStyle.light;
  }

  // 显示loading
  static showLoading(String? status) {
    EasyLoading.show(status: status);
  }

  // 关闭loading
  static void dismiss() {
    EasyLoading.dismiss();
  }

  // 显示success
  static success(status) {
    EasyLoading.showSuccess(status);
  }
}
