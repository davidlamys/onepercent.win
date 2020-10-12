import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_win_2/Widgets/reminder_section.dart';
import 'package:flutter_win_2/utils/notificationHelper.dart';

import '../main.dart';

class ReminderScreen extends StatefulWidget {
  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime morningReminder;
  bool morningReminderEnabled = false;

  DateTime eveningReminder;
  bool eveningReminderEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              ReminderSection(
                reminderModel: ReminderModel(
                    title: "Morning Reminder",
                    isEnabled: morningReminderEnabled,
                    date: morningReminder,
                    onConfirm: (newTime) {
                      setState(() {
                        morningReminder = newTime;
                        turnOffNotificationById(
                            flutterLocalNotificationsPlugin, 0);
                        scheduleDailyNotification(
                            flutterLocalNotificationsPlugin,
                            0,
                            "Reminder",
                            "Text to be entered",
                            newTime);
                      });
                    },
                    onPreferenceChanged: (isEnabled) {
                      setState(() {
                        morningReminderEnabled = isEnabled;
                        if (isEnabled == false) {
                          morningReminder = null;
                          turnOffNotificationById(
                              flutterLocalNotificationsPlugin, 0);
                        }
                      });
                    }),
              ),
              SizedBox(
                height: 8.0,
              ),
              ReminderSection(
                reminderModel: ReminderModel(
                    title: "Evening Reminder",
                    isEnabled: eveningReminderEnabled,
                    date: eveningReminder,
                    onConfirm: (newTime) {
                      setState(() {
                        eveningReminder = newTime;
                      });
                    },
                    onPreferenceChanged: (isEnabled) {
                      setState(() {
                        eveningReminderEnabled = isEnabled;
                        if (isEnabled == false) {
                          eveningReminder = null;
                        }
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
