import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Services/goal_service.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:uuid/uuid.dart';

import '../service_factory.dart';
import 'loggedin_screen.dart';

class GoalEntryScreen extends StatelessWidget {
  static final id = 'goalEntryScreen';
  final _goalService = ServiceFactory.getGoalService();
  final _userService = ServiceFactory.getUserService();

  final Record record;
  final DateTime date;

  GoalEntryScreen({Key key, this.record, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var goalEditingController = TextEditingController(
      text: (record != null) ? record.name : "",
    );

    var reasonEditingController = TextEditingController(
      text: (record != null) ? record.reason : "",
    );

    RaisedButton saveGoal = buildSaveGoalButton(
        goalEditingController, reasonEditingController, context);

    RaisedButton cancelButton = buildCancelButton(context);

    var scrollController = ScrollController();

    TextField goalTextField =
        buildTextField(scrollController, goalEditingController);

    TextField reasonTextField =
        buildTextField(scrollController, reasonEditingController);

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

  RaisedButton buildCancelButton(BuildContext context) {
    var cancelButton = RaisedButton(
      color: appRed,
      onPressed: () => Navigator.pop(context),
      child: Text('Cancel'),
    );
    return cancelButton;
  }

  RaisedButton buildSaveGoalButton(TextEditingController goalEditingController,
      TextEditingController reasonEditingController, BuildContext context) {
    var saveNotes = RaisedButton(
      color: appGreen,
      onPressed: () async {
        var userId = await _userService.userId();
        var userName = await _userService.userName();
        var uuid = Uuid();

        if (record == null) {
          var goal = Goal(
              uuid.v4(),
              goalEditingController.text,
              reasonEditingController.text,
              date,
              userName,
              userId,
              null,
              "inProgress");
          _goalService.addGoal(goal).then((value) {
            Navigator.pop(context);
          });
        } else {
          var clone = record.copyWith(
              goal: goalEditingController.text,
              reason: reasonEditingController.text);
          _goalService.update(clone).then((value) => Navigator.popUntil(
              context, ModalRoute.withName(LoggedInScreen.id)));
        }
      },
      child: Text('Save'),
    );
    return saveNotes;
  }

  TextField buildTextField(ScrollController scrollController,
      TextEditingController textEditingController) {
    return TextField(
      onChanged: (newText) {
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
