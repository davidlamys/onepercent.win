import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/blocs/index.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = AdminScreenProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, nosey one'),
      ),
      body: StreamBuilder<List<Record>>(
          stream: bloc.goalsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return Container();
            }
            final goals = snapshot.data.reversed.where((element) {
              return ((element.name == null ||
                      element.reason == null ||
                      element.createdBy == null) ==
                  false);
            }).toList();

            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return _buildDateSelectionBox(context, goals[index]);
                },
                reverse: false,
                itemCount: goals.length);
          }),
    );
  }

  Widget _buildDateSelectionBox(BuildContext context, Record record) {
    final timeStampString = dayFormat().format(record.timestamp);
    final token1 = "I want to ";
    final token2 = " because it is going to help me to ";
    final statusEmoji = getEmojiString(record);
    if (record.status == null) {}
    final titleString = record.createdBy +
        ": " +
        token1 +
        record.name +
        token2 +
        record.reason +
        statusEmoji;

    return ListTile(
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        title: Text(
          titleString,
        ),
        subtitle: Text(
          timeStampString,
        ),
        onTap: () {
          showFullRecord(context, record, "Reflection");
        });
  }

  void showFullRecord(BuildContext context, Record record, String titleString) {
    if (record.notes == null) {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("No reflection yet"),
          ));
      return;
    }
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text(titleString),
          content: new Text(record.notes),
        ));
  }

  DateFormat dayFormat() {
    return DateFormat('d MMM yy');
  }
}
