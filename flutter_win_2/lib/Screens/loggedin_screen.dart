import 'package:flutter/material.dart';
import 'package:flutter_win_2/Services/user_service.dart';
import 'package:flutter_win_2/Widgets/calendar.dart';

import 'add_goal_screen.dart';

class LoggedInScreen extends StatelessWidget {
  static final id = 'loggedInScreen';

  @override
  Widget build(BuildContext context) {
    final UserService _userService = UserService();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                child: HomePageCalendar(),
              ),
            ),
            StreamBuilder(
                initialData: _userService.user,
                builder: (context, user) {
                  if (user == null) {
                    return Container();
                  } else {
                    print(user);
                    return Container();
//                return Text(user.data['id']);
                  }
                }),
            Text('Feburary 21 selected'),
            Expanded(
              flex: 9,
              child: NoGoalView(),
            ),
          ],
        ),
      ),
    );
  }

  void addTempGoal() {}
}

class NoGoalView extends StatelessWidget {
  final DateTime date;
  const NoGoalView({
    Key key,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("No goal set yet."),
          FlatButton(
            child: Text('Add goal'),
            onPressed: () {
              Navigator.pushNamed(context, AddGoalScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
