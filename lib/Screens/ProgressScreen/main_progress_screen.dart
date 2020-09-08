import 'dart:convert';

import 'package:com/Design/colours.dart';
import 'package:com/PopUps/progress_indicator.dart';
import 'package:com/Screens/ExerciseScreen/exercise_manage.dart';
import 'package:com/Screens/ProgressScreen/exercise_screen.dart';
import 'package:com/Screens/ProgressScreen/walking_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/Database/Services/db_management.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/exercise_json_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProgressScreenRootClass {
  final User user;

  MainProgressScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Overall Progress',
        contentBuilder: (_) => MainProgressScreen(user));
  }
}

class MainProgressScreen extends StatefulWidget {
  final User _user;

  MainProgressScreen(this._user);

  @override
  _MainProgressScreenState createState() => _MainProgressScreenState();
}

class _MainProgressScreenState extends State<MainProgressScreen> {
  SharedPreferences _preferences;
  Map<String, Map<String, dynamic>> _exerciseDisplaySettings = {};

  final List<Color> _colorPal = [
    Color.fromRGBO(222, 222, 222, 1),
    Color.fromRGBO(157, 247, 250, 1),
    Color.fromRGBO(71, 212, 203, 1),
    Color.fromRGBO(45, 235, 121, 1),
    Color.fromRGBO(119, 255, 89, 1),
    Color.fromRGBO(255, 150, 117, 1),
  ];

  final List<String> _icons = [
    'images/Icons/steps.png',
    'images/Icons/Cycling.png',
    'images/Icons/Sit-Ups.png',
    'images/Icons/push-ups.png',
    'images/Icons/pull-ups.png',
    'images/Icons/Jogging.png',
  ];

