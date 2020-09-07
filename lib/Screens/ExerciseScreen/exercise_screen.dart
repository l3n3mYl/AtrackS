import 'dart:convert';

import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/Screens/ExerciseScreen/exercise_manage.dart';
import 'package:com/Screens/ExerciseScreen/individual_exercise_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/exercise_json_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainExerciseScreenRootClass {
  final User user;

  MainExerciseScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Nutrition Progress',
        contentBuilder: (_) => MainExerciseScreen(user));
  }
}

class MainExerciseScreen extends StatefulWidget {
  final User _user;

  MainExerciseScreen(this._user);

  @override
  _MainExerciseScreenState createState() => _MainExerciseScreenState();
}

class _MainExerciseScreenState extends State<MainExerciseScreen> {

  DatabaseManagement _management;
  List<Widget> cardList = new List<Widget>();
  Map<String, Map<String, dynamic>> _exerciseDisplaySettings;
  SharedPreferences _preferences;
  
  final List<Color> _colorPal = [
    Color.fromRGBO(181, 217, 156, 1), //yellow
    Color.fromRGBO(181, 217, 156, 1), //yellow
    Color.fromRGBO(97, 229, 172, 1), //yellow-orange
    Color.fromRGBO(97, 229, 172, 1), //yellow-orange
    Color.fromRGBO(103, 161, 224, 1), //orange
    Color.fromRGBO(103, 161, 224, 1), //orange
  ];

  final List<String> _icons = [
    'images/Icons/steps.png',
    'images/Icons/Cycling.png',
    'images/Icons/Sit-Ups.png',
    'images/Icons/push-ups.png',
    'images/Icons/pull-ups.png',
    'images/Icons/Jogging.png',
  ];


  @override
  void initState() {
    super.initState();
    getExerciseInfo();
    _exerciseDisplaySettings = {};
    _initSettings();
  }

  void _checkSettings() {

    ExerciseJsonManipulation _ejm = new ExerciseJsonManipulation();

    Map<String, bool> _controlSettings = {
      'Cycling':true,
      'Jogging':true,
      'Pull-Ups':true,
      'Push-Ups':true,
      'Sit-Ups':true,
      'Steps':true,
    };

    if(_exerciseDisplaySettings["exerciseSettings"] == null) {
      _exerciseDisplaySettings["exerciseSettings"] = _controlSettings;
      _preferences.setString("exerciseSettings", json.encode(
          _ejm.encodeMap(_exerciseDisplaySettings)));
    }
  }

