import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_win_2/Screens/goal_entry_screen.dart';
import 'package:flutter_win_2/Screens/loggedin_screen.dart';
import 'package:flutter_win_2/Screens/note_entry_screen.dart';
import 'package:flutter_win_2/Screens/pre_login_screen.dart';
import 'package:flutter_win_2/Screens/profile_screen.dart';
import 'package:flutter_win_2/Services/user_service.dart';
import 'package:flutter_win_2/Styling/colors.dart';
import 'package:flutter_win_2/blocs/profile_provider.dart';
import 'package:flutter_win_2/blocs/router_provider.dart';
import 'Screens/router_screen.dart';
import 'blocs/settings_provider.dart';
import 'utils/notificationHelper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return RouterProvider(
      child: ProfileProvider(
        child: SettingsProvider(
          child: MaterialApp(
            home: RouterScreen(),
            onGenerateRoute: routes,
            theme: ThemeData(
                primaryColor: appBarColor,
                textTheme: TextTheme(
                  bodyText1: TextStyle(fontWeight: FontWeight.w300),
                  headline6: TextStyle(fontWeight: FontWeight.normal),
                )),
          ),
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      print("route: ${settings.name}");
      switch (settings.name) {
        case RouterScreen.id:
          return RouterScreen();
        case PreLoginScreen.id:
          return PreLoginScreen();
        case LoggedInScreen.id:
          return LoggedInScreen();
        case GoalEntryScreen.id:
          return GoalEntryScreen();
        case NoteEntryScreen.id:
          return NoteEntryScreen();
        case ProfileScreen.id:
          return ProfileScreen();
      }
      return null;
    });
  }
}
