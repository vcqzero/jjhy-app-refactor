import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:www/utils/toast.dart';
import './pages/home/Index.dart';
import './pages/todo/Index.dart';
import './pages/profile/Index.dart';
import './pages/profile/Settings.dart';

void main() {
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

  DateTime lastBackTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            toolbarHeight: 0,
          ),
          body: mainPages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => {
              setState(() {
                currentIndex = index;
              })
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.today_outlined), label: '待办'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
            ],
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
