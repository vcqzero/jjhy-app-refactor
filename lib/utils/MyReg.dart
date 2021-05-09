class MyReg {
  static String? errMsg;

  /// 手机号验证
  static bool isChinaPhoneLegal(String str) {
    bool valid = RegExp(
            r"^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$")
        .hasMatch(str);
    errMsg = valid ? null : "请输入正确手机号";
    return valid;
  }

  /// 验证是否是数字
  static bool isNumber(String str) {
    return RegExp(r"^\d{1,}$").hasMatch(str);
  }

  /// 验证密码
  static bool validPassword(String str) {
    bool valid = RegExp(r"^(?:\d+|[a-zA-Z]+|[!@#$%^&-_*]+){6}$").hasMatch(str);
    errMsg = valid ? null : "密码至少6位（字母、数字、!@#\$%^&-_*组合）";
    return valid;
  }

  /// 验证用户名
  static bool validUsername(String str) {
    bool valid = RegExp(r"^[a-zA-Z0-9_-]{4,16}$").hasMatch(str);
    errMsg = valid ? null : "4到16位（字母，数字，下划线，减号）";
    return valid;
  }

  /// 验证nickname
  static bool validNickname(String str) {
    int maxLen = 20;
    bool valid = str.length < maxLen;
    errMsg = valid ? null : "长度不可超过$maxLen个字符";
    return valid;
  }
}
