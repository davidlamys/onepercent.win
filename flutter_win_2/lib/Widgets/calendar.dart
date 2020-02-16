import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Services/goal_service.dart';
import 'package:intl/intl.dart';

class HomePageCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageCalendar> {
  final _dates = List<int>.generate(10, (i) => i + 1)
      .reversed
      .map((i) => DateTime.now().subtract(Duration(days: i - 1)));

  final goalService = GoalService();

  List<Record> records;

  @override
  void initState() {
    super.initState();
    goalService
        .goalStream()
        .then((goalStream) => {listenOnGoalStream(goalStream)});
  }

  void listenOnGoalStream(Stream<List<Record>> goalStream) {
    goalStream.listen((event) {
      setState(() {
        records = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: _buildDateSelectionBox,
        itemCount: 10);
  }

  Widget _buildDateSelectionBox(BuildContext context, int index) {
    var date = _dates.elementAt(index);
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(dayFormat().format(date)),
            Text(dateFormat().format(date)),
            Text(monthFormat().format(date)),
            Container(
              color: _colorForDate(date),
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForDate(DateTime refDate) {
    if (records == null || refDate == null) {
      return Colors.red;
    }
    var record = records.reversed.firstWhere((element) {
      final element_timestamp = element.timestamp;
      return element_timestamp.year == refDate.year &&
          element_timestamp.month == refDate.month &&
          element_timestamp.day == refDate.day;
    }, orElse: () => null);

    if (record == null) {
      return Colors.red;
    }

    if (record.notes == null) {
      return Colors.orange;
    }

    return Colors.green;
  }

  DateFormat dayFormat() {
    return DateFormat('EEE');
  }

  DateFormat dateFormat() {
    return DateFormat('dd');
  }

  DateFormat monthFormat() {
    return DateFormat('MMM');
  }
}
