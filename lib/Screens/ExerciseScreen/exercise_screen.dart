import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/Screens/NutritionScreen/individual_nutrition_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/UiComponents/nutrition_card_rect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MainExerciseScreenRootClass {
  final FirebaseUser user;

  MainExerciseScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Nutrition Progress',
        contentBuilder: (_) => MainExerciseScreen(user));
  }
}

class MainExerciseScreen extends StatefulWidget {
  final FirebaseUser _user;

  MainExerciseScreen(this._user);

  @override
  _MainExerciseScreenState createState() => _MainExerciseScreenState();
}

class _MainExerciseScreenState extends State<MainExerciseScreen> {
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

  DatabaseManagement _management;
  List<Widget> cardList = new List<Widget>();

  @override
  void initState() {
    super.initState();
    getExerciseInfo();
  }

  void getExerciseInfo() async {
    _management = DatabaseManagement(widget._user);
    await _management.retrieveExerciseInfoMap().then((value) {
      setState(() {
        calculatePercentage(value);
      });
    });
  }

  void calculatePercentage(Map exerciseValue) async {
    _management = DatabaseManagement(widget._user);
    List<int> goals = new List<int>();
    List<int> currProgress = new List<int>();
    List<double> percentage = new List<double>();
    for (var i = 0; i < exerciseValue.length; ++i) {
      if (exerciseValue.keys.elementAt(i).toString() != 'LastUpdated') {
        await _management
            .getSingleFieldInfo('exercise_goals',
                '${exerciseValue.keys.elementAt(i).toString()}_Goal')
            .then((value) {
          goals.add(int.parse(value));
        });
        await _management
            .getSingleFieldInfo(
                'exercises', exerciseValue.keys.elementAt(i).toString())
            .then((value) {
          currProgress.add(int.parse(value));
        });
      }
    }
    if (goals.length != 0 && currProgress.length != 0) {
      for (var i = 0; i < goals.length; ++i) {
        percentage.add(currProgress[i] / goals[i]);
        if (percentage[i] > 1.0) {
          percentage[i] = 1.0;
        }
      }
      setState(() {
        addDataCards(exerciseValue);
      });
    }
  }

  void addDataCards(Map nutritionInfo) {
    final List<Widget> _screens = [
      IndividualNutritionScreen(
        division: 100,
        appBarTitle: 'Water Consumption',
        user: widget._user,
        accentColor: _colorPal[0],
        field: 'Water',
        popupText: 'Edit me plis',
        measure: 'ml',
      ),
      IndividualNutritionScreen(
        division: 10,
        appBarTitle: 'Carbs Consumption',
        user: widget._user,
        accentColor: _colorPal[1],
        field: 'Carbs',
        popupText: 'Edit me plis',
        measure: 'mg',
      ),
      IndividualNutritionScreen(
        division: 1,
        appBarTitle: 'Fats Consumption',
        user: widget._user,
        accentColor: _colorPal[2],
        field: 'Fats',
        popupText: 'Edit me plis',
        measure: 'mg',
      ),
      IndividualNutritionScreen(
        division: 100,
        appBarTitle: 'Calorie Consumption',
        user: widget._user,
        accentColor: _colorPal[3],
        field: 'Calories',
        popupText: 'Edit me plis',
        measure: 'kcal',
      ),
      IndividualNutritionScreen(
        division: 1,
        appBarTitle: 'Protein Consumption',
        user: widget._user,
        accentColor: _colorPal[4],
        field: 'Protein',
        popupText: 'Edit me plis',
        measure: 'mg',
      ),
    ];

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Map<String, dynamic> newMap = nutritionInfo;
    newMap.remove('LastUpdated');
    if (nutritionInfo != null) {
      for (var i = 0; i < newMap.length; ++i) {
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
                                  onTap: () {},
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
                                  onTap: () {},
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
