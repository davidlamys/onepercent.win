import 'package:flutter/material.dart';
import 'package:flutter_win_2/Screens/add_goal_screen.dart';

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
              Navigator.pushNamed(
                context,
                AddGoalScreen.id,
                arguments: {'date': date},
              );
            },
          ),
        ],
      ),
    );
  }
}
