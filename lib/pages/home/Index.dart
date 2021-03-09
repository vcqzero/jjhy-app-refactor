import 'package:app/api/AppSetings.dart';
import 'package:app/assets/MyImages.dart';
import 'package:app/pages/home/Widges/TheIconItem.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/MyWidgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? imageUrl;
  @override
  void initState() {
    super.initState();
    AppSetings.getBanners().then((response) {
      final String? imgUrl = response.data?['items']?[0]?['url'];
      if (imgUrl != null) {
        setState(() {
          imageUrl = imgUrl;
        });
      }
    });
  }

  /// 加载banner
  Widget _getBannerImageWidget() {
    if (imageUrl == null) {
      return Image.asset(MyImages.defaultBannerImage);
    } else {
      return Image.network(imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgets.getAppBar(hidden: true),
      body: Column(
        children: [
          Container(
            child: _getBannerImageWidget(),
            margin: EdgeInsets.only(bottom: 10),
          ),
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                TheIconItem(
                  icon: Icons.wifi,
                  lable: '答题上网',
                  color: Colors.pink[400],
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
