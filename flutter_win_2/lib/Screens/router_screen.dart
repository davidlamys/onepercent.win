import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_win_2/Screens/loggedin_screen.dart';
import 'package:flutter_win_2/Screens/pre_login_screen.dart';
import 'package:flutter_win_2/blocs/router_provider.dart';

class RouterScreen extends StatefulWidget {
  static const String id = "router_screen";
  @override
  _RouterScreenState createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  BuildContext _context;

  @override
  void initState() {
    super.initState();
  }

  void checkForUser(BuildContext _context) async {
    final bloc = RouterProvider.of(context).bloc;
    bloc.user.listen((FirebaseUser user) async {
      Navigator.of(context).popUntil((route) => route.isFirst);
      await Future.delayed(Duration(milliseconds: 500));
      if (user == null) {
        Navigator.pushNamed(context, PreLoginScreen.id);
      } else {
        Navigator.pushNamed(_context, LoggedInScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    print('rebuildinggggg');
    checkForUser(_context);
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SpinKitChasingDots(
        color: Colors.amberAccent,
      ),
    );
  }
}
