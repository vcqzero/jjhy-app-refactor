import 'package:flutter/material.dart';

class TheIconItem extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String lable;
  final Function()? onTap;
  const TheIconItem({
    Key? key,
    this.color,
    required this.icon,
    required this.lable,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                color: color,
                height: 64,
                width: 64,
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Text(
                lable,
              ),
            )
          ],
        ),
      ),
    );
  }
}
