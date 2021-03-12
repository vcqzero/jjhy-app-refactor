import 'package:app/api/AppSetings.dart';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/pages/home/widges/TheIconItem.dart';
import 'package:app/store/store.dart';
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
    _queryBanner();
    print(store.state.user.id);
  }

  void _queryBanner() {
    final MyResponse res = AppSetings.getBanners();
    cancelToken = res.cancelToken;
    res.future.then((response) {
      final String? imgUrl = response.data?['items']?[0]?['url'];
      if (imgUrl != null) {
        setState(() {
          imageUrl = imgUrl;
        });
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  /// 加载banner
  Widget _getBannerImageWidget() {
    if (imageUrl == null) {
      return Image.asset(ImageAssets.defaultBannerImage);
    } else {
      return Image.network(imageUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(hidden: true, title: ''),
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

  @override
  void dispose() {
    // 取消网络请求
    if (cancelToken != null) {
      cancelToken!.cancel();
    }
    super.dispose();
  }
}
