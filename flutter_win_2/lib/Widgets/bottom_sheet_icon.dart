import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomSheetIcon extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Function onPressed;

  const BottomSheetIcon({Key key, this.text, this.iconData, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: IconButton(
            icon: Icon(
              iconData,
              size: 32.0,
            ),
            onPressed: onPressed,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
