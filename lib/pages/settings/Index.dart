import 'dart:developer';
import 'package:app/api/UserApi.dart';
import 'package:app/app/Config.dart';
import 'package:app/pages/about/Index.dart';
import 'package:app/store/User.dart';
import 'package:app/utils/MyDio.dart';
import 'package:app/utils/MyLoading.dart';
import 'package:app/utils/MyToast.dart';
import 'package:app/widgets/MyAppBar.dart';
import 'package:app/widgets/MyTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = "SettingsPage";
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late User _user;
  final _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _user = User.cache();
  }

  bool _handleValidImg(MultipartFile file) {
    int len = file.length;
    double maxLen = 1.8 * 1024 * 1024;
    return len < maxLen;
  }

  _handlePickImage(ImageSource source) async {
    Navigator.of(context).pop(); // sheet相当于新页面，可通过navigator关闭
    PickedFile? file = await _picker.getImage(source: source, imageQuality: 30);
    if (file != null) _handleUploadAvatar(file.path);
  }

  _handleClickEditAvatar() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext content) {
        return Container(
          height: 180,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("选择方式"),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.blue,
                ),
                title: Text("拍照"),
                onTap: () => _handlePickImage(ImageSource.camera),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.perm_media_outlined, color: Colors.green),
                title: Text("从相册选择"),
                onTap: () => _handlePickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  _handleUploadAvatar(String path) async {
    try {
      MultipartFile file =
          await MultipartFile.fromFile(path, filename: 'avatar');
      if (_handleValidImg(file) == false) {
        return MyToast.show('所选图片多大');
      }
      // start loading
      MyLoading.showLoading('上传中');
      FormData formData = FormData.fromMap({'avatar': file});
      MyResponse res = UserApi.updateAvatar(formData);
      await res.future.then((value) => null);
      MyToast.show('上传成功');
      // reload user
      await User.reload();
      setState(() {
        _user = User.build();
      });
    } on DioError catch (e) {
      log('上传头像错误', error: e);
    } finally {
      MyLoading.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.build(
        title: '设置',
        actions: [
          IconButton(
            icon: Text('关于'),
            tooltip: "关于",
            onPressed: () {
              Navigator.of(context).pushNamed(AboutPage.routeName);
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20),
        children: [
          Divider(height: 1),
          MyTile(
            title: '头像',
            trailingWidget: CircleAvatar(
              radius: 20,
              backgroundImage:
                  NetworkImage(_user.avatar ?? Config.defaultAvatar),
            ),
            onTap: _handleClickEditAvatar,
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
    );
  }
}
