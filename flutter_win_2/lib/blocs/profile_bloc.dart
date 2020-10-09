import 'package:flutter_win_2/Model/user.dart';
import 'package:flutter_win_2/service_factory.dart';
import 'package:rxdart/subjects.dart';

class ProfileBloc {
  final _userService = ServiceFactory.getUserService();

  Future<void> logoutUser() async {
    return _userService.signOutUser();
  }

  Stream<User> get loggedInUser =>
      _userService.loggedInUser.asBroadcastStream();

  dispose() {}
}
