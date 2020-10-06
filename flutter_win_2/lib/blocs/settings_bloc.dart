import 'package:flutter_win_2/Model/user.dart';
import 'package:flutter_win_2/service_factory.dart';
import 'package:rxdart/subjects.dart';

class SettingsBloc {
  final _userService = ServiceFactory.getUserService();

  Future<void> logoutUser() async {
    return _userService.signOutUser();
  }

  dispose() {}
}
