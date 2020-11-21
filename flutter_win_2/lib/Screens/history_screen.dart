import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
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
                buildTableCalendar(bloc, recordsForRange),
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

  TableCalendar buildTableCalendar(
      HistoryBloc bloc, List<Record> recordsForRange) {
    Map<DateTime, List<Record>> _events = Map<DateTime, List<Record>>();
    for (var record in recordsForRange) {
      _events[record.timestamp] = List<Record>.of([record]);
    }

    return TableCalendar(
      calendarController: _calendarController,
      onVisibleDaysChanged:
          (DateTime startDate, DateTime endDate, CalendarFormat format) {
        print(format);
        bloc.onVisibleDaysChanged(startDate, endDate);
      },
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: true,
        formatButtonShowsNext: true,
      ),
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      events: _events,
      builders: CalendarBuilders(
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            Record recordForDate = events.first;
            if (recordForDate != null) {
              children.add(Container(
                height: 3.0,
                width: double.infinity,
                color: getColor(recordForDate),
              ));
              children.add(Text(getEmojiString(recordForDate)));
            }
          } else {
            children.add(Container(
              height: 3.0,
              width: double.infinity,
              color: getColor(null),
            ));
          }

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          return children;
        },
      ),
      endDay: DateTime.now(),
    );
  }

  _buildEventsMarker(DateTime date, List events) {
    return Container();
  }
}
