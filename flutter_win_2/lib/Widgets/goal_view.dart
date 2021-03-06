import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Screens/goal_entry_screen.dart';
import 'package:flutter_win_2/Screens/note_entry_screen.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/app_button.dart';
import 'package:flutter_win_2/blocs/goal_entry/goal_entry_provider.dart';
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
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: buildChildrenWidgets(context),
        ),
      ),
    );
  }

  List<Widget> buildChildrenWidgets(BuildContext context) {
    List<Widget> children = List<Widget>();
    children = [
      Container(
        margin: EdgeInsets.only(
          bottom: 8,
        ),
        width: double.infinity,
        color: getColor(record),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                getStatusPrompt(record),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
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
    var editGoalButton = AppButton(
      color: appGreen,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalEntryProvider(
              child: GoalEntryScreen(
                record: record,
                date: record.timestamp,
              ),
            ),
          ),
        );
      },
      child: AppButtonText(
        'Edit goal',
        textColor: Colors.white,
      ),
    );

    var editNotesButton = AppButton(
      color: appGreen,
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
      child: AppButtonText(
        'Edit notes',
        textColor: Colors.white,
      ),
    );

    var checkInButton = AppButton(
      color: appGreen,
      onPressed: () {
        showReflectionDialog();
      },
      child: AppButtonText(
        'Reflect',
        textColor: Colors.white,
      ),
    );

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

  void showReflectionDialog() {
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
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
                textScaleFactor: 1.0,
              ),
              description: Text(
                'In many ways, this reflection will be as important as what happened.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
                textScaleFactor: 1.0,
              ),
              buttonOkText: Text(
                "Crushed it 😎",
                textScaleFactor: 1.0,
              ),
              buttonOkColor: appGreen,
              buttonCancelText: Text(
                "Need Tweaks 🤔",
                textScaleFactor: 1.0,
              ),
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
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 20,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6.copyWith(color: richBlack),
      ),
    );
  }
}
