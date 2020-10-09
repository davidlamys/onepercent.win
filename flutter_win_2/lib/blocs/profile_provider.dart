import 'package:flutter/material.dart';
import 'profile_bloc.dart';
export 'profile_bloc.dart';

class ProfileProvider extends InheritedWidget {
  ProfileProvider({Key key, this.child}) : super(key: key, child: child);

  final bloc = ProfileBloc();
  final Widget child;

  static ProfileProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProfileProvider>();
  }

  @override
  bool updateShouldNotify(ProfileProvider oldWidget) {
    return true;
  }
}
