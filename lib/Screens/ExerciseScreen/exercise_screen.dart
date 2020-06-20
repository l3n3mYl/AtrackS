import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/Screens/ExerciseScreen/individual_exercise_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        popupText: 'asd',
        stepCounter: true,
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Cycling',
        accentColor: _colorPal[1],
        icon: _icons[1],
        appBarTitle: 'Cycling',
        popupText: 'asd',
        timeCounter: true,
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Sit-Ups',
        accentColor: _colorPal[2],
        icon: _icons[2],
        appBarTitle: 'Sit-Ups',
        popupText: 'asd',
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Push-Ups',
        accentColor: _colorPal[3],
        icon: _icons[3],
        appBarTitle: 'Sit-Ups',
        popupText: 'asd',
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Pull-Ups',
        accentColor: _colorPal[4],
        icon: _icons[4],
        appBarTitle: 'Pull-Ups',
        popupText: 'asd',
      ),
      IndividualExerciseScreen(
        user: widget._user,
        field: 'Jogging',
        accentColor: _colorPal[5],
        icon: _icons[5],
        appBarTitle: 'Jogging',
        popupText: 'asd',
        timeCounter: true,
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
