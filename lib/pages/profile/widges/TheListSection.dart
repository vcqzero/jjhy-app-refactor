import 'package:app/assets/ImageAssets.dart';
import 'package:app/widgets/MyTile.dart';
import 'package:flutter/material.dart';

class TheListSection extends StatelessWidget {
  const TheListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: [
        Divider(height: 1),
        // 昵称
        MyTile(
          title: '我的项目',
          trailingString: '未设置',
          leadingSvg: SvgAssets.workyard,
          leadingSvgColor: Colors.blue,
          onTap: () {},
        ),
      ],
    );
  }
}
