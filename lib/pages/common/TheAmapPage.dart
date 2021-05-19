import 'package:app/widgets/MyAppBar.dart';
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
  // MyLocation? _myLocation;
  AMapController? _mapController;
  String? _mapContentApprovalNumber; // 普通地图审图号
  String? _satelliteImageApprovalNumber; // 卫星地图审图号

  // onLocated(LocationResult result) {
  //   print('获取到定位数据');
  //   print(result.address);
  //   print(result.latitude);
  //   print(result.longitude);
  // }

  @override
  void initState() {
    // _myLocation = MyLocation(onLocated: onLocated);
    super.initState();
    _checkPermissions();
  }

  /// 检查地图所需权限
  void _checkPermissions() async {
    final List<Permission> needPermissionList = [
      Permission.location,
      Permission.storage,
      Permission.phone,
    ];
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

  void _onMapCreated(AMapController controller) {
    _mapController = controller;
    setState(() {
      getApprovalNumber();
    });
  }

  /// 获取地图审图号
  void getApprovalNumber() async {
    // 普通地图审图号
    _mapContentApprovalNumber =
        await _mapController?.getMapContentApprovalNumber();
    // 卫星地图审图号
    _satelliteImageApprovalNumber =
        await _mapController?.getSatelliteImageApprovalNumber();
  }

  void _onCameraMoveEnd(CameraPosition cameraPosition) {
    if (null == cameraPosition) {
      return;
    }
    print('_onCameraMoveEnd===> ${cameraPosition.toMap()}');
  }

  @override
  Widget build(BuildContext context) {
    // 创建地图
    final AMapWidget map = AMapWidget(
      // 设置地图center坐标
      initialCameraPosition: const CameraPosition(
        target: LatLng(39.909187, 116.397451),
        zoom: 15.0,
      ),
      onMapCreated: _onMapCreated,
      onCameraMoveEnd: _onCameraMoveEnd,
    );

    return Scaffold(
      appBar: MyAppBar.build(title: 'Amap 地图'),
      body: Column(
        children: [
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: map,
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _mapContentApprovalNumber ?? '',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          _satelliteImageApprovalNumber ?? '',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
