import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Screens/loggedin_screen.dart';
import 'package:intl/intl.dart';

class HomePageCalendar extends StatelessWidget {
  final List<Record> records;
  final DateTime selectedDate;
  final List<DateTime> dates;

  final void Function(DateTime newDate) onDateSelection;

  const HomePageCalendar(
      {Key key,
      this.records,
      this.selectedDate,
      this.dates,
      this.onDateSelection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: _buildDateSelectionBox,
        reverse: true,
        itemCount: numDays);
  }

  Widget _buildDateSelectionBox(BuildContext context, int index) {
    var date = dates.elementAt(index);
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: GestureDetector(
        onTap: () {
          onDateSelection(date);
        },
        child: Card(
          child: Container(
            color: (date == selectedDate) ? Colors.grey : Colors.white,
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
        ),
      ),
    );
  }

  Color _colorForDate(DateTime refDate) {
    if (records == null || refDate == null) {
      return Colors.red;
    }
    var record = records.reversed.firstWhere((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.year == refDate.year &&
          elementTimestamp.month == refDate.month &&
          elementTimestamp.day == refDate.day;
    }, orElse: () => null);

    if (record == null) {
      return Colors.red;
    }

    if (record.notes == null) {
      return Colors.yellow;
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
