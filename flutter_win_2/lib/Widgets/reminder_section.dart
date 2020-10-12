import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_win_2/Widgets/time_picker_button.dart';

class ReminderSection extends StatelessWidget {
  final ReminderModel reminderModel;
  const ReminderSection({Key key, this.reminderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  reminderModel.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Switch(
                value: reminderModel.isEnabled,
                onChanged: reminderModel.onPreferenceChanged,
                activeTrackColor: Colors.tealAccent,
                activeColor: Colors.teal,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TimePickerButton(
            time: reminderModel.dateString(),
            date: reminderModel.date,
            onConfirm: reminderModel.onConfirm,
            isEnabled: reminderModel.isEnabled,
          ),
        ),
      ],
    );
  }
}

class ReminderModel {
  final String title;
  final bool isEnabled;
  final ValueChanged<bool> onPreferenceChanged;
  final DateChangedCallback onConfirm;
  final DateTime date;

  ReminderModel(
      {this.title,
      this.isEnabled,
      this.onConfirm,
      this.date,
      this.onPreferenceChanged});

  String dateString() {
    if (date == null) {
      return "Not Set";
    }
    final hour = date.hour.toString().padLeft(2, "0");
    final min = date.minute.toString().padLeft(2, "0");

    return '$hour : $min';
  }
}

class ReminderData {
  final ReminderType type;
  final int hour;
  final int minute;
  final bool isEnabled;

  ReminderData(this.type, this.hour, this.minute, this.isEnabled);

  DateTime get date {
    if (hour == null || minute == null) {
      return null;
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute, 0);
  }
}

enum ReminderType { morning, evening }

String getReminderNotificationTitle(ReminderType reminderType) {
  if (reminderType == ReminderType.morning) {
    return "Gooood Morning!!";
  } else {
    return "Hey there!";
  }
}

String getReminderNotificationText(ReminderType reminderType) {
  if (reminderType == ReminderType.morning) {
    return "Time to aim at something for the day!";
  } else {
    return "Time to reflect on the day!";
  }
}

String getReminderTitle(ReminderType reminderType) {
  if (reminderType == ReminderType.morning) {
    return "Morning Reminder";
  } else {
    return "Evening Reminder";
  }
}

int id(ReminderType reminderType) {
  return ReminderType.values.indexOf(reminderType);
}
