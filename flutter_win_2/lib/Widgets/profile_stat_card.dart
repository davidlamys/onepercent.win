import 'package:flutter/material.dart';
import 'package:flutter_win_2/Styling/colors.dart';

const kstyle = TextStyle(
  color: appGreen,
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
);

class ProfileStatCard extends StatelessWidget {
  final String title;
  final int value;
  const ProfileStatCard({Key key, @required this.title, @required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.45,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '$value',
                style: kstyle,
              ),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
