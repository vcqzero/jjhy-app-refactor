import 'dart:developer';

import 'package:app/Config.dart';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/pages/about/PrivacyPage.dart';
import 'package:app/utils/MyDownloader.dart';
import 'package:app/utils/MyPackage.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AboutPage extends StatefulWidget {
  static String routeName = 'AboutPage';
  AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? _versionName;
  AppVersion? _newVersion;
  MyDownloader? downloader;

  @override
  void initState() {
    super.initState();
    _handleInitPackageInfo();
    downloader = MyDownloader();
  }

  @override
  void dispose() {
    if (downloader != null) downloader!.unbindBackgroundIsolate();
    super.dispose();
  }

  _handleInitPackageInfo() async {
    MyPackage package = MyPackage();
    PackageInfo? packageInfo = await package.getPackageInfo();
    AppVersion? newVersion = await package.checkVersion();
    if (packageInfo != null) {
      setState(() {
        _versionName = packageInfo.version;
        _newVersion = newVersion;
      });
    }
  }

  _handleClickVersion() async {
    log('处理新版本');
    String url = 'https://api.jjhycom.cn/storage/apks/jingjiu-v1.6.0.apk';
    String filename = 'jingjiu.apk';

    if (downloader != null)
      downloader!.downloadFile(url: url, filename: filename);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: MyAppBar.build(title: '关于'),
      body: Column(
        children: [
          // logo部分
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            // color: Colors.white,
            width: double.infinity,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  child: Image.asset(ImageAssets.logoInAbout),
                ),
                SizedBox(height: 6),
                Text(Config.appName, style: TextStyle(color: Colors.black54)),
                Text(
                  '京玖恒阳智慧工地系统',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('隐私条款'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.of(context).pushNamed(PrivacyPage.routeName),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.copyright_sharp),
                  title: Text("版本: v${_versionName ?? ''}"),
                  trailing: _newVersion != null
                      ? Container(
                          width: 100,
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Chip(
                                padding: EdgeInsets.all(0),
                                backgroundColor: Colors.deepPurple,
                                label: Text('新版本',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        )
                      : Text(
                          '已是最新',
                          style: TextStyle(color: Colors.grey),
                        ),
                  onTap: _newVersion != null
                      ? () => {_handleClickVersion()}
                      : null,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
