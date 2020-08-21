import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/Screens/MeditationScreen/stop_watch_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/UiComponents/swipe_button.dart';
import 'package:com/Utilities/time_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MeditationScreenRootClass {
  final User user;

  MeditationScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Meditation', contentBuilder: (_) => MeditationScreen(user));
  }
}

class MeditationScreen extends StatefulWidget {
  final User _user;

  MeditationScreen(this._user);

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  String current, goal = '';
  List<String> weekly = List<String>();
  static final List<String> weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  void getUserInfo() async {
    DatabaseManagement _management = DatabaseManagement(widget._user);
    await _management.getSingleFieldInfo('meditation', 'Current').then((value) {
      setState(() {
        current = value;
      });
    });
    await _management.getSingleFieldInfo('meditation', 'Goal').then((value) {
      setState(() {
        goal = value;
      });
    });
    await _management
        .getSingleFieldInfo('meditation', 'WeeklyStatus')
        .then((value) {
      setState(() {
        weekly = value.split(", ");
      });
    });
  }

  void screenWithReturnValue(BuildContext context) async {
    DatabaseManagement _management = DatabaseManagement(widget._user);
    final String result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => StopWatch(goal)));

    if (result != null) {

      String time = TimeManipulation().timeAddition(result, current);

      //Update Database
      await _management.updateSingleField(
          'meditation', 'Current', time);
      await _management.updateMeditationWeeklyTime(
          DateTime.now().weekday, time);

      setState(() {
        current = time;
        getUserInfo();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
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
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: _width * 0.8,
                    height: _height * 0.35,
                    padding: EdgeInsets.all(4.0),
                    child: Image.asset(
                      'images/meditation.png',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, top: 9.0),
                    child: SwipeButton(
                      onChanged: (_) {
                        screenWithReturnValue(context);
                      },
                      height: 50.0,
                      width: 240.0,
                      content: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                          'Swipe To Begin',
                          style: TextStyle(
                              color: textColor,
                              fontFamily: 'PTSerif',
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      borderColor: textColor,
                      borderRadius: BorderRadius.circular(56.0),
                      thumb: Container(
                        child: Center(
                          child: Image.asset(
                            'images/basic-logo.png',
                            color: Color.fromRGBO(169, 1, 1, 1),
                          ),
                        ),
                      ),
                      sliderBaseColor: Colors.black,
                      sliderButtonColor: Colors.grey.shade300,
                    ),
                  ),
                  Container(
                    height: 69.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 2.0,
                          width: _width,
                          color: textColor,
                        ),
                        Text(
                          current == '' ? '' : '$current min',
                          style: TextStyle(
                              color: Colors.grey.shade300, fontSize: 38.0),
                        ),
                        Container(
                          height: 2.0,
                          width: _width,
                          color: textColor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                    child: Text(
                      goal == '' ? '' : 'Goal: $goal min',
                      style: TextStyle(
                          color: Colors.grey.shade300, fontSize: 28.0),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      width: _width,
                      height: 150.0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              weekly.length,
                              (i) => weekly != [] && goal != null
                                  ? double.parse(
                                              '${weekly[i].split(':')[0]}.${weekly[i].split(':')[1]}') >=
                                          double.parse(
                                              '${goal.split(':')[0]}.${goal.split(':')[1]}')
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                width: 30.0,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            56.0)),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                  width: 45.0,
                                                  height: 45.0,
                                                  child: Image.asset(
                                                    'images/basic-logo.png',
                                                    color: Color.fromRGBO(
                                                        169, 1, 1, 1),
                                                  )),
                                            )
                                          ],
                                        )
                                      : Text(
                                          '${weekdays[i]}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.0),
                                        )
                                  : Text('')).toList())),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}