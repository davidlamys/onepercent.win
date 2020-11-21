import 'package:flutter/material.dart';
import 'history_bloc.dart';
export 'history_bloc.dart';

class HistoryProvider extends InheritedWidget {
  HistoryProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = HistoryBloc();
  final Widget child;

  static HistoryProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HistoryProvider>();
  }

  @override
  bool updateShouldNotify(HistoryProvider oldWidget) {
    return true;
  }
}
