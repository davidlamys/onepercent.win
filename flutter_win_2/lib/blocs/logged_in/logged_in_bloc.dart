import 'dart:async';

import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Model/user.dart';
import 'package:rxdart/rxdart.dart';
import '../../service_factory.dart';
import 'package:dart_date/dart_date.dart';

class HomePageModel {
  final List<Record> records;
  final List<Record> recordsForSelectedDate;
  final DateTime selectedDate;
  final List<DateTime> dates;
  final bool isAdmin;

  HomePageModel(this.records, this.recordsForSelectedDate, this.selectedDate,
      this.dates, this.isAdmin);
}

class LoggedInBloc {
  final _goalService = ServiceFactory.getGoalService();
  final _userService = ServiceFactory.getUserService();

  BehaviorSubject<List<Record>> _records = BehaviorSubject.seeded([]);
  BehaviorSubject<List<DateTime>> _dates = BehaviorSubject.seeded([]);
  BehaviorSubject<DateTime> _selectedDate =
      BehaviorSubject.seeded(DateTime.now().startOfDay);

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

    _records.distinct().map(datesForCalendar).pipe(_dates);

    CombineLatestStream.combine5(
        _records.distinct(),
        _recordsForSelectedDate.distinct(),
        _selectedDate,
        _dates.distinct(),
        _userService.loggedInUser.distinct(), (List<Record> a, List<Record> b,
            DateTime c, List<DateTime> d, User user) {
      if (a == null || b == null || c == null || d == null || user == null) {
        return null;
      }
      final isAdmin = user.isAdmin ?? false;
      return HomePageModel(a, b, c, d, isAdmin);
    }).distinct().pipe(_calendarModel);
  }

  List<DateTime> datesForCalendar(List<Record> records) {
    if (records == null || records.isEmpty) {
      return _getDefaultRange();
    }
    final firstRecord = records.first;
    if (firstRecord.timestamp == null) {
      return _getDefaultRange();
    }
    final tomorrow = DateTime.now().startOfDay.addDays(1);
    final today = DateTime.now().startOfDay;

    final latestRecord = records.last;
    final endDate = shouldShowTomorrow(latestRecord) ? tomorrow : today;

    return _getDates(firstRecord.timestamp.startOfDay, endDate);
  }

  bool shouldShowTomorrow(Record latestRecord) {
    if (latestRecord == null || latestRecord.timestamp == null) {
      return false;
    }
    if (latestRecord.timestamp.isTomorrow) {
      return true;
    }
    if (latestRecord.timestamp.isToday == false) {
      return false;
    }
    return latestRecord.isInProgress() == false;
  }

  List<DateTime> _getDates(DateTime startDate, DateTime endDate) {
    final daysBetween =
        endDate.startOfDay.differenceInDays(startDate.startOfDay) + 1;
    return List<int>.generate(daysBetween, (i) => i + 1)
        .reversed
        .map((e) => startDate.addDays(e - 1))
        .toList();
  }

  List<DateTime> _getDefaultRange() => _getDateRange(7);

  List<DateTime> _getDateRange(int daysAgo) {
    return List<int>.generate(daysAgo, (i) => i + 1)
        .map((i) => DateTime.now().startOfDay.subtract(Duration(days: i - 1)))
        .toList();
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
