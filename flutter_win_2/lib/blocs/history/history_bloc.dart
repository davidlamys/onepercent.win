import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:rxdart/rxdart.dart';

import '../../service_factory.dart';
import 'package:dart_date/dart_date.dart';

class HistoryScreenModel {
  final DateTime selectedDate;
  final DateTimeRange visibleRange;
  final List<Record> recordsForSelectedDate;
  final List<Record> recordsForVisibleRange;
  final List<DateTime> dates;

  HistoryScreenModel(this.selectedDate, this.visibleRange,
      this.recordsForSelectedDate, this.dates, this.recordsForVisibleRange);
}

class HistoryBloc {
  final _goalService = ServiceFactory.getGoalService();
  final _goals = BehaviorSubject<List<Record>>.seeded(<Record>[]);
  BehaviorSubject<DateTime> _selectedDate =
      BehaviorSubject.seeded(DateTime.now().startOfDay);
  BehaviorSubject<DateTimeRange> _visibleDates = BehaviorSubject.seeded(
      DateTimeRange(
          start: DateTime.now().startOfMonth, end: DateTime.now().endOfDay));
  Stream<List<Record>> _interimStream;
  Stream<List<Record>> get goals => _goals.stream;
  BehaviorSubject<HistoryScreenModel> _screenModel =
      BehaviorSubject.seeded(null);

  Stream<HistoryScreenModel> get screenModel => _screenModel.stream;

  HistoryBloc() {
    _goalService.goalStream().then((value) {
      _interimStream = value;
      _interimStream.pipe(_goals);
    });

    CombineLatestStream.combine2(_goals, _visibleDates,
        (List<Record> allGoals, DateTimeRange selectedTimeRange) {
      final goalsForMonth = _recordsForDates(selectedTimeRange, allGoals);

      return HistoryScreenModel(selectedTimeRange.start, selectedTimeRange,
          allGoals, _datesForRange(selectedTimeRange), goalsForMonth);
    }).distinct().pipe(_screenModel);
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate.sink.add(date);
  }

  void onVisibleDaysChanged(DateTime first, DateTime last) {
    final newRange = DateTimeRange(start: first, end: last);
    _visibleDates.sink.add(newRange);
  }

  List<DateTime> _datesForRange(DateTimeRange refDate) {
    final daysToGenerate = refDate.duration.inDays + 1;
    return List.generate(
        daysToGenerate,
        (i) => DateTime(
            refDate.start.year, refDate.start.month, refDate.start.day + (i)));
  }

  List<Record> _recordsForDates(DateTimeRange refDate, List<Record> records) {
    return records.where((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.isSameDay(refDate.start) ||
          elementTimestamp.isSameDay(refDate.end) ||
          (elementTimestamp.isBefore(refDate.end) &&
              elementTimestamp.isAfter(refDate.start));
    }).toList();
  }

  dispose() {
    _goals.close();
    _selectedDate.close();
    _visibleDates.close();
    _screenModel.close();
  }
}
