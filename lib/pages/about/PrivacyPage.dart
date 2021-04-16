import 'dart:developer';

import 'package:app/config/Config.dart';
import 'package:app/utils/MyEasyLoading.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPage extends StatefulWidget {
  static String routeName = 'PrivacyPage';
  PrivacyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: MyAppBar.build(title: '隐私政策'),
          body: Builder(builder: (BuildContext context) {
            return WebView(
              initialUrl: Config.privacyUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (url) => MyEasyLoading.loading(null),
              onPageFinished: (url) => MyEasyLoading.hide(),
              onWebResourceError: (WebResourceError err) {
                log('加载错误', error: err);
                MyEasyLoading.hide();
              },
            );
          }),
        ),
        onWillPop: () {
          MyEasyLoading.hide();
          return Future.value(true);
        });
  }
}
