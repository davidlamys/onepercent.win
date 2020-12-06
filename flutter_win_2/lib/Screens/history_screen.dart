import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Widgets/history_timeline_list.dart';
import 'package:flutter_win_2/blocs/index.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dart_date/dart_date.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final CalendarController _calendarController = CalendarController();
  AutoScrollController controller;
  @override
  void initState() {
    super.initState();

    controller = AutoScrollController(
        viewportBoundaryGetter: () {
          final rect =
              Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom);
          return rect;
        },
        axis: Axis.vertical);
  }

  Future _scrollToIndex(int index) async {
    if (index == null || index < 0) {
      return;
    }
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(index);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = HistoryProvider.of(context).bloc;
    bloc.selectedDate.withLatestFrom(bloc.screenModel,
        (selectedDate, HistoryScreenModel screenModel) {
      if (screenModel == null) {
        return -1;
      }
      final index = screenModel.dates
          .indexWhere((element) => element.isSameDay(selectedDate));
      return index;
    }).listen((index) {
      if (index >= 0) {
        print("scroll to index($index)");
        _scrollToIndex(index);
      }
    });
    return StreamBuilder<HistoryScreenModel>(
        stream: bloc.screenModel,
        builder: (context, snapshot) {
          if (snapshot.hasData == false || snapshot.data.dates == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Loading'),
              ),
            );
          }

          final screenModel = snapshot.data;
          final dates = screenModel.dates.toList();
          final recordsForRange = screenModel.recordsForVisibleRange;
          final historyTimelineList = HistoryTimelineList(
            dates: dates,
            recordsForRange: recordsForRange,
            controller: this.controller,
          );
          _scrollToIndex(0);

          return Scaffold(
            appBar: AppBar(
              title: Text(screenModel.getNavBarTitle()),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Column(
                children: [
                  buildTableCalendar(bloc, recordsForRange),
                  Expanded(
                    flex: 9,
                    child: historyTimelineList,
                  ),
                ],
              ),
            ),
          );
        });
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
        bloc.onVisibleDaysChanged(startDate, endDate);
      },
      onDaySelected: (DateTime day, List events, List holidays) {
        bloc.updateSelectedDate(day);
      },
      headerVisible: false,
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
            children.add(Container(
              height: 3.0,
              width: double.infinity,
              color: getColor(recordForDate),
            ));
            children.add(Text(getEmojiString(recordForDate)));
          } else {
            children.add(Container(
              height: 3.0,
              width: double.infinity,
              color: getColor(null),
            ));
          }

          return children;
        },
      ),
      endDay: DateTime.now(),
    );
  }
}
