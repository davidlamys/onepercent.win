import 'package:flutter/material.dart';
import 'admin_screen_bloc.dart';
export 'admin_screen_bloc.dart';

class AdminScreenProvider extends InheritedWidget {
  AdminScreenProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = AdminScreenBloc();
  final Widget child;

  static AdminScreenProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdminScreenProvider>();
  }

  @override
  bool updateShouldNotify(AdminScreenProvider oldWidget) {
    return true;
  }
}
