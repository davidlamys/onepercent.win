import 'package:flutter/material.dart';
import 'goal_entry_bloc.dart';
export 'goal_entry_bloc.dart';

class GoalEntryProvider extends InheritedWidget {
  GoalEntryProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = GoalEntryBloc();
  final Widget child;

  static GoalEntryProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GoalEntryProvider>();
  }

  @override
  bool updateShouldNotify(GoalEntryProvider oldWidget) {
    return true;
  }
}
