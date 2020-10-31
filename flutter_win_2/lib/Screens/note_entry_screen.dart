import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/app_button.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:flutter_win_2/blocs/index.dart';

class NoteEntryScreen extends StatelessWidget {
  static const id = 'noteEntryScreen';

  final Record record;

  NoteEntryScreen({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController(
      text: record.notes,
    );

    NoteEntryBloc bloc = NoteEntryProvider.of(context).bloc;
    bloc.setRecord(record);

    Widget saveNotes = StreamBuilder(
      stream: bloc.isSaveEnabled,
      builder: (streamContext, snapshot) {
        final shouldAllowSave = (snapshot.hasData == true && snapshot.data);
        return buildSaveNotesButton(
            textEditingController, context, shouldAllowSave, bloc);
      },
    );

    Widget cancelButton = buildCancelButton(context);

    var scrollController = ScrollController();

    TextField noteTextField =
        buildNoteTextField(scrollController, textEditingController, bloc);
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

  Widget buildCancelButton(BuildContext context) {
    return AppButton(
      color: appRed,
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Cancel'),
    );
  }

  Widget buildSaveNotesButton(TextEditingController textEditingController,
      BuildContext context, bool isEnabled, NoteEntryBloc bloc) {
    return AppButton(
      color: appGreen,
      onPressed: isEnabled
          ? () {
              bloc.save().then((value) => Navigator.pop(context));
            }
          : null,
      child: Text('Save'),
    );
  }

  TextField buildNoteTextField(ScrollController scrollController,
      TextEditingController textEditingController, NoteEntryBloc bloc) {
    return TextField(
      onChanged: (newText) {
        bloc.setNote(newText);
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
