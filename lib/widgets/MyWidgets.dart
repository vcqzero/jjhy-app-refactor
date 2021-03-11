import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation.dart';

class MyWidgets {
  /// 获取appBar
  static getAppBar({bool hidden = false, String title = '标题'}) {
    return AppBar(
      brightness: Brightness.dark,
      toolbarHeight: hidden == true ? 0 : null,
      title: Text(title),
      centerTitle: true,
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  final bool loading;
  const MyElevatedButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
        onPressed: onPressed,
        child: loading
            ? Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.blue,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
