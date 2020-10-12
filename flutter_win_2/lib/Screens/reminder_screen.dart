import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_win_2/Widgets/reminder_section.dart';
import 'package:flutter_win_2/blocs/reminder_provider.dart';
import 'package:flutter_win_2/utils/notificationHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime eveningReminder;
  bool eveningReminderEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  Widget buildReminderSection(
      ReminderData data, ReminderBloc bloc, ReminderType reminderType) {
    final notificationId = id(reminderType);
    return ReminderSection(
      reminderModel: ReminderModel(
          title: getReminderTitle(reminderType),
          isEnabled: data.isEnabled,
          date: data.date,
          onConfirm: (newTime) {
            bloc.saveDate(newTime, reminderType);
            turnOffNotificationById(
                flutterLocalNotificationsPlugin, notificationId);
            scheduleDailyNotification(
                flutterLocalNotificationsPlugin,
                notificationId,
                "Good morning!!!",
                getReminderNotificationText(reminderType),
                newTime);
            setState(() {});
          },
          onPreferenceChanged: (isEnabled) {
            bloc.toggleReminder(isEnabled, reminderType);
            if (isEnabled == false) {
              turnOffNotificationById(
                  flutterLocalNotificationsPlugin, notificationId);
            } else {
              scheduleDailyNotification(
                  flutterLocalNotificationsPlugin,
                  notificationId,
                  "",
                  getReminderNotificationText(reminderType),
                  data.date);
            }
            setState(() {});
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ReminderProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder<ReminderData>(
                future: bloc.getMorningData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('something went wrong');
                  }
                  return buildReminderSection(
                      snapshot.data, bloc, ReminderType.morning);
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              FutureBuilder<ReminderData>(
                future: bloc.getEveningData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('something went wrong');
                  }
                  return buildReminderSection(
                      snapshot.data, bloc, ReminderType.evening);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
