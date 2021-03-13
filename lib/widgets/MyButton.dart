import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final bool loading;
  final bool fullWidth;
  final bool isElevated;
  const MyButton.elevated({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.fullWidth = true,
    this.isElevated = true,
  }) : super(key: key);

  const MyButton.text({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.fullWidth = true,
    this.isElevated = false,
  }) : super(key: key);

  void _handlePressed() {
    if (loading) return;
    onPressed();
  }

  _renderChild() {
    if (loading) {
      return Container(
        width: 20,
        height: 20,
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.blue,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 2,
        ),
      );
    } else {
      return Text(label);
    }
  }

  double? get _width {
    return fullWidth ? double.infinity : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      child: isElevated
          ? ElevatedButton(
              onPressed: _handlePressed,
              child: _renderChild(),
            )
          : TextButton(
              onPressed: _handlePressed,
              child: _renderChild(),
            ),
    );
  }
}
