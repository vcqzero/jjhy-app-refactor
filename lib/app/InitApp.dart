import 'dart:developer';

import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyLoading.dart';
import '../api/UserApi.dart';
import '../store/Token.dart';

class InitApp {
  void initLoadingConfig() => MyLoading.config(); // 配置loading
  Future<void> initUserData() async {
    try {
      // 判断是否存在token
      String? token = Token().val;
      if (token == null || token.isEmpty) return log('InitApp-> token无效');
      MyResponse res = UserApi.querySignedUser();
      Map userMap = await res.future.then((value) => value.data['user']);
      await User.store(userMap);
    } catch (e) {
      log('InitApp-> init user error', error: e);
    }
  }
}
