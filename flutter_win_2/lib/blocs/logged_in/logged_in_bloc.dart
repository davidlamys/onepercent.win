import 'dart:async';

import 'package:flutter_win_2/Model/record.dart';
import 'package:rxdart/rxdart.dart';
import '../../service_factory.dart';

class HomePageModel {
  final List<Record> records;
  final List<Record> recordsForSelectedDate;
  final DateTime selectedDate;
  final List<DateTime> dates;

  HomePageModel(
      this.records, this.recordsForSelectedDate, this.selectedDate, this.dates);
}

class LoggedInBloc {
  final _goalService = ServiceFactory.getGoalService();
  final _userService = ServiceFactory.getUserService();

  BehaviorSubject<bool> _isAdmin = BehaviorSubject.seeded(false);
  BehaviorSubject<List<Record>> _records = BehaviorSubject.seeded([]);
  BehaviorSubject<List<DateTime>> _dates = BehaviorSubject.seeded([]);
  BehaviorSubject<DateTime> _selectedDate =
      BehaviorSubject.seeded(DateTime.now());

  BehaviorSubject<List<Record>> _recordsForSelectedDate =
      BehaviorSubject.seeded([]);

  BehaviorSubject<HomePageModel> _calendarModel = BehaviorSubject.seeded(null);

  Stream<List<Record>> _interimStream;

  Stream<HomePageModel> get homePageModel => _calendarModel.stream;

  LoggedInBloc() {
    _goalService.goalStream().then((value) {
      _interimStream = value;
      _interimStream.pipe(_records);
    });

    CombineLatestStream.combine2(_records, _selectedDate,
        (List<Record> records, DateTime selectedDate) {
      if (records == null || selectedDate == null) {
        return List<Record>();
      }
      return _recordsForDate(selectedDate, records);
    }).pipe(_recordsForSelectedDate);

    final _startingDates = List<int>.generate(14, (i) => i + 1)
        .map((i) => DateTime.now().subtract(Duration(days: i - 1)))
        .toList();

    _dates.sink.add(_startingDates);
    _selectedDate.sink.add(_startingDates.first);

    CombineLatestStream.combine4(
        _records, _recordsForSelectedDate, _selectedDate, _dates,
        (List<Record> a, List<Record> b, DateTime c, List<DateTime> d) {
      if (a == null || b == null || c == null || d == null) {
        return null;
      }

      return HomePageModel(a, b, c, d);
    }).pipe(_calendarModel);
  }

  List<Record> _recordsForDate(DateTime refDate, List<Record> records) {
    return records.reversed.where((element) {
      final elementTimestamp = element.timestamp;
      return elementTimestamp.year == refDate.year &&
          elementTimestamp.month == refDate.month &&
          elementTimestamp.day == refDate.day;
    }).toList();
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate.sink.add(date);
  }

  dispose() {
    _records.close();
    _dates.close();
    _selectedDate.close();
    _recordsForSelectedDate.close();
    _calendarModel.close();
  }
}