  void _initSettings() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _exerciseDisplaySettings = Map<String, Map<String, dynamic>>.from(
        json.decode(_preferences.getString("exerciseSettings"))
      );
    });
    _checkSettings();
  }

  void getExerciseInfo() async {
    _management = DatabaseManagement(widget._user);
    await _management.retrieveExerciseInfoMap().then((value) {
      setState(() {
        addDataCards(value);
      });
    });
  }

  void addDataCards(Map nutritionInfo) {
    final List<Widget> _screens = [
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Steps',
        accentColor: _colorPal[0],
        icon: _icons[0],
        appBarTitle: 'Steps',
        popupText: 'In here the steps will be monitored automatically.\n\n'
            'Calories will be shown down below according to your pace and '
            'the amount of steps you have made.\n\n'
            'Daily step goal can be changed in the settings at any time.\n\n'
            'Calories will be calculated depending on your pace and the amount '
            'of steps you have made.',
        stepCounter: true,
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Cycling',
        accentColor: _colorPal[1],
        icon: _icons[1],
        appBarTitle: 'Cycling',
        popupText: 'Press and hold onto the cycling icon to choose the pace '
            'you will be cycling.\n\n'
            'The default pace is set to 9 km/h. This will determine the amount '
            'of burned calories.\n\n'
            'The Daily goal can always be changed in the settings.\n\n'
            'Calories will be counted by your weight, time and pace you are '
            'cycling.',
        timeCounter: true,
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Sit-Ups',
        accentColor: _colorPal[2],
        icon: _icons[2],
        appBarTitle: 'Sit-Ups',
        popupText: 'Place your phone on a table, or any other surface, '
            'facing up\n\n'
            'Tap the Sit Up icon when in the lowest sit up position to '
            'indicate your first sit up.\n\n'
            'Repeat for all of the situps.\n\n'
            'The Calories will be calculated according to the amount of situps '
            'you have made and the time it took you between even number of '
            'situps.\n\n'
            'Your weight will also be taken into the calculations for a better '
            'accuracy.',
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Push-Ups',
        accentColor: _colorPal[3],
        icon: _icons[3],
        appBarTitle: 'Sit-Ups',
        popupText: 'Place your phone on the floor facing up.\n\n'
            'When in the lowest push up position, try to tap the push up icon '
            'with your nose to record the push up.\n\n'
            'Calories will be calculated depending on your weight and time '
            'between even number of push ups.',
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Pull-Ups',
        accentColor: _colorPal[4],
        icon: _icons[4],
        appBarTitle: 'Pull-Ups',
        popupText: 'Try to get creative with this exercise tracking.\n\n'
            'One pull up burns around 1 calorie.\n\nYou can tap the screen for '
            'the amount of pull ups you have made or try to tap the screen '
            'after each pull up in a more creative way.',
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Jogging',
        accentColor: _colorPal[5],
        icon: _icons[5],
        appBarTitle: 'Jogging',
        popupText: 'Calories are calculated depending on time you are jogging.\n\n'
            'Your weight also has an impact on the amount of burned calories.\n\n'
            'Daily goal can always be set in the settings.\n\n'
            'Don\'t forget that you can pause and continue at any time when '
            'jogging.\n\n'
            'If you leave this screen, the timer will be reset.',
        timeCounter: true,
      ),
    ];

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Map<String, dynamic> newMap = nutritionInfo;
    newMap.remove('LastUpdated');
    if (nutritionInfo != null) {
      for (var i = 0; i < newMap.length; ++i) {
        if(json.decode(_preferences.getString('exerciseSettings'))
          ['exerciseSettings'][newMap.keys.elementAt(i)]){
          cardList.add(GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _screens[i])),
            child: GridTile(
              child: Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2.0, color: _colorPal[i]
                  ),
                  color: _colorPal[i].withOpacity(0.35),
                ),
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                            _icons[i],
                            color: _colorPal[i],
                            width: 50.0,
                            height: 50.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(width: _width, height: 2.0, color: _colorPal[i],),
                        ),
                        Text(
                            newMap.keys.elementAt(i),
                          style: TextStyle(
                            fontFamily: 'PTSerif',
                            fontSize: 24.0,
                            color: _colorPal[i]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: cardList == []
            ? Container(
                width: _width,
                height: _height,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2.0,
                  ),
                ),
              )
            : Container(
                color: mainColor,
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
                      width: _width,
                      height: _height,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: _height * 0.3,
                            child: AspectRatio(
                              aspectRatio: 18 / 9,
                              child: Opacity(
                                opacity: 0.69,
                                child: Image(
                                  image: AssetImage('images/exercise.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10.0),
                            width: _width,
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    print('tips');
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 32,
                                    color: textColor,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.all(2.0),
                                      color: Colors.black,
                                      child: Text(
                                        'Tips',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'PTSerif',
                                            color: textColor
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ExerciseManage(
                                      _preferences.getString('exerciseSettings')
                                    ))).then((value) {
                                      setState(() {
                                        cardList.clear();
                                        getExerciseInfo();
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 32,
                                    color: textColor,
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      margin: EdgeInsets.all(2.0),
                                      color: Colors.black,
                                      child: Text(
                                        'Manage',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontFamily: 'PTSerif',
                                            color: textColor
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: _width,
                            height: _height * 0.52,
                            child: GridView.builder(
                              itemCount: cardList.length,
                              padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 35.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 50.0,
                                mainAxisSpacing: 50.0,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return cardList[index];
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
