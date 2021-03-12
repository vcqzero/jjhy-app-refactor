class MyReg {
  /// 手机号验证
  static bool isChinaPhoneLegal(String str) {
    return RegExp(
            r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(str);
  }

  /// 验证是否是数字
  static bool isNumber(String str) {
    return RegExp(r"^\d{1,}$").hasMatch(str);
  }
}
