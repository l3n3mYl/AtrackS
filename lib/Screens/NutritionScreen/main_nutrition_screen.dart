import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/UiComponents/nutrition_card_rect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MainNutritionScreenRootClass {
  final FirebaseUser user;

  MainNutritionScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Nutrition Progress',
        contentBuilder: (_) => MainNutritionScreen(user));
  }
}

class MainNutritionScreen extends StatefulWidget {
  final FirebaseUser _user;

  MainNutritionScreen(this._user);

  @override
  _MainNutritionScreenState createState() => _MainNutritionScreenState();
}

class _MainNutritionScreenState extends State<MainNutritionScreen> {
  final List<Color> _colorPal = [
    Color.fromRGBO(189, 253, 255, 1), //blue
    Color.fromRGBO(255, 188, 122, 1), //orange
    Color.fromRGBO(156, 255, 162, 1), //green
    Color.fromRGBO(246, 255, 125, 1), //yellow
    Color.fromRGBO(255, 163, 163, 1), //pink
  ];

  DatabaseManagement _management;
  List<Widget> cardList = new List<Widget>();

  @override
  void initState() {
    super.initState();
    getNutritionInfo();
  }

  void getNutritionInfo() async {
    _management = DatabaseManagement(widget._user);
    await _management.retrieveNutritionInfoMap().then((value) {
      setState(() {
        calculatePercentage(value);
      });
    });
  }

  void calculatePercentage(Map nutritionValue) async {
    _management = DatabaseManagement(widget._user);
    List<int> goals = new List<int>();
    List<int> currProgress = new List<int>();
    List<double> percentage = new List<double>();
    for (var i = 0; i < nutritionValue.length; ++i) {
      if (nutritionValue.keys.elementAt(i).toString() != 'LastUpdated') {
        await _management
            .getSingleFieldInfo('nutrition_goals',
                '${nutritionValue.keys.elementAt(i).toString()}_Goals')
            .then((value) {
          goals.add(int.parse(value));
        });
        await _management
            .getSingleFieldInfo(
                'nutrition', nutritionValue.keys.elementAt(i).toString())
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
        addDataCards(nutritionValue, percentage, goals, currProgress);
      });
    }
  }

  void addDataCards(Map nutritionInfo, List<double> percentage, List<int> goals,
      List<int> currProgress) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Map<String, dynamic> newMap = nutritionInfo;
    newMap.remove('LastUpdated');
    if (nutritionInfo != null) {
      for (var i = 0; i < newMap.length; ++i) {
        cardList.add(Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0),
          child: Container(
            width: _width,
            height: _height * 0.09,
            color: Colors.black26,
            child: Stack(
              children: <Widget>[
                NutritionCardTriangle(_colorPal[i].withOpacity(0.5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        nutritionInfo.keys.elementAt(i),
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '${currProgress[i]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PTSerif',
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'g',
                              style: TextStyle(
                                  color: _colorPal[i],
                                  fontFamily: 'PTSerif',
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PTSerif',
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${goals[i]}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'PTSerif',
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'g',
                              style: TextStyle(
                                  color: _colorPal[i],
                                  fontFamily: 'PTSerif',
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 13.0,
                            )
                          ],
                        ),
                        Container(
                            width: _height * 0.2,
                            height: 30.0,
                            child: LinearPercentIndicator(
                              alignment: MainAxisAlignment.center,
                              percent: percentage[i],
                              backgroundColor: Colors.white,
                              progressColor: _colorPal[i],
                              animationDuration: 2,
                              animation: true,
                            )),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
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
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: AspectRatio(
                              aspectRatio: 18 / 9,
                              child: Opacity(
                                opacity: 0.69,
                                child: Image(
                                  image: AssetImage('images/nutrition.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: cardList,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: _width,
                      height: _height * 0.24,
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, left: 16.0),
                            child: Container(
                              child: Text(
                                'EAT WELL',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 100.0),
                            child: Container(
                              child: Text(
                                'LIVE WELL',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0, left: 200.0),
                            child: Container(
                              child: Text(
                                'BE WELL',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
