import 'package:app/Config.dart';
import 'package:app/utils/MyLoading.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: MyAppBar.build(title: '隐私政策'),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: Config.privacyUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url) => MyLoading.showLoading(null),
          onPageFinished: (url) => MyLoading.hide(),
        );
      }),
    );
  }
}
