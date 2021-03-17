import 'dart:developer';
import 'package:app/Config.dart';
import 'package:app/routes.dart';
import 'package:app/utils/MyPackage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/utils/MyToast.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'InitApp.dart';
import 'pages/home/Index.dart';
import './pages/todo/Index.dart';
import './pages/profile/Index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true); // 初始化下载
  await GetStorage.init(); // 初始化storage
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 禁止横屏
  ]);
  // init app
  log('main-> init App');
  InitApp()
    ..initLoadingConfig()
    ..initUserData();
}

final RouteObserver routeObserver = RouteObserver();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
      ],
      debugShowCheckedModeBanner: false,
      title: Config.appName,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MainPage(),
      initialRoute: MainPage.routeName,
      builder: EasyLoading.init(),
      navigatorObservers: [routeObserver],
      routes: routes,
    );
  }
}

class MainPage extends StatefulWidget {
  static String routeName = '/';
  MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List mainPages = [HomePage(), TodoPage(), ProfilePage()];
  List pageConfigs = [
    {
      'title': '首页',
      'icon': Icons.home,
      'body': HomePage(key: PageStorageKey('home')),
    },
    {
      'title': '待办',
      'icon': Icons.today_outlined,
      'body': TodoPage(key: PageStorageKey('todo')),
    },
    {
      'title': '我的',
      'icon': Icons.person,
      'body': ProfilePage(key: PageStorageKey('my')),
    },
  ];

  /// 获取底部配置内容
  get bottomItems {
    int len = pageConfigs.length;
    List<BottomNavigationBarItem> items = [];
    for (var i = 0; i < len; i++) {
      items.add(
        BottomNavigationBarItem(
            icon: Icon(pageConfigs[i]['icon']), label: pageConfigs[i]['title']),
      );
    }
    return items;
  }

  DateTime lastBackTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          // appBar: MyWidgets.getAppBar(),
          body: pageConfigs[currentIndex]['body'],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => {
              setState(() => {currentIndex = index})
            },
            items: bottomItems,
          ),
        ),
        onWillPop: () async {
          DateTime time = lastBackTime.add(const Duration(milliseconds: 1000));
          DateTime now = DateTime.now();
          bool exitApp = true;
          // 如果当前时间是在上一次点击的1s中以内，执行，否则提示toast
          if (now.isAfter(time)) {
            MyToast.show('再次点击,退出应用');
            exitApp = false;
          }
          lastBackTime = now;
          return exitApp;
        });
  }
}
