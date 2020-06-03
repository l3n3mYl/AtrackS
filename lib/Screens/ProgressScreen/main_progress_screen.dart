import 'package:com/Design/colours.dart';
import 'package:com/Screens/ProgressScreen/cycling_screen.dart';
import 'package:com/Screens/ProgressScreen/jogging_screen.dart';
import 'package:com/Screens/ProgressScreen/pull_ups_screen.dart';
import 'package:com/Screens/ProgressScreen/push_ups_screen.dart';
import 'package:com/Screens/ProgressScreen/sit_ups_screen.dart';
import 'package:com/Screens/ProgressScreen/walking_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/Database/Services/db_management.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MainProgressScreenRootClass {
  final FirebaseUser user;

  MainProgressScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Overall Progress',
        contentBuilder: (_) => MainProgressScreen(user));
  }
}

class MainProgressScreen extends StatefulWidget {
  final FirebaseUser _user;

  MainProgressScreen(this._user);

  @override
  _MainProgressScreenState createState() => _MainProgressScreenState();
}

class _MainProgressScreenState extends State<MainProgressScreen> {
  final List<Color> _colorPal = [
    Color.fromRGBO(222, 222, 222, 1), //whiteish
    Color.fromRGBO(255, 243, 96, 1), //yellow
    Color.fromRGBO(71, 212, 203, 1),
    Color.fromRGBO(129, 255, 107, 1), //green
    Color.fromRGBO(38, 200, 0, 1), //dark green
    Color.fromRGBO(255, 139, 103, 1), //skin
  ];

  final List<String> _icons = [
    'images/Icons/steps.png',
    'images/Icons/push-ups.png',
    'images/Icons/Cycling.png',
    'images/Icons/Sit-Ups.png',
    'images/Icons/pull-ups.png',
    'images/Icons/Jogging.png',
  ];

  @override
  Widget build(BuildContext context) {
    final DatabaseManagement _db = new DatabaseManagement(widget._user);
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final List<Widget> _screens = [
      WalkingScreen(widget._user),
      PushUpsScreen(
        user: widget._user,
        icon: _icons[1],
        accentColor: _colorPal[1],
        appBarTitile: 'Push-Ups Progress',
      ),
      CyclingScreen(widget._user),
      SitUpsScreen(widget._user),
      PullUpsScreen(widget._user),
      JoggingScreen(widget._user)
    ];

    Future<Map<String, dynamic>> _future = _db.retrieveExerciseInfoByUid();
    List<Widget> children = new List();

    //TODO: make everything tidy
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
              children.add(
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.7,
                      child: Container(
                        width: _width,
                        height: _height * 0.269,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('images/stairs.jpg'), fit: BoxFit.fill),
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
                            fontWeight: FontWeight.w200
                        ),
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
                            fontWeight: FontWeight.w200
                        ),
                      ),
                    ),
                  ],
                )
              );
              for (var i = 0; i < exerciseLen; ++i) {
                children.add(Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _screens[i])),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                percent: 0.69,
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
              children.add(
                  GestureDetector(
                    onTap: () {},
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
                                    fontWeight: FontWeight.w200
                                ),
                              )),
                        ),
                      ),
                    ),
                  )
              );
            } else if (snapshot.hasError) {
              children = <Widget>[Text('There was a problem with connection, '
                  'please try again')];
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
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
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
