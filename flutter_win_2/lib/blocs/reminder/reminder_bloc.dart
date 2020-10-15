import 'dart:async';

import 'package:flutter_win_2/Widgets/reminder_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderBloc {
  toggleReminder(bool isEnabled, ReminderType reminderType) async {
    final prefs = await SharedPreferences.getInstance();
    if (reminderType == ReminderType.morning) {
      prefs.setBool("morningReminderEnabled", isEnabled);
    } else {
      prefs.setBool("eveningReminderEnabled", isEnabled);
    }
  }

  saveDate(DateTime date, ReminderType reminderType) async {
    final prefs = await SharedPreferences.getInstance();
    if (reminderType == ReminderType.morning) {
      prefs.setInt("morningReminderHour", date.hour);
      prefs.setInt("morningReminderMin", date.minute);
    } else {
      prefs.setInt("eveningReminderHour", date.hour);
      prefs.setInt("eveningReminderMin", date.minute);
    }
  }

  Future<ReminderData> getMorningData() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt("morningReminderHour");
    final min = prefs.getInt("morningReminderMin");
    final isEnabled = prefs.getBool("morningReminderEnabled") ?? false;

    return ReminderData(ReminderType.morning, hour, min, isEnabled);
  }

  Future<ReminderData> getEveningData() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt("eveningReminderHour");
    final min = prefs.getInt("eveningReminderMin");
    final isEnabled = prefs.getBool("eveningReminderEnabled") ?? false;

    return ReminderData(ReminderType.morning, hour, min, isEnabled);
  }

  dispose() {}
}
