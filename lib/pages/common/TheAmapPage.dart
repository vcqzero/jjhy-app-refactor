import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:app/utils/MyLocation.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:flutter/material.dart';

class TheAmapPage extends StatefulWidget {
  TheAmapPage({Key? key}) : super(key: key);

  @override
  _TheAmapPageState createState() => _TheAmapPageState();
}

class _TheAmapPageState extends State<TheAmapPage> {
  MyLocation? _myLocation;
  onLocated(Map<String, Object> result) {}

  @override
  void initState() {
    _myLocation = MyLocation(onLocated: onLocated);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(title: 'Amap 地图'),
      body: Container(
        child: MyButton.elevated(
          label: '开始定位',
          onPressed: () {
            print('开始定位');
            if (_myLocation != null) _myLocation!.startLocation();
          },
        ),
      ),
    );
  }
}
