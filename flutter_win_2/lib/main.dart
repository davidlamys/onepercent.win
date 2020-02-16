import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_win_2/Screens/add_goal_screen.dart';
import 'package:flutter_win_2/Screens/loggedin_screen.dart';
import 'package:flutter_win_2/Screens/pre_login_screen.dart';
import 'package:flutter_win_2/Services/user_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final userService = UserService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouterScreen.id,
      routes: {
        RouterScreen.id: (context) => RouterScreen(),
        PreLoginScreen.id: (context) => PreLoginScreen(),
        LoggedInScreen.id: (context) => LoggedInScreen(),
        AddGoalScreen.id: (context) => AddGoalScreen(),
      },
    );
  }
}

class RouterScreen extends StatefulWidget {
  static const String id = "router_screen";
  @override
  _RouterScreenState createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  final userService = UserService();
  bool _hasUser = false;
  bool _isCheckingForUser = false;

  BuildContext _context;

  @override
  void initState() {
    super.initState();
    checkForUser();
  }

  void checkForUser() async {
    setState(() {
      _isCheckingForUser = true;
    });

    var hasUser = await userService.hasLoggedInUser();

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isCheckingForUser = false;
      _hasUser = hasUser;
    });

    if (_context != null) {
      if (hasUser) {
        Navigator.pushNamed(_context, LoggedInScreen.id);
      } else {
        Navigator.pushNamed(_context, PreLoginScreen.id);
      }
    } else {
      print('no context');
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    print('rebuildinggggg');
    return Scaffold(
        backgroundColor: Colors.black54,
        body: _isCheckingForUser
            ? SpinKitChasingDots(
                color: Colors.amberAccent,
              )
            : null);
  }

  Widget bodyWidget(BuildContext context) {
    if (_hasUser) {
      return null;
    } else {
      Navigator.pushNamed(context, PreLoginScreen.id);
      print('pushingggggg');
      return null;
    }
  }
}
//
//class RouterScreen extends StatelessWidget {}
