import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';

class GoalView extends StatelessWidget {
  final Record record;

  const GoalView({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: buildChildrenWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildChildrenWidgets() {
    List<Widget> children = List<Widget>();
    children = [
      TokenText(
        text: 'Today I\'m going to',
      ),
      ValueText(
        text: record.name,
      ),
      TokenText(
        text: 'because it\'s going to help me to',
      ),
      ValueText(
        text: record.reason,
      )
    ];
    if (record.notes != null) {
      children.add(TokenText(text: "Notes:"));
      children.add(ValueText(text: record.notes));
    }

    var button = FlatButton(
      onPressed: () {
        print("hello world");
      },
      child: Text('Edit goal'),
    );

    children.add(button);
    return children;
  }
}

class TokenText extends StatelessWidget {
  final text;

  const TokenText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontStyle: FontStyle.italic,
              color: richBlack,
            ),
      ),
    );
  }
}

class ValueText extends StatelessWidget {
  final text;

  const ValueText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6.copyWith(color: richBlack),
      ),
    );
  }
}
