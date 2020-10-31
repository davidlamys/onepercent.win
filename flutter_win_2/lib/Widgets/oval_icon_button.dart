import 'package:flutter/material.dart';

class OvalIconButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData iconData;

  const OvalIconButton({
    Key key,
    this.backgroundColor,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor, // button color
        child: InkWell(
          splashColor: Colors.red, // inkwell color
          child: SizedBox(
            width: 28,
            height: 28,
            child: Container(
              decoration: new BoxDecoration(
                // color: Colors.blueAccent,
                border: new Border.all(
                  color: Colors.grey.shade700,
                  width: 2.0,
                ),
                borderRadius: new BorderRadius.circular(18.0),
              ),
              child: Icon(
                iconData,
                size: 18,
              ),
            ),
          ),
          onTap: () {
            print("hi world");
          },
        ),
      ),
    );
  }
}
