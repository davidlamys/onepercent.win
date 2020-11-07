import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Screens/loggedin_screen.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:intl/intl.dart';

class HomePageCalendarModel {
  final List<Record> records;
  final List<Record> recordsForSelectedDate;
  final DateTime selectedDate;
  final List<DateTime> dates;

  HomePageCalendarModel(
      this.records, this.recordsForSelectedDate, this.selectedDate, this.dates);
}

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
          child: buildContainer(date),
        ),
      ),
    );
  }

  Container buildContainer(DateTime date) {
    return Container(
      padding: EdgeInsets.all(10),
      child: (date == selectedDate)
          ? selectedDateContent(date)
          : unselectedDateContent(date),
    );
  }

  Column selectedDateContent(DateTime date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        selectedTextStyle(dayFormat().format(date)),
        selectedTextStyle(dateFormat().format(date)),
      ],
    );
  }

  Column unselectedDateContent(DateTime date) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(dayFormat().format(date)),
        Text(dateFormat().format(date)),
        Container(
          color: _colorForDate(date),
          height: 4.0,
        ),
      ],
    );
  }

  Text selectedTextStyle(string) => Text(
        string,
        style: TextStyle(fontWeight: FontWeight.w900),
      );

  Color _colorForDate(DateTime refDate) {
    if (records == null || refDate == null) {
      return appRed;
    }
    var record = records.reversed.firstWhere((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.year == refDate.year &&
          elementTimestamp.month == refDate.month &&
          elementTimestamp.day == refDate.day;
    }, orElse: () => null);

    if (record == null) {
      return appRed;
    }

    if (record.notes == null) {
      return appOrange;
    }

    return appGreen;
  }

  DateFormat dayFormat() {
    return DateFormat('E');
  }

  DateFormat dateFormat() {
    return DateFormat('dd');
  }

  DateFormat monthFormat() {
    return DateFormat('MMM');
  }
}
