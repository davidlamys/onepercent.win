import 'package:flutter/material.dart';
import 'package:flutter_win_2/Services/user_service.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/blocs/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const id = "settingsScreen";

  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = SettingsProvider.of(context).bloc;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        color: appBarColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: RaisedButton(
                color: appRed,
                child: Text('Log out'),
                onPressed: () {
                  settingsBloc.logoutUser();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
