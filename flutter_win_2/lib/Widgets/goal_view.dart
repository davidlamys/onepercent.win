import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

const List<Key> keys = [
  Key("Network"),
  Key("NetworkDialog"),
  Key("Flare"),
  Key("FlareDialog"),
  Key("Asset"),
  Key("AssetDialog")
];

class GoalView extends StatefulWidget {
  final Record record;

  const GoalView({Key key, this.record}) : super(key: key);

  @override
  _GoalViewState createState() {
    return _GoalViewState(record);
  }
}

class _GoalViewState extends State<GoalView> {
  final Record record;

  _GoalViewState(this.record);

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
    var editGoalButton = FlatButton(
      onPressed: () {
        print("hello world");
      },
      child: Text('Edit goal'),
    );

    var editNotesButton = FlatButton(
      onPressed: () {
        print("hello world");
      },
      child: Text('Edit notes'),
    );

    var checkInButton = buildReflectButton();

    print(record.notes);
    var buttons = (record.notes == null)
        ? [editGoalButton, checkInButton]
        : [editGoalButton, editNotesButton];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons,
      ),
    );
  }

  FlatButton buildReflectButton() {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => NetworkGiffyDialog(
                  key: keys[1],
                  image: Image.network(
                    // attribution: https://giphy.com/stickers/molangofficialpage-kawaii-molang-piupiu-29LdYf2N5uR1oCWSOI
                    "https://media.giphy.com/media/29LdYf2N5uR1oCWSOI/giphy.gif",
                    fit: BoxFit.scaleDown,
                  ),
                  entryAnimation: EntryAnimation.BOTTOM,
                  title: Text(
                    'How did it go?',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                  ),
                  description: Text(
                    'In many ways, this reflection will be as important as what happened.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  buttonOkText: Text("Crushed it 😎"),
                  buttonOkColor: completedGoal,
                  buttonCancelText: Text("Need Tweaks 🤔"),
                  buttonCancelColor: noGoal,
                  onOkButtonPressed: () {},
                ));
      },
      child: Text('Reflect'),
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
