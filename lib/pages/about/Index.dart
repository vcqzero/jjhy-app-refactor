import 'dart:developer';

import 'package:app/Config.dart';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/utils/MyPackage.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  static String routeName = 'AboutPage';
  AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? _versionName;
  AppVersion? _newVersion;

  @override
  void initState() {
    super.initState();
    _handleInitPackageInfo();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _handleClickVersion() {
    log('处理新版本');
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
                  onTap: () {
                    print('object');
                  },
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
