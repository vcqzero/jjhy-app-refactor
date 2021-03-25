import 'package:flutter/material.dart';

class MyTile extends StatefulWidget {
  final String title;
  final Widget? trailingWidget;
  final void Function()? onTap;
  final Color titleColor;
  MyTile({
    Key? key,
    required this.title,
    this.trailingWidget,
    this.onTap,
    this.titleColor = Colors.black,
  }) : super(key: key);

  @override
  _MyTileState createState() => _MyTileState();
}

class _MyTileState extends State<MyTile> {
  List<Widget> _handleBuildTrailing() {
    List<Widget> list = [
      Icon(Icons.chevron_right),
    ];
    if (widget.trailingWidget != null) {
      list.insert(0, widget.trailingWidget!);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      title: Text(
        widget.title,
        style: TextStyle(
          color: widget.titleColor,
        ),
      ),
      trailing: Container(
        width: 200,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _handleBuildTrailing(),
        ),
      ),
      onTap: () {
        if (widget.onTap != null) widget.onTap!();
      },
    );
  }
}
