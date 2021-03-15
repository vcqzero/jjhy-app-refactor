import 'dart:developer';

import 'package:app/api/AppSetings.dart';
import 'package:app/assets/ImageAssets.dart';
import 'package:app/pages/home/widges/TheIconItem.dart';
import 'package:app/store/LoginFormStore.dart';
import 'package:app/store/User.dart';
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
    log('_HomePageState->initState');
    super.initState();
    _handleQueryBanner();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _handleQueryBanner() async {
    try {
      MyResponse res = AppSetings.getBanners();
      cancelToken = res.cancelToken;
      String? imgUrl = await res.future.then((r) => r.data['items'][0]['url']);
      if (imgUrl != null) setState(() => {imageUrl = imgUrl});
    } on DioError catch (e) {
      print(e);
    }
  }

  /// 加载banner
  Widget _renderBannerImage() {
    if (imageUrl == null) return Image.asset(ImageAssets.defaultBannerImage);
    return Image.network(imageUrl!);
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
              children: [
                TheIconItem(
                  icon: Icons.wifi,
                  lable: '答题上网',
                  color: Colors.pink[400],
                )
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
