import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreLoginScreen extends StatefulWidget {
  static const String id = "pre_login_screen";
  @override
  _PreLoginScreenState createState() => _PreLoginScreenState();
}

final style = TextStyle(
  color: Colors.white,
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

class _PreLoginScreenState extends State<PreLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TypewriterAnimatedTextKit(
                  text: [
                    'Be one percent better than yesterday',
                  ],
                  textStyle: style,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              SignInButton(
                Buttons.GoogleDark,
                onPressed: () {},
              ),
              SizedBox(
                height: 10.0,
              ),
              SignInButtonBuilder(
                backgroundColor: Colors.amberAccent.shade400,
                onPressed: () {},
                text: 'Continue anonymoulsy',
                icon: FontAwesomeIcons.userSecret,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconButton extends StatelessWidget {
  final String text;
  @required
  final onPressed;
  const IconButton({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: style.copyWith(fontSize: 15.0),
      ),
      color: Colors.lightBlueAccent,
      onPressed: onPressed,
    );
  }
}
