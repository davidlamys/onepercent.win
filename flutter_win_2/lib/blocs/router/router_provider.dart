import 'package:flutter/material.dart';
import 'router_bloc.dart';
export 'router_bloc.dart';

class RouterProvider extends InheritedWidget {
  RouterProvider({Key key, this.child}) : super(key: key, child: child);

  final Widget child;
  final bloc = RouterBloc();

  static RouterProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RouterProvider>();
  }

  @override
  bool updateShouldNotify(RouterProvider oldWidget) {
    return true;
  }
}
