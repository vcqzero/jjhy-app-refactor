import 'package:app/api/AppSetings.dart';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/pages/common/TheAmapPage.dart';
import 'package:app/pages/home/widges/TheIconItem.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? imageUrl;
  CancelToken? cancelToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // 从pageStorage中读取数据
    String? imageUrlInStorage =
        PageStorage.of(context)!.readState(context, identifier: 'imageUrl');
    if (imageUrlInStorage != null) {
      setState(() => {imageUrl = imageUrlInStorage});
    } else {
      _handleQueryBanner();
    }
    super.didChangeDependencies();
  }

  void _handleQueryBanner() async {
    try {
      MyResponse res = AppSetings.getBanners();
      cancelToken = res.cancelToken;
      String? imgUrl = await res.future.then((r) => r.data['items'][0]['url']);
      if (imgUrl == null) return;
      setState(() {
        imageUrl = imgUrl;
        PageStorage.of(context)!
            .writeState(context, imageUrl, identifier: 'imageUrl');
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  /// 加载banner
  Widget _renderBannerImage() {
    if (imageUrl == null) {
      return Image.asset(ImageAssets.defaultBannerImage);
    } else {
      return Image.network(
        imageUrl!,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Image.asset(ImageAssets.defaultBannerImage);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: MyAppBar.build(hidden: true, title: ''),
      body: Column(
        children: [
          // 顶部banner
          Container(
            child: _renderBannerImage(),
            margin: EdgeInsets.only(bottom: 10),
          ),
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                TheIconItem(
                  icon: Icons.wifi,
                  lable: '答题上网',
                  color: Colors.pink[400],
                ),
                TheIconItem(
                  icon: Icons.wifi,
                  lable: 'Test',
                  color: Colors.pink[400],
                  onTap: () {
                    print('object');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TheAmapPage()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 取消网络请求
    if (cancelToken != null && mounted) cancelToken!.cancel();
    super.dispose();
  }
}
