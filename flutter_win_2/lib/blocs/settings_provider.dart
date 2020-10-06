import 'package:flutter/material.dart';
import 'settings_bloc.dart';
export 'settings_bloc.dart';

class SettingsProvider extends InheritedWidget {
  SettingsProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = SettingsBloc();
  final Widget child;

  static SettingsProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsProvider>();
  }

  @override
  bool updateShouldNotify(SettingsProvider oldWidget) {
    return true;
  }
}
