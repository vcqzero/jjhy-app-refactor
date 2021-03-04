import 'package:fluttertoast/fluttertoast.dart';

class MyToast {
  /// 显示toast
  static void show(String msg) {
    print(msg);
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  /// 清除所有toast
  static void clear() {
    Fluttertoast.cancel();
  }
}
