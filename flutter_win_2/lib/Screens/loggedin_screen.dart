import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Services/goal_service.dart';
import 'package:flutter_win_2/Services/user_service.dart';
import 'package:flutter_win_2/Widgets/calendar.dart';
import 'package:flutter_win_2/Widgets/no_goal_view.dart';
import 'package:intl/intl.dart';

const numDays = 14;

class LoggedInScreen extends StatefulWidget {
  static final id = 'loggedInScreen';
  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  final goalService = GoalService();
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
      setState(() {
        records = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserService _userService = UserService();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
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
            Text('${dayFormat().format(selectedDate)} selected'),
            Expanded(
              flex: 9,
              child: buildView(selectedDate),
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
        record: record,
      );
    }
  }

  DateFormat dayFormat() {
    return DateFormat('EEE, dd, MMM');
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
}

class GoalView extends StatelessWidget {
  final Record record;

  const GoalView({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Today I\'m going to',
          ),
          Text(
            record.name,
          ),
          Text(
            'because it\'s going to help me to',
          ),
          Text(
            record.reason,
          ),
          Text(
            'notes: ${record.notes ?? 'no notes'}',
          ),
        ],
      ),
    );
  }
}
