import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/bottom_sheet_icon.dart';
import 'package:flutter_win_2/Widgets/calendar.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:flutter_win_2/Widgets/no_goal_view.dart';
import 'package:flutter_win_2/blocs/logged_in/logged_in_provider.dart';
import 'package:flutter_win_2/blocs/profile/profile_provider.dart';
import 'package:flutter_win_2/service_factory.dart';
import 'package:intl/intl.dart';

import 'profile_screen.dart';
import 'reminder_screen.dart';

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
      setState(() {
        records = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LoggedinProvider.of(context).bloc;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder<DateTime>(
              stream: bloc.selectedDate,
              builder: (context, snapshot) {
                if (snapshot.hasData == false || snapshot.data == null) {
                  return Container();
                }
                final navBarHeader = dayFormat().format(snapshot.data);
                return Text(
                  navBarHeader,
                );
              }),
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
          ],
        ),
        body: Container(
          color: appBarColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Container(
                  color: appBarColor,
                  child: StreamBuilder<HomePageCalendarModel>(
                      stream: bloc.calendarModel,
                      builder: (context, snapshot) {
                        if (snapshot.hasData == false) {
                          return Container();
                        }
                        final model = snapshot.data;
                        return HomePageCalendar(
                          records: model.records,
                          dates: model.dates,
                          selectedDate: model.selectedDate,
                          onDateSelection: bloc.updateSelectedDate,
                        );
                      }),
                ),
              ),
              Expanded(
                flex: 60,
                child: StreamBuilder<HomePageCalendarModel>(
                    stream: bloc.calendarModel,
                    builder: (context, snapshot) {
                      return SingleChildScrollView(
                          child: buildView(snapshot.data));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildView(HomePageCalendarModel calendarModel) {
    if (calendarModel == null) {
      return null;
    }

    if (calendarModel.recordsForSelectedDate == null ||
        calendarModel.recordsForSelectedDate.isEmpty) {
      return NoGoalView(
        date: calendarModel.selectedDate,
      );
    } else {
      return GoalView(
        key: UniqueKey(),
        record: calendarModel.recordsForSelectedDate.first,
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
      // height: 80,
      color: appOrange,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
        child: Row(
          children: buildSheetIcons(),
        ),
      ),
    );
  }

  List<Widget> buildSheetIcons() {
    var baseIcons = [
      BottomSheetIcon(
        text: "Profile",
        iconData: Icons.account_circle_outlined,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileProvider(child: ProfileScreen()),
            ),
          );
        },
      ),
      BottomSheetIcon(
        text: "Reminder",
        iconData: Icons.add_alarm_outlined,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReminderScreen(),
            ),
          );
        },
      ),
    ];
    return baseIcons;
  }
}
