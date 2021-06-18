import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyTile extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String? subtitle;

  final String? leadingSvg;
  final Color leadingSvgColor;

  final Widget? trailingWidget;
  final String? trailingString;

  final void Function()? onTap;

  const MyTile({
    Key? key,
    required this.title,
    this.titleColor = Colors.black,
    this.subtitle,
    this.leadingSvg,
    this.leadingSvgColor = Colors.black,
    this.trailingWidget,
    this.trailingString,
    this.onTap,
  }) : super(key: key);

  List<Widget> _getTrailingChildren() {
    List<Widget> list = [];

    Widget? _widget = trailingWidget != null
        ? trailingWidget
        : trailingString != null
            ? Container(
                constraints: BoxConstraints(maxWidth: 120),
                alignment: Alignment.centerRight,
                child: Text(
                  trailingString!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            : null;

    if (_widget != null) list.add(_widget);
    if (onTap != null) list.add(Icon(Icons.chevron_right)); // 添加向右箭头

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leadingSvg != null
              ? Container(
                  child: SvgPicture.asset(
                    leadingSvg!,
                    semanticsLabel: 'svg',
                    color: leadingSvgColor,
                    width: 32,
                  ),
                )
              : null,

          title: Text(
            title,
            style: TextStyle(
              color: titleColor,
            ),
            // maxLines: 1,
          ),

          tileColor: Colors.white,
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(fontSize: 14),
                )
              : null,

          /// 尾部
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _getTrailingChildren(),
                ),
              ),
            ],
          ),

          onTap: onTap,
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}
