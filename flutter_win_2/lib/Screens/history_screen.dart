import 'package:flutter/material.dart';
import 'package:flutter_win_2/Widgets/history_timeline_list.dart';
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

            return HistoryTimelineList(
              dates: dates,
              recordsForRange: recordsForRange,
            );
          }),
    );
  }
}
