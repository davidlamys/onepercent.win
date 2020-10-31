import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final VoidCallback onPressed;
  const AppButton({Key key, this.child, @required this.onPressed, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: (color == null)
            ? BorderSide(color: Colors.grey.shade700)
            : BorderSide.none,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
