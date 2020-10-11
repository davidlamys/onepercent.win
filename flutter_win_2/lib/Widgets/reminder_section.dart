import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_win_2/Widgets/time_picker_button.dart';

class ReminderSection extends StatelessWidget {
  final ReminderModel reminderModel;
  const ReminderSection({Key key, this.reminderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  reminderModel.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
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
          TimePickerButton(
            time: reminderModel.dateString(),
            date: reminderModel.date,
            onConfirm: reminderModel.onConfirm,
            isEnabled: reminderModel.isEnabled,
          ),
        ],
      ),
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
