import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/calendar.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:flutter_win_2/Widgets/no_goal_view.dart';
import 'package:flutter_win_2/service_factory.dart';
import 'package:intl/intl.dart';

const numDays = 14;

class LoggedInScreen extends StatefulWidget {
  static final id = 'loggedInScreen';
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print("hello world");
                },
                child: Icon(Icons.settings),
              ),
            ),
          ]),
      body: Container(
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
            Container(
              color: appBarColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${dayFormat().format(selectedDate)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: offWhiteText),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                getStatusPrompt(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              flex: 60,
              child: buildView(selectedDate),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusPrompt() {
    Record selectedRecord = recordForDate(selectedDate);
    if (selectedRecord == null) {
      return "👀 No Goals?? 👀";
    } else if (selectedRecord.status == "inProgress") {
      return "💪 You've got this!! 💪";
    } else if (selectedRecord.notes == null) {
      return "🤔 Reflection needed!! 🤔";
    } else if (selectedRecord.status == "completedWithNotes") {
      return "🌈 Well done! Now aim again!! 🌈";
    } else {
      return "🌱 Lesson Learnt 🌱";
    }
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
    return DateFormat('EEEE dd MMMM y');
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
