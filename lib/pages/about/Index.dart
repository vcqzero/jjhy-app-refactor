import 'package:app/assets/ImageAssets.dart';
import 'package:app/config/Config.dart';
import 'package:app/pages/about/PrivacyPage.dart';
import 'package:app/pages/about/widgets/TheVersionList.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  static String routeName = 'AboutPage';
  AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
                Text('京玖恒阳智慧工地系统',
                    style: TextStyle(fontSize: 12, color: Colors.black54))
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
                TheVersionList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
