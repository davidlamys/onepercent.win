import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Screens/goal_entry_screen.dart';
import 'package:flutter_win_2/Screens/note_entry_screen.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalEntryScreen(
              record: record,
              date: record.timestamp,
            ),
          ),
        );
      },
      child: Text('Edit goal'),
    );

    var editNotesButton = FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteEntryScreen(
              record: record,
            ),
          ),
        );
      },
      child: Text('Edit notes'),
    );

    var checkInButton = buildReflectButton();

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
                  key: Key("AssetDialog"),
                  image: Image.asset(
                    'assets/zen-bunny.webp',
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
                  buttonOkColor: appGreen,
                  buttonCancelText: Text("Need Tweaks 🤔"),
                  buttonCancelColor: appRed,
                  onOkButtonPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEntryScreen(
                          record: record.copyWith(status: "completedWithNotes"),
                        ),
                      ),
                    );
                  },
                  onCancelButtonPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEntryScreen(
                          record: record.copyWith(status: "failed"),
                        ),
                      ),
                    );
                  },
                ));
      },
      child: Text('Reflect'),
    );
  }
}

class TokenText extends StatelessWidget {
  final text;
  final textColor;

  const TokenText({Key key, this.text, this.textColor = richBlack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontStyle: FontStyle.italic,
              color: textColor,
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
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6.copyWith(color: richBlack),
      ),
    );
  }
}
