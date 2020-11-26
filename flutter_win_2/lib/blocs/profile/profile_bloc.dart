import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Model/user.dart';
import 'package:flutter_win_2/service_factory.dart';
import 'package:rxdart/subjects.dart';
import 'package:dart_date/dart_date.dart';

class ProfileBloc {
  final _userService = ServiceFactory.getUserService();
  final _goalService = ServiceFactory.getGoalService();
  final _goals = BehaviorSubject<List<Record>>.seeded(<Record>[]);

  Stream<List<Record>> _interimStream;
  _now() => DateTime.now().startOfDay;

  ProfileBloc() {
    _goalService.goalStream().then((value) {
      _interimStream = value;
      _interimStream.pipe(_goals);
    });
  }

  Future<bool> linkUser() async {
    return _userService.linkUser();
  }

  Future<void> logoutUser() async {
    return _userService.signOutUser();
  }

  Stream<User> get loggedInUser =>
      _userService.loggedInUser.asBroadcastStream();

  Stream<List<Record>> get goals => _goals.stream;

  int findDaysSinceFirstGoal(List<Record> records) {
    if (records.isEmpty) {
      return 0;
    }
    final firstDayTime = records.first.timestamp.startOfDay;
    return _now().difference(firstDayTime).inDays;
  }

  int findDaysSinceLatestGoal(List<Record> records) {
    if (records.isEmpty) {
      return 0;
    }
    final lastDayTime = records.last.timestamp.startOfDay;
    return _now().difference(lastDayTime).inDays;
  }

  int countGoals(List<Record> records) {
    return records.length;
  }

  int countNotes(List<Record> records) {
    return records
        .where((element) => element.notes != null && element.notes != "")
        .length;
  }

  int findLongestStreak(List<Record> records) {
    int currentStreak = 0;
    int longestStreak = 0;
    DateTime lastTimeStamp = _now();
    for (var record in records.reversed) {
      final timeStamp = record.timestamp.startOfDay;
      final daysSince = lastTimeStamp.difference(timeStamp).inDays;
      if (daysSince < 2) {
        if (daysSince == 1) {
          currentStreak += 1;
        }
        if (currentStreak >= longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
      lastTimeStamp = timeStamp;
    }
    return longestStreak;
  }

  int findCurrentStreak(List<Record> records) {
    int currentStreak = 0;
    DateTime lastTimeStamp = _now();
    for (var record in records.reversed) {
      final timeStamp = record.timestamp.startOfDay;
      final daysSince = lastTimeStamp.difference(timeStamp).inDays;
      if (daysSince < 2) {
        if (daysSince == 1) {
          currentStreak += 1;
        }
      } else {
        return currentStreak;
      }
      lastTimeStamp = timeStamp;
    }
    return currentStreak;
  }

  double findUsageRate(List<Record> records) {
    DateTime lastTimeStamp = DateTime.fromMicrosecondsSinceEpoch(0).startOfDay;
    var daysWithGoals = 0;
    for (var record in records) {
      final timeStamp = record.timestamp.startOfDay;
      final daysSince = timeStamp.difference(lastTimeStamp).inDays;
      if (daysSince > 0) {
        daysWithGoals += 1;
      }
      lastTimeStamp = timeStamp;
    }
    var daysSinceFirstGoal = findDaysSinceFirstGoal(records);
    if (daysSinceFirstGoal == 0) {
      return 0;
    }
    print("daysWithGoals $daysWithGoals");
    return daysWithGoals.toDouble() / daysSinceFirstGoal.toDouble();
  }

  dispose() {
    _goals.close();
  }
}
