import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Screens/loggedin_screen.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';

import '../service_factory.dart';

class NoteEntryScreen extends StatelessWidget {
  static final id = 'noteEntryScreen';

  final goalService = ServiceFactory.getGoalService();

  final Record record;

  NoteEntryScreen({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController(
      text: record.notes,
    );

    RaisedButton saveNotes =
        buildSaveNotesButton(textEditingController, context);

    RaisedButton cancelButton = buildCancelButton(context);

    var scrollController = ScrollController();

    TextField noteTextField =
        buildNoteTextField(scrollController, textEditingController);
    return Scaffold(
      backgroundColor: appBarColor,
      body: Container(
        color: appBarColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 64, 8, 0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  getHeadline(record),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: offWhiteText),
                ),
                TokenText(
                  text: getPrompt(record),
                  textColor: offWhiteText,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        noteTextField,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [cancelButton, saveNotes],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  RaisedButton buildCancelButton(BuildContext context) {
    var cancelButton = RaisedButton(
      color: noGoal,
      onPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(LoggedInScreen.id));
      },
      child: Text('Cancel'),
    );
    return cancelButton;
  }

  RaisedButton buildSaveNotesButton(
      TextEditingController textEditingController, BuildContext context) {
    var saveNotes = RaisedButton(
      color: completedGoal,
      onPressed: () {
        var clone = record.copyWith(notes: textEditingController.text);
        goalService.update(clone).then((value) => Navigator.popUntil(
            context, ModalRoute.withName(LoggedInScreen.id)));
      },
      child: Text('Save'),
    );
    return saveNotes;
  }

  TextField buildNoteTextField(ScrollController scrollController,
      TextEditingController textEditingController) {
    var noteTextField = TextField(
      onChanged: (newText) {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      autofocus: true,
      controller: textEditingController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      ),
    );
    return noteTextField;
  }

  String getHeadline(Record record) {
    if (record.hasFailed()) {
      return "Let's see how we can make it better 🤔";
    } else {
      return "Congratulations rock star! 😎";
    }
  }

  String getPrompt(Record record) {
    if (record.hasFailed()) {
      return "Oops, looks like you failed to do what you planned to do. What went wrong? What are the lessons learnt? How do we aim better next time?";
    } else {
      return "Nice, looks like you crushed it!! How did it make you feel? What's next? How may we build on this?";
    }
  }
}
