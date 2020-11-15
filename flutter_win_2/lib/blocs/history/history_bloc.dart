import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:rxdart/rxdart.dart';

import '../../service_factory.dart';
import 'package:dart_date/dart_date.dart';

class HistoryScreenModel {
  final DateTime selectedDate;
  final DateTimeRange selectedMonth;
  final List<Record> recordsForSelectedDate;
  final List<Record> recordsForSelectedMonth;
  final List<DateTime> dates;
  final bool allowPrev;
  final bool allowNext;

  HistoryScreenModel(
      this.selectedDate,
      this.selectedMonth,
      this.recordsForSelectedDate,
      this.dates,
      this.allowPrev,
      this.allowNext,
      this.recordsForSelectedMonth);
}

class HistoryBloc {
  final _goalService = ServiceFactory.getGoalService();
  final _goals = BehaviorSubject<List<Record>>.seeded(<Record>[]);
  BehaviorSubject<DateTime> _selectedDate =
      BehaviorSubject.seeded(DateTime.now().startOfDay);
  BehaviorSubject<DateTimeRange> _selectedMonth = BehaviorSubject.seeded(
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

    CombineLatestStream.combine2(_goals, _selectedMonth,
        (List<Record> allGoals, DateTimeRange selectedTimeRange) {
      final goalsForMonth = _recordsForDates(selectedTimeRange, allGoals);
      return HistoryScreenModel(
          selectedTimeRange.start,
          selectedTimeRange,
          allGoals,
          datesForRange(selectedTimeRange),
          true,
          true,
          goalsForMonth);
    }).distinct().pipe(_screenModel);
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate.sink.add(date);
  }

  void viewPreviousMonth() {}

  void viewNextMonth() {}

  List<DateTime> datesForRange(DateTimeRange refDate) {
    final daysToGenerate = refDate.duration.inDays + 1;
    return List.generate(
        daysToGenerate,
        (i) => DateTime(
            refDate.start.year, refDate.end.month, refDate.start.day + (i)));
  }

  List<Record> recordsForDate(DateTime refDate, List<Record> records) {
    return records.reversed.where((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.year == refDate.year &&
          elementTimestamp.month == refDate.month &&
          elementTimestamp.day == refDate.day;
    }).toList();
  }

  List<Record> _recordsForDates(DateTimeRange refDate, List<Record> records) {
    return records.reversed.where((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.year == refDate.start.year &&
          elementTimestamp.month == refDate.start.month;
    }).toList();
  }

  dispose() {
    _goals.close();
    _selectedDate.close();
    _selectedMonth.close();
    _screenModel.close();
  }
}
