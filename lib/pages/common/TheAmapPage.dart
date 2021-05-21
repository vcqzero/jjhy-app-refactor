import 'dart:developer';

import 'package:app/api/AmapApi.dart';
import 'package:app/pages/common/TheSingleInputPage.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyButton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:permission_handler/permission_handler.dart';

class TheAmapPagePopData {
  final double latitude;
  final double longitude;
  final String address;
  TheAmapPagePopData({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class TheAmapPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final String? address;
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

  double? _pickedLatitude; // 选择的维度
  double? _pickedLongitude; // 选择的经度
  String? _pickedAddress; // 选择的位置

  TextEditingController _searchController = TextEditingController();

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
    _pickedLatitude = widget.latitude;
    _pickedLongitude = widget.longitude;
    _pickedAddress = widget.address;
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
    _regeoLocation(_pickedLatitude!, _pickedLongitude!);
  }

  /// 逆地理解析，用于获取地址信息
  void _regeoLocation(latitude, longitude) async {
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
      setState(() => {_pickedAddress = _address ?? ''});
    } catch (e) {
      log('查询地理信息出错', error: e);
    }
  }

  void _onSelectSearchPoi({
    String? location,
    String? address,
  }) {
    _poisResultTile?.clear();
    if (address != null) {
      _searchController.text = address;
      _pickedAddress = address;
    }

    log('选择的经纬度， $location');
    List<String?>? list = location?.split(',');
    if (list != null && list[0] != null && list[1] != null) {
      double lng = double.parse(list[0]!);
      double lat = double.parse(list[1]!);
      _pickedLatitude = lat;
      _pickedLongitude = lng;
      _moveMap(lat, lng);
    }
  }

  List<Widget>? _poisResultTile;
  void _searchAddressByKeywork(String keyword) async {
    setState(() {
      _poisResultTile?.clear();
    });
    try {
      _cancelToken?.cancel();
      MyResponse _res = AmapApi.search(keywords: keyword);
      _cancelToken = _res.cancelToken;
      Map data = await _res.future.then((value) => value.data);

      // 根据status，判断是否请求成功
      // https://lbs.amap.com/api/webservice/guide/api/search
      String status = '${data['status']}';
      if (status != '1') {
        throw data['info'] ?? '返回状态 != 1';
      }

      List _pois = data['pois'];
      List<Widget> _tiles = [];
      _pois.forEach((_poi) {
        if (_tiles.length >= 10) return;
        String? _address = _poi['address'];
        String? _location = _poi['location'];
        if (_address != null) {
          _tiles.add(Column(
            children: [
              ListTile(
                title: Text(_poi['address']),
                onTap: () =>
                    _onSelectSearchPoi(location: _location, address: _address),
              ),
              Divider(height: 1),
            ],
          ));
        }
      });
      setState(() {
        _poisResultTile = _tiles;
      });
    } catch (e) {
      log('查询地理信息出错', error: e);
    }
  }

  bool _showSearchInput = false;

  void _moveMap(double lat, double lng) {
    _mapController?.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  void _onEditAddress(String address) async {
    String? _editedAddress = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => TheSingleInputPage(
          val: address,
          maxLines: 2,
        ),
      ),
    );
    if (_editedAddress != null) {
      setState(() {
        _pickedAddress = _editedAddress;
      });
    }
    log('返回了，获取返回结果 $_editedAddress');
  }

  @override
  Widget build(BuildContext context) {
    // 创建地图
    final AMapWidget map = AMapWidget(
      // 设置地图center坐标
      initialCameraPosition: CameraPosition(
        target: LatLng(
            widget.latitude ?? 39.909187, widget.longitude ?? 116.397451),
        zoom: 15.0,
      ),
      onMapCreated: _onMapCreated,
      onCameraMoveEnd: _onCameraMoveEnd,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false, // 防止键盘弹出时，重建布局
      appBar: MyAppBar.build(
        title: 'Amap 地图',
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Open shopping cart',
            onPressed: () {
              // handle the press
              setState(() {
                _showSearchInput = !_showSearchInput;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: map,
                ),

                // 定位图标
                Positioned(
                  child: Container(
                    child: Icon(
                      Icons.location_on,
                      size: 48,
                      color: Colors.red[400],
                    ),
                  ),
                ),

                // 搜索框
                Positioned(
                  left: 0,
                  top: 0,
                  child: Offstage(
                    offstage: !_showSearchInput,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: TextField(
                            onChanged: _searchAddressByKeywork,
                            controller: _searchController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              hintText: '搜索地址',
                              prefixIcon: Icon(Icons.search),
                              suffix: Container(
                                // padding: EdgeInsets.all(5),
                                // color: Colors.red,
                                child: MyButton.text(
                                  fullWidth: false,
                                  label: '清除',
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _poisResultTile?.clear();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.width - 100,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [...?_poisResultTile],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 审图号
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
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  ListTile(
                    trailing: _pickedAddress != null
                        ? IconButton(
                            onPressed: () => _onEditAddress(_pickedAddress!),
                            icon: Text(
                              "修改",
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        : null,
                    title: Text(_pickedAddress ?? '请选择地址'),
                  ),
                  Divider(),
                  // SizedBox(height: 10),
                  MyButton.elevated(
                    label: '确认',
                    disabled: (_pickedLatitude == null ||
                            _pickedLongitude == null ||
                            _pickedAddress == null) ||
                        (widget.latitude == _pickedLatitude &&
                            widget.longitude == _pickedLongitude &&
                            widget.address == _pickedAddress),
                    onPressed: () {
                      if (_pickedLatitude != null &&
                          _pickedLongitude != null &&
                          _pickedAddress != null) {
                        Navigator.of(context).pop(TheAmapPagePopData(
                          address: _pickedAddress!,
                          latitude: _pickedLatitude!,
                          longitude: _pickedLongitude!,
                        ));
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
