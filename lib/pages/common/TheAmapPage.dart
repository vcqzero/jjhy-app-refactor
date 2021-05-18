import 'package:app/utils/MyLocation.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:permission_handler/permission_handler.dart';

class TheAmapPage extends StatefulWidget {
  TheAmapPage({Key? key}) : super(key: key);

  @override
  _TheAmapPageState createState() => _TheAmapPageState();
}

class _TheAmapPageState extends State<TheAmapPage> {
  MyLocation? _myLocation;
  onLocated(LocationResult result) {
    print('获取到定位数据');
    print(result.address);
    print(result.latitude);
    print(result.longitude);
  }

  @override
  void initState() {
    _myLocation = MyLocation(onLocated: onLocated);
    super.initState();
    _checkPermissions();
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 10.0,
  );
  final List<Permission> needPermissionList = [
    Permission.location,
    Permission.storage,
    Permission.phone,
  ];
  void _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await needPermissionList.request();
    statuses.forEach((key, value) {
      print('$key premissionStatus is $value');
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    _checkPermissions();
  }

  AMapController? _mapController;
  void onMapCreated(AMapController controller) {
    setState(() {
      _mapController = controller;
      // getApprovalNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      initialCameraPosition: _kInitialPosition,
      onMapCreated: onMapCreated,
    );
    return Scaffold(
      appBar: MyAppBar.build(title: 'Amap 地图'),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: map,
      ),
    );
  }
}
