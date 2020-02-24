import 'package:flutter/material.dart';
import 'package:flutter_win_2/Services/goal_service.dart';
import 'package:flutter_win_2/Services/user_service.dart';
import 'package:uuid/uuid.dart';

class AddGoalScreen extends StatelessWidget {
  static final id = 'addGoalScreen';

  DateTime date;

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      print(arguments['date']);
      date = arguments['date'];
      print('david is hear!!!');
    }

    String _goal;
    String _reason;
    var _goalService = GoalService();
    var _userService = UserService();
    var uuid = Uuid();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Text('Today I\'m going to'),
          TextField(
            onChanged: (text) => _goal = text,
          ),
          Text('Because it\'s going to help me'),
          TextField(
            onChanged: (text) => _reason = text,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: Text('cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('save'),
                onPressed: () async {
                  var userId = await _userService.userId();
                  var userName = await _userService.userName();
                  var goal = Goal(
                      uuid.v4(), _goal, _reason, date, userName, userId, null);
                  _goalService.addGoal(goal).then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
