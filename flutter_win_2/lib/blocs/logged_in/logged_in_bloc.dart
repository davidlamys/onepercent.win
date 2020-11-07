import 'dart:async';

import 'package:flutter_win_2/Model/record.dart';
import 'package:rxdart/rxdart.dart';

import '../../service_factory.dart';

class LoggedInBloc {
  // final _goalService = ServiceFactory.getGoalService();
  final _userService = ServiceFactory.getUserService();

  // BehaviorSubject<bool> _isAdmin = BehaviorSubject.seeded(false);
  BehaviorSubject<List<Record>> _records = BehaviorSubject.seeded([]);
  BehaviorSubject<List<DateTime>> _dates = BehaviorSubject.seeded([]);
  BehaviorSubject<DateTime> _selectedDate =
      BehaviorSubject.seeded(DateTime.now());

  BehaviorSubject<List<Record>> _recordsForSelectedDate =
      BehaviorSubject.seeded([]);

  // Stream<bool> get isAdmin => _isAdmin;
  Stream<List<Record>> get recordsStream => _records.stream;
  Stream<List<DateTime>> get dates => _dates.stream;
  Stream<List<Record>> get recordsForSelectedDate =>
      _recordsForSelectedDate.stream;

  LoggedInBloc() {}

  void updateSelectedDate(DateTime date) {}

  dispose() {
    _records.close();
    _dates.close();
    _selectedDate.close();
    _recordsForSelectedDate.close();
  }
}
