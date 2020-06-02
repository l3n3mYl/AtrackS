import 'dart:async';
import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PushUpsScreen extends StatefulWidget {
  final FirebaseUser user;
  final String appBarTitile;
  final Color accentColor;
  final String icon;

  PushUpsScreen({this.user, this.accentColor, this.icon, this.appBarTitile});

  @override
  _PushUpsScreenState createState() => _PushUpsScreenState();
}

class _PushUpsScreenState extends State<PushUpsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          widget.appBarTitile,
          style: TextStyle(fontFamily: 'PTSerif'),
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
          ),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: mainColor,
          ),
          BackgroundTriangle(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: AspectRatio(
              aspectRatio: 18 / 9,
              child: Opacity(
                opacity: 0.2,
                child: Image(
                  image: AssetImage('images/main_pattern.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 13.0),
                  width: 256,
                  height: 256,
                  child: CircularPercentIndicator(
                    backgroundColor: mainColor,
                    radius: 250.0,
                    progressColor: widget.accentColor,
                    lineWidth: 3.0,
                    animationDuration: 20,
//    percent: stepGoal == null && totalSteps == null
//    ? 0.01
//        : double.parse(totalSteps) >= double.parse(stepGoal)
//    ? 1.0
//        : (double.parse(totalSteps) *
//    100 /
//    double.parse(stepGoal)) /
//    100,
                    percent: 0.5,
                    //TODO: Change
                    animation: true,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          widget.icon,
                          width: 150,
                          height: 150,
                          color: widget.accentColor,
                        ),
//    Text(stepGoal == null && totalSteps == null
//    ? '0 - 0%'
//        : '$totalSteps - ${((int.parse(totalSteps) * 100 / int.parse(stepGoal))).toStringAsFixed(0)}%',
//    style: TextStyle(
//    color: Colors.white54
//    ),
//    )//TODO: change
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
