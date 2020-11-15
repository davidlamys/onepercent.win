import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';

import 'goal_list_tile.dart';

class HistoryTimelineList extends StatelessWidget {
  const HistoryTimelineList({
    Key key,
    @required this.dates,
    @required this.recordsForRange,
  }) : super(key: key);

  final List<DateTime> dates;
  final List<Record> recordsForRange;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final date = dates[index];
          final goalsForDate = _recordsForDate(date, recordsForRange);
          if (goalsForDate == null || goalsForDate.isEmpty) {
            return GoalListTile(
              adapter: NoGoalListTileAdapter(date),
            );
          }
          return GoalListTile(
            adapter: HistoryListTileAdapter(goalsForDate.first),
          );
        },
        reverse: false,
        itemCount: dates.length);
  }

  List<Record> _recordsForDate(DateTime refDate, List<Record> records) {
    return records.reversed.where((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.year == refDate.year &&
          elementTimestamp.month == refDate.month &&
          elementTimestamp.day == refDate.day;
    }).toList();
  }
}

class NoGoalListTileAdapter extends GoalListTileAdapter {
  final DateTime date;

  NoGoalListTileAdapter(this.date) : super(null);

  @override
  String getTitleString() {
    return dayFormat.format(date);
  }

  String getSubtitleString() {
    return "No goal for date";
  }
}

class HistoryListTileAdapter extends GoalListTileAdapter {
  HistoryListTileAdapter(this.record) : super(record);

  @override
  String getTitleString() {
    return timestampString + getEmojiString(record);
  }

  @override
  String getSubtitleString() {
    final token1 = "I want to ";
    final token2 = " because it is going to help me to ";
    return token1 + record.name + token2 + record.reason;
  }

  @override
  final Record record;
}
