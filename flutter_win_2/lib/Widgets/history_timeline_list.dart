import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'goal_list_tile.dart';

class HistoryTimelineList extends StatelessWidget {
  HistoryTimelineList({
    Key key,
    @required this.dates,
    @required this.recordsForRange,
    this.controller,
  }) : super(key: key);

  final List<DateTime> dates;
  final List<Record> recordsForRange;
  final AutoScrollController controller;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final date = dates[index];
          final goalsForDate = _recordsForDate(date, recordsForRange);
          if (goalsForDate == null || goalsForDate.isEmpty) {
            final tile = GoalListTile(
              adapter: NoGoalListTileAdapter(date),
            );
            return _wrapScrollTag(index: index, child: tile);
          } else {
            final tile = GoalListTile(
              adapter: HistoryListTileAdapter(goalsForDate.first),
            );
            return _wrapScrollTag(index: index, child: tile);
          }
        },
        reverse: false,
        itemCount: dates.length);
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );

  List<Record> _recordsForDate(DateTime refDate, List<Record> records) {
    return records.where((element) {
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
