import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './pages/home/Index.dart';

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
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
      },
    );
  }
}
