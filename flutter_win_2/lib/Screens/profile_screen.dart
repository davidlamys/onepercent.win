import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/record.dart';
import 'package:flutter_win_2/Model/user.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/Widgets/app_button.dart';
import 'package:flutter_win_2/Widgets/profile_stat_card.dart';
import 'package:flutter_win_2/blocs/index.dart';

class ProfileScreen extends StatelessWidget {
  static const id = "profileScreen";

  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileBloc = ProfileProvider.of(context).bloc;

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
                    return Text('Oops something went wrong no user found');
                  }
                  final user = snapshot.data;
                  if (user.email == null) {
                    return anonHeader(context, user, profileBloc);
                  }
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

  Widget anonHeader(BuildContext context, User user, ProfileBloc profileBloc) {
    final linkUserButton = AppButton(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text('Link with Google'),
        ),
        onPressed: () {
          profileBloc.linkUser().then((value) {
            if (value) {
              showLinkedSuccessDialog(context);
            }
          }).catchError((error) {
            print('i ve got you mr error');
            print(error);
            showLinkFailedDialog(context);
          });
        });

    return Container(
      color: appBarColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              flex: 2,
              child: getUsageRatePrompt(profileBloc),
            ),
            Flexible(
              flex: 1,
              child: linkUserButton,
            ),
          ],
        ),
      ),
    );
  }

  void showLinkFailedDialog(BuildContext context) {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Oops..Something went wrong!"),
          content: new Text(
              "We could not link the account.\nPlease try again later."),
        ));
  }

  void showLinkedSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text("Thank you"),
          content: new Text("Account linked successfully"),
        ));
  }

  Widget header(BuildContext context, User user, ProfileBloc profileBloc) {
    return Container(
      color: appBarColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: buildProfileMainRow(user, profileBloc),
      ),
    );
  }

  Row buildProfileMainRow(User user, ProfileBloc profileBloc) {
    var widgets = List<Widget>();
    if (user.photoUrl != null) {
      widgets.add(Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              user.photoUrl,
            ),
            radius: 50.0,
          ),
        ),
      ));
    }
    widgets.add(Flexible(
      flex: 2,
      child: buildProfileColumn(user, profileBloc),
    ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widgets,
    );
  }

  Column buildProfileColumn(User user, ProfileBloc profileBloc) {
    var widgets = List<Widget>();
    if (user.displayName != null && user.displayName != "") {
      widgets.add(Text(
        user.displayName,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    if (user.email != null) {
      widgets.add(Text(
        user.email,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ));
    }
    widgets.add(getUsageRatePrompt(profileBloc));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  StreamBuilder<List<Record>> getUsageRatePrompt(ProfileBloc profileBloc) {
    return StreamBuilder(
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
            'In an average week, you\'d set a goal on $daysPerWeek out of 7 days since starting this app.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      },
    );
  }
}
