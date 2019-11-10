import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageCalendar> {
  final _dates = List<int>.generate(10, (i) => i + 1)
      .map((i) => DateTime.now().subtract(Duration(days: i)));

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: _buildDateSelectionBox,
          itemCount: 10),
    );
  }

  Widget _buildDateSelectionBox(BuildContext context, int index) {
    var date = _dates.elementAt(index);
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Card(
        child: Text('{$date}'),
      ),
    );
  }
}
