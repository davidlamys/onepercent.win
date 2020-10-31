import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:flutter_win_2/Widgets/app_button.dart';
import 'package:flutter_win_2/blocs/goal_entry/goal_entry_provider.dart';
import 'package:flutter_win_2/utils/debouncer.dart';

class GoalEntryScreen extends StatelessWidget {
  static const id = 'goalEntryScreen';

  final Record record;
  final DateTime date;

  GoalEntryScreen({Key key, this.record, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = GoalEntryProvider.of(context).bloc;
    bloc.setRecord(record);

    var goalEditingController = TextEditingController(
      text: (record != null) ? record.name : "",
    );

    var reasonEditingController = TextEditingController(
      text: (record != null) ? record.reason : "",
    );

    Widget saveGoal = buildSaveGoalButton(
        goalEditingController, reasonEditingController, context);

    Widget cancelButton = buildCancelButton(context);

    var scrollController = ScrollController();

    TextField goalTextField =
        buildTextField(scrollController, goalEditingController, bloc.setGoal);

    TextField reasonTextField = buildTextField(
        scrollController, reasonEditingController, bloc.setReason);

    return Scaffold(
      backgroundColor: appBarColor,
      body: Container(
        color: appBarColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 64, 8, 0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TokenText(text: 'I\'m going to'),
                  goalTextField,
                  TokenText(text: 'Because it\'s going to help me'),
                  reasonTextField,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [cancelButton, saveGoal],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return AppButton(
      color: appRed,
      onPressed: () => Navigator.pop(context),
      child: AppButtonText(
        'Cancel',
        textColor: Colors.white,
      ),
    );
  }

  Widget buildSaveGoalButton(TextEditingController goalEditingController,
      TextEditingController reasonEditingController, BuildContext context) {
    final bloc = GoalEntryProvider.of(context).bloc;
    final debouncer = Debouncer(milliseconds: 1000);
    return StreamBuilder<bool>(
      stream: bloc.isSaveEnabled,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('something went wrong');
        }
        final isEnabled = snapshot.data;
        return AppButton(
          color: appGreen,
          onPressed: isEnabled
              ? () async {
                  debouncer.run(() {
                    bloc
                        .save(
                            goal: goalEditingController.text,
                            reason: reasonEditingController.text,
                            goalDate: date)
                        .then((value) => Navigator.pop(context));
                  });
                }
              : null,
          child: AppButtonText(
            'Save',
            textColor: Colors.white,
          ),
        );
      },
    );
  }

  TextField buildTextField(
      ScrollController scrollController,
      TextEditingController textEditingController,
      Function(String) onChangeHandler) {
    return TextField(
      onChanged: (newText) {
        onChangeHandler(newText);
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      autofocus: true,
      controller: textEditingController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textAlign: TextAlign.center,
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
}
