import 'package:app/config/Config.dart';
import 'package:app/utils/MyString.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TheAvatarSection extends StatelessWidget {
  final String? username;
  final String? phone;
  final String? avatar;
  const TheAvatarSection({
    Key? key,
    this.username,
    this.phone,
    this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(avatar ?? Config.defaultAvatar),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 29),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username ?? '请先登录',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    child: Text(
                      phone != null ? MyString.encryptPhone(phone!) : '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