  void _initSettings() async {
    _preferences = await SharedPreferences.getInstance();
    ExerciseJsonManipulation _ejm = new ExerciseJsonManipulation();

    Map<String, Map<String, dynamic>> result = await _ejm.initSettings();

    if(result != null) {
      setState(() {
        _exerciseDisplaySettings = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initSettings();
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseManagement _db = new DatabaseManagement(widget._user);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final List<Widget> _screens = [
      WalkingScreen(widget._user),
      ExerciseScreen(
        user: widget._user,
        icon: _icons[1],
        accentColor: _colorPal[1],
        appBarTitle: 'Cycling Progress',
        field: 'Cycling',
        popupText:
            'Circular Progress indicator at the top indicates todays Cycling minutes. '
            'The bottom graph shows weekly/monthly average progress. '
            'Press the "Monthly/Weekly" button, at the top of the graph '
            'to switch between modes. \n\n At the bottom of the weekly '
            ' graph, letters represents the name of the day.\n\n'
            'At the bottom of the monthly graph numbers represents the '
            'months.',
        division: 1,
        isTimerDisplayed: true,
      ),
      ExerciseScreen(
        user: widget._user,
        icon: _icons[2],
        accentColor: _colorPal[2],
        appBarTitle: 'Sit-Ups Progress',
        field: 'Sit-Ups',
        popupText:
            'Circular Progress indicator at the top indicates todays Sit-Ups progress. '
            'The bottom graph shows weekly/monthly average progress. '
            'Press the "Monthly/Weekly" button, at the top of the graph '
            'to switch between modes. \n\n At the bottom of the weekly '
            ' graph, letters represents the name of the day.\n\n'
            'At the bottom of the monthly graph numbers represents the '
            'months.',
        division: 1,
        isTimerDisplayed: false,
      ),
      ExerciseScreen(
        user: widget._user,
        icon: _icons[3],
        accentColor: _colorPal[3],
        appBarTitle: 'Push-Ups Progress',
        field: 'Push-Ups',
        popupText:
            'Circular Progress indicator at the top indicates todays Push-Ups progress. '
            'The bottom graph shows weekly/monthly average progress. '
            'Press the "Monthly/Weekly" button, at the top of the graph '
            'to switch between modes. \n\n At the bottom of the weekly '
            ' graph, letters represents the name of the day.\n\n'
            'At the bottom of the monthly graph numbers represents the '
            'months.',
        division: 1,
        isTimerDisplayed: false,
      ),
      ExerciseScreen(
        user: widget._user,
        icon: _icons[4],
        accentColor: _colorPal[4],
        appBarTitle: 'Pull-Ups Progress',
        field: 'Pull-Ups',
        popupText:
            'Circular Progress indicator at the top indicates todays Pull-Ups progress. '
            'The bottom graph shows weekly/monthly average progress. '
            'Press the "Monthly/Weekly" button, at the top of the graph '
            'to switch between modes. \n\n At the bottom of the weekly '
            ' graph, letters represents the name of the day.\n\n'
            'At the bottom of the monthly graph numbers represents the '
            'months.',
        division: 1,
        isTimerDisplayed: false,
      ),
      ExerciseScreen(
        user: widget._user,
        icon: _icons[5],
        accentColor: _colorPal[5],
        appBarTitle: 'Jogging Progress',
        field: 'Jogging',
        popupText:
            'Circular Progress indicator at the top indicates todays Jogging minutes. '
            'The bottom graph shows weekly/monthly average progress. '
            'Press the "Monthly/Weekly" button, at the top of the graph '
            'to switch between modes. \n\n At the bottom of the weekly '
            ' graph, letters represents the name of the day.\n\n'
            'At the bottom of the monthly graph numbers represents the '
            'months.',
        division: 1,
        isTimerDisplayed: true,
      ),
    ];

    Future<Map<String, dynamic>> _future = _db.retrieveExerciseInfoMap();
    List<Widget> children = new List();

    return Scaffold(
      body: Container(
        color: mainColor,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              children.clear();
              final Map<String, dynamic> exerciseInfoList = snapshot.data;
              exerciseInfoList.remove('LastUpdated');
              final int exerciseLen = exerciseInfoList.length;
              children.add(Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.7,
                    child: Container(
                      width: _width,
                      height: _height * 0.269,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/stairs.jpg'),
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _width * 0.05,
                    top: _width * 0.18,
                    child: Text(
                      'Little Things Make',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'PTSerif',
                          fontSize: 18,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                  Positioned(
                    right: _width * 0.03,
                    top: _height * 0.237,
                    child: Text(
                      'The Difference',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'PTSerif',
                          fontSize: 18,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ],
              ));
              for (var i = 0; i < exerciseLen; ++i) {
                if (json.decode(_preferences.getString('exerciseSettings'))[
                    'exerciseSettings'][exerciseInfoList.keys.elementAt(i)]) {
                  children.add(Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => _screens[i])),
                      child: Container(
                        width: 256,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                              width: 2.0, color: _colorPal[i].withOpacity(0.7)),
                          color: _colorPal[i].withOpacity(0.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 256 / 3,
                              height: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      snapshot.data.keys.elementAt(i),
                                      style: TextStyle(
                                          color: _colorPal[i].withOpacity(0.7),
                                          fontFamily: 'PTSerif',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      snapshot.data.values.elementAt(i),
                                      style: TextStyle(
                                          color: _colorPal[i].withOpacity(0.7),
                                          fontFamily: 'PTSerif',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 2.0,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                    _colorPal[i].withOpacity(0.7),
                                    _colorPal[i].withOpacity(0.1),
                                    Colors.transparent,
                                    _colorPal[i].withOpacity(0.1),
                                    _colorPal[i].withOpacity(0.7),
                                  ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: CircularPercentIndicator(
                                  radius: 69.0,
                                  backgroundColor: mainColor.withOpacity(0.3),
                                  animation: true,
                                  center: Image(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 50,
                                    color: Colors.black,
                                    image: AssetImage(_icons[i]),
                                  ),
                                  percent: 1,
                                  animationDuration: 2,
                                  lineWidth: 2.0,
                                  progressColor: _colorPal[i].withOpacity(0.7),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
                }
              }
              children.add(GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                      builder: (_) => ExerciseManage(
                          _preferences.getString(
                              'exerciseSettings'))))
                      .then((value) {
                    setState(() {
                      children.clear();
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    width: 185,
                    height: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56.0),
                        color: Color.fromRGBO(155, 144, 130, 1)),
                    child: Container(
                      margin: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56.0),
                          color: Colors.black),
                      child: Center(
                          child: Text(
                        'Manage',
                        style: TextStyle(
                            color: Color.fromRGBO(155, 144, 130, 1),
                            fontFamily: 'PTSerif',
                            fontSize: 18,
                            fontWeight: FontWeight.w200),
                      )),
                    ),
                  ),
                ),
              ));
            } else if (snapshot.hasError) {
              children = <Widget>[
                Text('There was a problem with connection, '
                    'please try again')
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 55,
                  height: 55,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text('Waiting for the results'),
                ),
              ];
            }
            return Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: _width,
                    height: _height,
                    color: mainColor,
                  ),
                  BackgroundTriangle(),
                  Container(
                    width: _width,
                    height: _height,
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
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children.length == 0
                            ? awaitResult('Calculating Your Progress')
                            : children,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
