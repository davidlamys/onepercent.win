import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Widgets/goal_list_tile.dart';
import 'package:flutter_win_2/blocs/index.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = HistoryProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('November 2020'),
      ),
      body: StreamBuilder<HistoryScreenModel>(
          stream: bloc.screenModel,
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Container();
            }
            final dates = snapshot.data.dates.reversed.toList();
            final recordsForRange = snapshot.data.recordsForSelectedMonth;

            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final date = dates[index];
                  final goalsForDate =
                      bloc.recordsForDate(date, recordsForRange);
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
          }),
    );
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
