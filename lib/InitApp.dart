import 'dart:developer';

import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyLoading.dart';
import 'api/UserApi.dart';

class InitApp {
  void initLoadingConfig() => MyLoading.config(); // 配置loading
  Future<void> initUserData() async {
    try {
      MyResponse res = UserApi.querySignedUser();
      Map userMap = await res.future.then((value) => value.data['user']);
      await User.store(userMap);
    } catch (e) {
      log('init user error', error: e);
    }
  }
}
