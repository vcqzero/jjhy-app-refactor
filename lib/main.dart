import 'package:app/pages/login/Index.dart';
import 'package:app/pages/login/TypeCodePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/utils/MyToast.dart';
import 'package:get_storage/get_storage.dart';
import 'pages/home/Index.dart';
import './pages/todo/Index.dart';
import './pages/profile/Index.dart';
import './pages/profile/Settings.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
  // 定义状态栏

  // 禁止横屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '京9',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      // initialRoute: MainPage.routeName,
      routes: {
        SettingsPage.routeName: (context) => SettingsPage(),
        LoginPage.routeName: (context) => LoginPage(),
        LoginTypeCodePage.routeName: (context) => LoginTypeCodePage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
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
      'body': HomePage(),
    },
    {
      'title': '待办',
      'icon': Icons.today_outlined,
      'body': TodoPage(),
    },
    {
      'title': '我的',
      'icon': Icons.person,
      'body': ProfilePage(),
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
              setState(() {
                currentIndex = index;
              })
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
