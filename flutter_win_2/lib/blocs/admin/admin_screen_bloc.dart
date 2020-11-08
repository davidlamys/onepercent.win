import 'package:flutter_win_2/Model/record.dart';
import 'package:rxdart/rxdart.dart';

import '../../service_factory.dart';
import 'dart:async';

class AdminScreenBloc {
  final _goalService = ServiceFactory.getGoalService();

  Stream<List<Record>> get goalsStream => _goalService.globalGoalsStream();

  dispose() {}
}
