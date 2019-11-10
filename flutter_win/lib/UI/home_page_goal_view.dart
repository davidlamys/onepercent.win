import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageGoalView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageGoalState();
  }
}

class _HomePageGoalState extends State<HomePageGoalView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 9,
        child: Container(
          color: Colors.blue,
        ));
  }
}
