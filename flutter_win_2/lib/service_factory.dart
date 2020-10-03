import 'package:flutter_win_2/Services/user_service.dart';

import 'Services/goal_service.dart';

final useFake = false;

class ServiceFactory {
  static FakeGoalService fakeGoalService = FakeGoalService();
  static FakeUserService fakeUserService = FakeUserService();

  static UserService getUserService() {
    if (useFake) {
      return fakeUserService;
    } else {
      return UserService();
    }
  }

  static GoalService getGoalService() {
    if (useFake) {
      return fakeGoalService;
    } else {
      return GoalService();
    }
  }
}
