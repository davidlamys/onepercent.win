import 'package:flutter/material.dart';
import 'package:flutter_win_2/Screens/history_screen.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/bottom_sheet_icon.dart';
import 'package:flutter_win_2/Widgets/calendar.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:flutter_win_2/Widgets/no_goal_view.dart';
import 'package:flutter_win_2/blocs/index.dart';
import 'package:intl/intl.dart';

import 'admin_screen.dart';
import 'profile_screen.dart';
import 'reminder_screen.dart';

class LoggedInScreen extends StatelessWidget {
  final scaffoldState = GlobalKey<ScaffoldState>();

  static const id = 'loggedInScreen';

  @override
  Widget build(BuildContext context) {
    final bloc = LoggedinProvider.of(context).bloc;
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder<HomePageModel>(
          stream: bloc.homePageModel,
          builder: (context, snapshot) {
            if (snapshot.hasData == false || snapshot.data == null) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Loading...'),
                  leading: Container(),
                ),
              );
            }
            final model = snapshot.data;
            final navBarHeader = dayFormat().format(model.selectedDate);
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  navBarHeader,
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
                              return loggedInBottomSheet(
                                  context, model.isAdmin);
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
                        child: HomePageCalendar(
                          records: model.records,
                          dates: model.dates,
                          selectedDate: model.selectedDate,
                          onDateSelection: bloc.updateSelectedDate,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 60,
                        child: SingleChildScrollView(
                          child: buildView(snapshot.data),
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildView(HomePageModel model) {
    if (model == null) {
      return null;
    }

    if (model.recordsForSelectedDate == null ||
        model.recordsForSelectedDate.isEmpty) {
      return NoGoalView(
        date: model.selectedDate,
      );
    } else {
      return GoalView(
        key: UniqueKey(),
        record: model.recordsForSelectedDate.first,
      );
    }
  }

  DateFormat dayFormat() {
    return DateFormat('d MMMM yyyy');
  }

  Widget loggedInBottomSheet(BuildContext context, bool isAdmin) {
    return Container(
      // height: 80,
      color: appOrange,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
        child: Row(
          children: buildSheetIcons(context, isAdmin),
        ),
      ),
    );
  }

  List<Widget> buildSheetIcons(BuildContext context, bool isAdmin) {
    var baseIcons = [
      buildProfileIcon(context),
      buildReminderIcon(context),
      buildHistoryIcon(context),
    ];
    if (isAdmin) {
      final getNosy = buildGetNosyIcon(context);
      baseIcons.add(getNosy);
    }
    return baseIcons;
  }

  BottomSheetIcon buildProfileIcon(BuildContext context) {
    return BottomSheetIcon(
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
    );
  }

  BottomSheetIcon buildReminderIcon(BuildContext context) {
    return BottomSheetIcon(
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
    );
  }

  BottomSheetIcon buildHistoryIcon(BuildContext context) {
    return BottomSheetIcon(
      text: "View All",
      iconData: Icons.calendar_today_outlined,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryProvider(
              child: HistoryScreen(),
            ),
          ),
        );
      },
    );
  }

  BottomSheetIcon buildGetNosyIcon(BuildContext context) {
    return BottomSheetIcon(
      text: "Get nosy",
      iconData: Icons.remove_red_eye_outlined,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminScreenProvider(
              child: AdminScreen(),
            ),
          ),
        );
      },
    );
  }
}
