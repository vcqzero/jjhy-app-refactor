class MyMode {
  /// 是否生产环境
  static bool inProduction = const bool.fromEnvironment("dart.vm.product");
}
