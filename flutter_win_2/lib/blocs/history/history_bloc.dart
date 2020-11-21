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
          _datesForRange(selectedTimeRange),
          (_getPrevRange(selectedTimeRange, allGoals) != null),
          (_getNextRange(selectedTimeRange, allGoals) != null),
          goalsForMonth);
    }).distinct().pipe(_screenModel);
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate.sink.add(date);
  }

  DateTimeRange _getPrevRange(
      DateTimeRange currentRange, List<Record> allGoals) {
    if (allGoals == null || allGoals.isEmpty) {
      return null;
    }
    DateTime newStartDate = currentRange.start.subMonths(1);
    final firstGoalTimestamp = allGoals.first.timestamp;
    if (newStartDate.endOfMonth.isBefore(firstGoalTimestamp)) {
      return null;
    }

    if (newStartDate.isBefore(firstGoalTimestamp)) {
      newStartDate = firstGoalTimestamp;
    }
    return DateTimeRange(start: newStartDate, end: newStartDate.endOfMonth);
  }

  DateTimeRange _getNextRange(
      DateTimeRange currentRange, List<Record> allGoals) {
    if (allGoals == null || allGoals.isEmpty) {
      return null;
    }
    final newStartDate = currentRange.start.addMonths(1);
    DateTime endDate = newStartDate.endOfMonth;
    final now = DateTime.now();
    if (newStartDate.isAfter(now)) {
      return null;
    }
    if (endDate.isAfter(now)) {
      endDate = DateTime.now().endOfDay;
    }
    if (allGoals.last.timestamp.isAfter(now)) {
      endDate = allGoals.last.timestamp;
    }
    return DateTimeRange(start: newStartDate, end: endDate);
  }

  void viewPreviousMonth() {
    final currentRange = _selectedMonth.value;
    final newRange = _getPrevRange(currentRange, _goals.value);
    if (newRange == null) {
      return;
    }
    _selectedMonth.sink.add(newRange);
  }

  void viewNextMonth() {
    final currentRange = _selectedMonth.value;
    final newRange = _getNextRange(currentRange, _goals.value);
    if (newRange == null) {
      return;
    }
    _selectedMonth.sink.add(newRange);
  }

  List<DateTime> _datesForRange(DateTimeRange refDate) {
    final daysToGenerate = refDate.duration.inDays + 1;
    return List.generate(
        daysToGenerate,
        (i) => DateTime(
            refDate.start.year, refDate.end.month, refDate.start.day + (i)));
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
