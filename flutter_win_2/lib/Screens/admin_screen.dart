import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Widgets/goal_list_tile.dart';
import 'package:flutter_win_2/blocs/index.dart';

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
                  final listTileAdapter =
                      AdminScreenListTileAdapter(goals[index]);
                  return GoalListTile(
                    adapter: listTileAdapter,
                  );
                },
                reverse: false,
                itemCount: goals.length);
          }),
    );
  }
}
