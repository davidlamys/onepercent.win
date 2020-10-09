import 'package:flutter/material.dart';
import 'package:flutter_win_2/Model/user.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/blocs/profile_provider.dart';
import 'package:flutter_win_2/blocs/settings_provider.dart';

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
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
              stream: profileBloc.loggedInUser,
              builder: (context, AsyncSnapshot<User> snapshot) {
                if (!snapshot.hasData) {
                  return Text('Oops something went wrong');
                }
                final user = snapshot.data;
                return header(user);
              },
            ),
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
    );
  }

  Widget header(User user) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [appBarColor, appBarColor])),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 24.0,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(
                user.photoUrl,
              ),
              radius: 50.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
