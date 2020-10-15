import 'package:flutter/material.dart';
import 'reminder_bloc.dart';
export 'reminder_bloc.dart';

class ReminderProvider extends InheritedWidget {
  ReminderProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = ReminderBloc();
  final Widget child;

  static ReminderProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ReminderProvider>();
  }

  @override
  bool updateShouldNotify(ReminderProvider oldWidget) {
    return true;
  }
}
