import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final bool loading;
  final bool fullWidth;
  final bool isElevated;
  final bool disabled;
  const MyButton.elevated({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.fullWidth = true,
    this.isElevated = true,
    this.disabled = false,
  }) : super(key: key);

  const MyButton.text({
    Key? key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.fullWidth = true,
    this.isElevated = false,
    this.disabled = false,
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
      return Text(
        label,
        style: TextStyle(
          color: isElevated ? Colors.white : Colors.blue,
        ),
      );
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
              style: ButtonStyle(
                backgroundColor: disabled
                    ? MaterialStateProperty.all(Colors.blue.shade200)
                    : MaterialStateProperty.all(Colors.blue),
              ),
              onPressed: (loading || disabled) ? null : _handlePressed,
              child: _renderChild(),
            )
          : TextButton(
              onPressed: (loading || disabled) ? null : _handlePressed,
              child: _renderChild(),
            ),
    );
  }
}
