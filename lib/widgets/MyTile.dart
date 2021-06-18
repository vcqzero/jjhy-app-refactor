import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyTile extends StatefulWidget {
  final String title;
  final Color titleColor;
  final String? subtitle;

  final String? leadingSvg;
  final Color leadingSvgColor;

  final Widget? trailingWidget;
  final String? trailingString;

  final void Function()? onTap;

  /// 如果[trailingWidget] 不为null，优先渲染trailingWidget，
  /// 否则渲染[trailingString]
  MyTile({
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

  @override
  _MyTileState createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  List<Widget> _handleBuildTrailing() {
    List<Widget> list = [];
    // 优选渲染trailingWidget
    if (widget.trailingWidget != null) {
      list.add(widget.trailingWidget!);
    } else if (widget.trailingString != null) {
      list.add(
        Container(
          width: 180,
          alignment: Alignment.centerRight,
          child: Text(
            widget.trailingString!,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    // 添加向右箭头
    if (widget.onTap != null) {
      list.add(Icon(Icons.chevron_right));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: widget.leadingSvg != null
              ? Container(
                  child: SvgPicture.asset(
                    widget.leadingSvg!,
                    semanticsLabel: 'svg',
                    color: widget.leadingSvgColor,
                    width: 32,
                  ),
                )
              : null,
          tileColor: Colors.white,
          subtitle: widget.subtitle != null
              ? Text(
                  widget.subtitle!,
                  style: TextStyle(fontSize: 14),
                )
              : null,
          title: Text(
            widget.title,
            style: TextStyle(
              color: widget.titleColor,
            ),
            // maxLines: 1,
            overflow: TextOverflow.visible,
          ),

          /// 尾部
          trailing: Container(
            width: 220,
            // color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _handleBuildTrailing(),
            ),
          ),

          onTap: widget.onTap,
        ),
        Divider(height: 1),
      ],
    );
  }
}
