import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/bottom_sheet_icon.dart';
import 'package:flutter_win_2/Widgets/calendar.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:flutter_win_2/Widgets/no_goal_view.dart';
import 'package:flutter_win_2/service_factory.dart';
import 'package:intl/intl.dart';

import 'profile_screen.dart';

const numDays = 14;

class LoggedInScreen extends StatefulWidget {
  final scaffoldState = GlobalKey<ScaffoldState>();

  static const id = 'loggedInScreen';
  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  final goalService = ServiceFactory.getGoalService();
  DateTime selectedDate;
  List<Record> records;

  final _dates = List<int>.generate(numDays, (i) => i + 1)
      .map((i) => DateTime.now().subtract(Duration(days: i - 1)))
      .toList();

  @override
  void initState() {
    super.initState();
    goalService
        .goalStream()
        .then((goalStream) => {listenOnGoalStream(goalStream)});
    selectedDate = _dates.first;
  }

  void listenOnGoalStream(Stream<List<Record>> goalStream) {
    goalStream.listen((event) {
      print("New goals has arrived");
      setState(() {
        records = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '${dayFormat().format(selectedDate)}',
          ),
          leading: Container(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (builderContext) {
                        return loggedInBottomSheet();
                      });
                },
                child: Icon(Icons.more_horiz),
              ),
            ),
          ]),
      body: Container(
        color: appBarColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Container(
                color: appBarColor,
                child: HomePageCalendar(
                  records: records,
                  dates: _dates,
                  selectedDate: selectedDate,
                  onDateSelection: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 60,
              child: SingleChildScrollView(child: buildView(selectedDate)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildView(DateTime dateTime) {
    var record = recordForDate(dateTime);
    if (record == null) {
      return NoGoalView(
        date: dateTime,
      );
    } else {
      return GoalView(
        key: UniqueKey(),
        record: record,
      );
    }
  }

  DateFormat dayFormat() {
    return DateFormat('d MMMM yyyy');
  }

  Record recordForDate(DateTime refDate) {
    if (records == null) {
      return null;
    }
    return records.reversed.firstWhere((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.year == refDate.year &&
          elementTimestamp.month == refDate.month &&
          elementTimestamp.day == refDate.day;
    }, orElse: () => null);
  }

  Widget loggedInBottomSheet() {
    return Container(
      height: 80,
      color: appOrange,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            BottomSheetIcon(
              text: "Profile",
              iconData: Icons.account_circle_outlined,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
