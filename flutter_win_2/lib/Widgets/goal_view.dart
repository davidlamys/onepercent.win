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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: buildChildrenWidgets(context),
          ),
        ),
      ),
    );
  }

  List<Widget> buildChildrenWidgets(BuildContext context) {
    List<Widget> children = List<Widget>();
    children = [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          getStatusPrompt(record),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
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

    children.add(buildCallToAction());
    return children;
  }

  Widget buildCallToAction() {
    var editButton = FlatButton(
      onPressed: () {
        print("hello world");
      },
      child: Text('Edit goal'),
    );

    var checkIn = FlatButton(
      onPressed: () {
        print("hello world");
      },
      child: Text('Reflect'),
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [editButton, checkIn],
      ),
    );
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
