import 'package:flutter/material.dart';
import 'package:flutter_win_2/Screens/goal_entry_screen.dart';
import 'package:flutter_win_2/Styling/colors.dart';

class NoGoalView extends StatelessWidget {
  final DateTime date;
  const NoGoalView({
    Key key,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Let's set a goal",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                FlatButton(
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: appOrange,
                        size: 100.0,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalEntryScreen(
                          record: null,
                          date: date,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  "Remember, taking it easy can be a goal too.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
