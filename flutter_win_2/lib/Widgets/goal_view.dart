import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
class GoalView extends StatelessWidget {
  final Record record;

  const GoalView({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Today I\'m going to',
          ),
          Text(
            record.name,
          ),
          Text(
            'because it\'s going to help me to',
          ),
          Text(
            record.reason,
          ),
          Text(
            'notes: ${record.notes ?? 'no notes'}',
          ),
        ],
      ),
    );
  }
}
