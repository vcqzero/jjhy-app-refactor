import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/home/Index.dart';
import './pages/todo/Index.dart';
import './pages/profile/Index.dart';

void main() {
  runApp(MyApp());
  // 定义状态栏
  // SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
  //   statusBarColor: Colors.lightBlue.shade800,
  // );
  // SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      // initialRoute: MainPage.routeName,
      // routes: {
      //   MainPage.routeName: (context) => MainPage(),
      // },
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List mainPages = [HomePage(), TodoPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
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
    );
  }
}
