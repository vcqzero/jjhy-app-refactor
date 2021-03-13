class MyReg {
  /// 手机号验证
  static bool isChinaPhoneLegal(String str) {
    return RegExp(
            r"^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$")
        .hasMatch(str);
  }

  /// 验证是否是数字
  static bool isNumber(String str) {
    return RegExp(r"^\d{1,}$").hasMatch(str);
  }
}
