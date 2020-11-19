import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/goal_view.dart';
import 'package:flutter_win_2/Widgets/app_button.dart';
import 'package:flutter_win_2/blocs/goal_entry/goal_entry_provider.dart';
import 'package:flutter_win_2/utils/debouncer.dart';

class GoalEntryScreen extends StatefulWidget {
  static const id = 'goalEntryScreen';

  final Record record;
  final DateTime date;

  GoalEntryScreen({Key key, this.record, this.date}) : super(key: key);

  @override
  _GoalEntryScreenState createState() {
    if (record == null) {
      return _GoalEntryScreenState(goal: "", reason: "");
    } else {
      return _GoalEntryScreenState(goal: record.name, reason: record.reason);
    }
  }
}

class _GoalEntryScreenState extends State<GoalEntryScreen> {
  _GoalEntryScreenState({this.goal, this.reason});

  String goal;
  String reason;

  var goalEditingController = TextEditingController();
  var reasonEditingController = TextEditingController();
  var scrollController = ScrollController();
  var isSaving = false;

  @override
  Widget build(BuildContext context) {
    final bloc = GoalEntryProvider.of(context).bloc;

    bloc.onSaveCompletion = () {
      Navigator.pop(context);
    };

    bloc.setRecord(widget.record);

    goalEditingController.text = goal;
    reasonEditingController.text = reason;

    List<Widget> children = buildCardChildren(bloc, context);
    return Scaffold(
      backgroundColor: appBarColor,
      body: Container(
        color: appBarColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 64, 8, 0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: buildCard(children),
          ),
        ),
      ),
    );
  }

  Card buildCard(List<Widget> children) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  List<Widget> buildCardChildren(GoalEntryBloc bloc, BuildContext context) {
    var widgets = [
      TokenText(text: 'I\'m going to'),
      buildTextField(goalEditingController, bloc.setGoal),
      TokenText(text: 'Because it\'s going to help me'),
      buildTextField(reasonEditingController, bloc.setReason),
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildCancelButton(context),
            buildSaveGoalButton(context),
          ],
        ),
      ),
    ];

    if (isSaving) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 32.0,
        ),
        child: CircularProgressIndicator(),
      ));
    }
    return widgets;
  }

  Widget buildCancelButton(BuildContext context) {
    return AppButton(
      color: appRed,
      onPressed: isSaving ? null : () => Navigator.pop(context),
      child: AppButtonText(
        'Cancel',
        textColor: Colors.white,
      ),
    );
  }

  Widget buildSaveGoalButton(BuildContext context) {
    final bloc = GoalEntryProvider.of(context).bloc;
    final debouncer = Debouncer(milliseconds: 1000);
    return StreamBuilder<bool>(
      stream: bloc.isSaveEnabled,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('something went wrong');
        }
        final isEnabled = snapshot.data && !isSaving;
        return AppButton(
          color: appGreen,
          onPressed: isEnabled
              ? () async {
                  setState(() {
                    goal = goalEditingController.text;
                    reason = reasonEditingController.text;
                    isSaving = true;
                  });
                  debouncer.run(() {
                    bloc.save(
                        goal: goalEditingController.text,
                        reason: reasonEditingController.text,
                        goalDate: widget.date);
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

  TextField buildTextField(TextEditingController textEditingController,
      Function(String) onChangeHandler) {
    return TextField(
      onChanged: (newText) {
        onChangeHandler(newText);
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      },
      enabled: !isSaving,
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
