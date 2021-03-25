class MyString {
  /// 手机号隐藏中间4位
  static String encryptPhone(String phone) {
    if (phone.length < 4) return '';
    return phone.replaceRange(3, 7, '****');
  }
}
