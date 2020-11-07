import 'package:flutter/material.dart';
import 'logged_in_bloc.dart';
export 'logged_in_bloc.dart';

class LoggedinProvider extends InheritedWidget {
  LoggedinProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = LoggedInBloc();
  final Widget child;

  static LoggedinProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoggedinProvider>();
  }

  @override
  bool updateShouldNotify(LoggedinProvider oldWidget) {
    return true;
  }
}
