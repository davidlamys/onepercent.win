import 'package:flutter/material.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/app_button.dart';
import 'package:flutter_win_2/Widgets/history_timeline_list.dart';
import 'package:flutter_win_2/blocs/index.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key key}) : super(key: key);
  final CalendarController _calendarController = CalendarController();

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
            final dates = snapshot.data.dates.toList();
            final recordsForRange = snapshot.data.recordsForVisibleRange;

            return Column(
              children: [
                TableCalendar(
                  calendarController: _calendarController,
                  onVisibleDaysChanged: (DateTime startDate, DateTime endDate,
                      CalendarFormat format) {
                    bloc.onVisibleDaysChanged(startDate, endDate);
                  },
                  calendarStyle: CalendarStyle(
                    selectedColor: Colors.deepOrange[400],
                    todayColor: Colors.deepOrange[200],
                    markersColor: Colors.brown[700],
                    outsideDaysVisible: false,
                  ),
                  endDay: DateTime.now(),
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
