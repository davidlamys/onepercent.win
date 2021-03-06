import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Services/goal_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../service_factory.dart';

class GoalEntryBloc {
  final _goalService = ServiceFactory.getGoalService();
  final _userService = ServiceFactory.getUserService();

  Record record;
  BehaviorSubject<bool> _isSaveEnabled = BehaviorSubject.seeded(false);

  Stream<bool> get isSaveEnabled => _isSaveEnabled.stream;

  BehaviorSubject<String> _goal = BehaviorSubject.seeded(null);
  BehaviorSubject<String> _reason = BehaviorSubject.seeded(null);

  Function onSaveCompletion;

  GoalEntryBloc() {
    CombineLatestStream.combine2<String, String, bool>(_goal, _reason,
        (goal, reason) {
      if (goal == null || reason == null) {
        return false;
      }
      if (goal == "" || reason == "") {
        return false;
      }
      return true;
    }).pipe(_isSaveEnabled);
  }

  save({String goal, String reason, DateTime goalDate}) async {
    var userId = await _userService.userId();
    var userName = await _userService.userName();
    var uuid = Uuid();

    if (record == null) {
      var newGoal = Goal(uuid.v4(), goal, reason, goalDate, userName, userId,
          null, "inProgress");
      _goalService.addGoal(newGoal).then((value) => _saveCompleted());
    } else {
      var clone = record.copyWith(goal: goal, reason: reason);
      _goalService.update(clone).then((value) => _saveCompleted());
    }
  }

  _saveCompleted() {
    if (onSaveCompletion != null) {
      onSaveCompletion();
    }
  }

  setRecord(Record record) {
    this.record = record;
    if (record == null) {
      setGoal(null);
      setReason(null);
    } else {
      setGoal(record.name);
      setReason(record.reason);
    }
  }

  setGoal(String goal) {
    _goal.sink.add(goal);
  }

  setReason(String reason) {
    _reason.sink.add(reason);
  }

  dispose() {
    _isSaveEnabled.close();
    _goal.close();
    _reason.close();
  }
}
