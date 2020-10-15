import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Model/user.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/profile_stat_card.dart';
import 'package:flutter_win_2/blocs/index.dart';

class ProfileScreen extends StatelessWidget {
  static const id = "profileScreen";

  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileBloc = ProfileProvider.of(context).bloc;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              StreamBuilder(
                stream: profileBloc.loggedInUser,
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Oops something went wrong');
                  }
                  final user = snapshot.data;
                  return header(context, user, profileBloc);
                },
              ),
              StreamBuilder(
                  stream: profileBloc.goals,
                  builder: (context, AsyncSnapshot<List<Record>> snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Oops something went wrong');
                    }
                    final list = snapshot.data;
                    return buildGridView(list, profileBloc);
                  }),
              Center(
                child: RaisedButton(
                  color: appRed,
                  child: Text('Log out'),
                  onPressed: () {
                    profileBloc.logoutUser();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridView(List<Record> records, ProfileBloc profileBloc) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileStatCard(
              title: 'Days since first goal',
              value: profileBloc.findDaysSinceFirstGoal(records),
            ),
            ProfileStatCard(
              title: 'Days since last goal',
              value: profileBloc.findDaysSinceLatestGoal(records),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileStatCard(
              title: 'Goals created',
              value: profileBloc.countGoals(records),
            ),
            ProfileStatCard(
              title: 'Notes created',
              value: profileBloc.countNotes(records),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileStatCard(
              title: 'Longest Streak',
              value: profileBloc.findLongestStreak(records),
            ),
            ProfileStatCard(
              title: 'Current Streak',
              value: profileBloc.findCurrentStreak(records),
            ),
          ],
        )
      ],
    );
  }

  Widget header(BuildContext context, User user, ProfileBloc profileBloc) {
    return Container(
      color: appBarColor,
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
                radius: 50.0,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                StreamBuilder(
                  stream: profileBloc.goals,
                  builder: (context, AsyncSnapshot<List<Record>> snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'Oops something went wrong',
                        textAlign: TextAlign.center,
                      );
                    }
                    final usage = profileBloc.findUsageRate(snapshot.data);
                    final daysPerWeek = (usage * 7).round();
                    return Container(
                      color: appBarColor,
                      child: Text(
                        'In an average week, you\'d set a goal on $daysPerWeek out of 7 days.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
