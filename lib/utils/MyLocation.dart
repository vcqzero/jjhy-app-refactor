import 'dart:developer';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:app/config/Config.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationResult {
  bool success = false;

  /// 维度
  double? latitude;

  /// 经度
  double? longitude;

  /// 地址
  String? address;

  // ///国家
  // String? country;

  // /// 省
  // String? province;

  // /// 市
  // String? city;

  // /// 区
  // String? district;

  // /// 街道
  // String? street;
}

class MyLocation {
  AMapFlutterLocation _location = new AMapFlutterLocation();
  Function(LocationResult result) onLocated;

  MyLocation({required this.onLocated}) {
    // _location.setLocationOption(AMapLocationOption(
    //   onceLocation: true,
    // ));
    _location.onLocationChanged().listen((Map<String, Object> result) {
      print('MyLocation 获取定位结果');
      print(result);

      LocationResult _result = LocationResult();
      try {
        _result.success = result['errorCode'] == null;
        _result.address = result['address'] as String?;
        _result.latitude = result['latitude'] as double?;
        _result.longitude = result['longitude'] as double?;
      } catch (e) {
        log('解析定位数据错误', error: e);
      }
      onLocated(_result);
      // stop
      _location.stopLocation();
    });
  }

  /// 开始定位
  /// 如果未获取定位权限，返回false
  Future<bool> startLocation() async {
    bool hasPermission = await requestLocationPermission();
    if (hasPermission == false) return false;
    _location.startLocation();
    return true;
  }

  stopLocation() {
    _location.stopLocation();
  }

  destoryLocation() {
    _location.destroy();
  }

  /// 申请定位权限
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
