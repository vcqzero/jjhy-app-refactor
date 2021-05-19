import 'dart:developer';

import 'package:app/api/AmapApi.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:permission_handler/permission_handler.dart';

class TheAmapPage extends StatefulWidget {
  double? latitude;
  double? longitude;
  String? address;
  TheAmapPage({
    Key? key,
    this.address,
    this.latitude,
    this.longitude,
  }) : super(key: key);

  @override
  _TheAmapPageState createState() => _TheAmapPageState();
}

class _TheAmapPageState extends State<TheAmapPage> {
  // MyLocation? _myLocation;
  AMapController? _mapController;
  String? _mapContentApprovalNumber; // 普通地图审图号
  String? _satelliteImageApprovalNumber; // 卫星地图审图号

  String? _pickedAddress; // 选择的地址
  double? _pickedLatitude; // 选择的维度
  double? _pickedLongitude; // 选择的经度
  TextEditingController _inputController = TextEditingController();

  CancelToken? _cancelToken;

  // onLocated(LocationResult result) {
  //   print('获取到定位数据');
  //   print(result.address);
  //   print(result.latitude);
  //   print(result.longitude);
  // }

  @override
  void initState() {
    // _myLocation = MyLocation(onLocated: onLocated);
    _inputController.text = widget.address ?? '';
    _checkPermissions();
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
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
    setState(() => {getApprovalNumber()});
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
    _pickedLatitude = cameraPosition.target.latitude;
    _pickedLongitude = cameraPosition.target.longitude;
    _queryAddress(_pickedLatitude!, _pickedLongitude!);
  }

  void _queryAddress(latitude, longitude) async {
    try {
      _cancelToken?.cancel();
      MyResponse res =
          AmapApi.regeo(longitude: longitude!, latitude: latitude!);
      Map data = await res.future.then((value) => value.data);
      _cancelToken = res.cancelToken;

      // 根据status，判断是否请求成功
      // https://lbs.amap.com/api/webservice/guide/api/georegeo
      String status = '${data['status']}';
      if (status != '1') {
        throw data['info'] ?? '返回状态 != 1';
      }
      Map regeocode = data['regeocode'];
      String? _address = regeocode['formatted_address'];
      _pickedAddress = _address;
      setState(() => {_inputController.text = _address ?? ''});
    } catch (e) {
      log('查询地理信息出错', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double lat = widget.latitude ?? 39.909187;
    double long = widget.longitude ?? 116.397451;
    // 创建地图
    final AMapWidget map = AMapWidget(
      // 设置地图center坐标
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, long),
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
                  child: Container(
                    child: Icon(
                      Icons.location_on,
                      size: 48,
                      color: Colors.red[400],
                    ),
                  ),
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
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _inputController,
                    maxLines: 2,
                    showCursor: false,
                    decoration: InputDecoration(hintText: '请在地图选择位置'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: MyButton.elevated(label: '确认保存', onPressed: () {}),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
