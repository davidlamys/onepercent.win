import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:intl/intl.dart';

class GoalListTile extends StatelessWidget {
  final GoalListTileAdapter adapter;
  const GoalListTile({Key key, this.adapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        title: Text(
          adapter.getTitleString(),
        ),
        subtitle: Text(
          adapter.getSubtitleString(),
        ),
        onTap: () {
          showFullRecord(context, adapter.record, "Reflection");
        });
  }

  void showFullRecord(BuildContext context, Record record, String titleString) {
    if (record.notes == null) {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("No reflection yet"),
          ));
      return;
    }
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(titleString),
          content: new Text(record.notes),
        ));
  }
}

abstract class GoalListTileAdapter {
  GoalListTileAdapter(this.record);
  String getTitleString();
  String getSubtitleString();
  final Record record;
  DateFormat get dayFormat => DateFormat('d MMM yy');
  String get timestampString => dayFormat.format(record.timestamp);
}

class AdminScreenListTileAdapter extends GoalListTileAdapter {
  AdminScreenListTileAdapter(this.record) : super(record);

  @override
  String getTitleString() {
    final token1 = "I want to ";
    final token2 = " because it is going to help me to ";
    final statusEmoji = getEmojiString(record);
    return record.createdBy +
        ": " +
        token1 +
        record.name +
        token2 +
        record.reason +
        statusEmoji;
  }

  @override
  String getSubtitleString() {
    return timestampString;
  }

  @override
  final Record record;
}
