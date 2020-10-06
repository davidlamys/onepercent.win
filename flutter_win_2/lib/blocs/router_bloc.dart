import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter_win_2/Model/user.dart';
import 'package:rxdart/rxdart.dart';

import '../service_factory.dart';

class RouterBloc {
  final _userService = ServiceFactory.getUserService();
  final user = PublishSubject<FirebaseUser>();

  RouterBloc() {
    _userService.user.pipe(user);
  }

  dispose() {
    print('router bloc dispose called');
    user.close();
  }
}
