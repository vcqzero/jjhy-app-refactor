import 'package:app/pages/login/Index.dart';
import 'package:flutter/material.dart';

class MyLoginButton extends StatelessWidget {
  const MyLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      radius: 200,
      onTap: () {
        Navigator.pushNamed(context, LoginPage.routeName);
      },
      child: Container(
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 48,
              color: Colors.grey.shade600,
            ),
            Text('请先登录', style: TextStyle(color: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }
}
