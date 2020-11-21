import 'package:flutter/material.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/app_button.dart';
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
            final model = snapshot.data;
            final dates = snapshot.data.dates.reversed.toList();
            final recordsForRange = snapshot.data.recordsForSelectedMonth;

            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: HistoryController(
                    nextPressed: model.allowNext ? bloc.viewNextMonth : null,
                    prevPressed:
                        model.allowPrev ? bloc.viewPreviousMonth : null,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: HistoryTimelineList(
                    dates: dates,
                    recordsForRange: recordsForRange,
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class HistoryController extends StatelessWidget {
  final Function prevPressed;
  final Function nextPressed;
  final String title;
  const HistoryController(
      {Key key, this.prevPressed, this.nextPressed, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AppButton(
          onPressed: prevPressed,
          color: appGreen,
          child: AppButtonText(
            "Prev",
          ),
        ),
        Text('1 Nov'),
        AppButton(
          onPressed: nextPressed,
          color: appGreen,
          child: AppButtonText(
            "Next",
          ),
        ),
      ],
    );
  }
}
