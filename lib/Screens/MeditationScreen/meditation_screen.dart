import 'dart:async';

import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/UiComponents/swipe_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MeditationScreenRootClass {
  final FirebaseUser user;

  MeditationScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Meditation', contentBuilder: (_) => MeditationScreen(user));
  }
}

class MeditationScreen extends StatefulWidget {
  final FirebaseUser _user;

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
      var sec = result.split(':')[1];
      var min = result.split(':')[0];
      var cMin = current.split(':')[0];
      var cSec = current.split(':')[1];
      String finalSec = (int.parse(sec) + int.parse(cSec)).toString();
      String finalMin = (int.parse(min) + int.parse(cMin)).toString();
      if(int.parse(finalSec) < 10){
        finalSec = '0$finalSec';
      } else if(int.parse(finalSec) > 59) {
        finalMin = (int.parse(finalMin) + int.parse(finalSec) ~/ 60).toString();
        finalSec = (int.parse(finalSec) % 60).toString();
        if(int.parse(finalSec) < 10)
          finalSec = '0$finalSec';
      }
      if(int.parse(finalMin) < 10)
        finalMin = '0$finalMin';
      await _management.updateSingleField('meditation', 'Current', '$finalMin:$finalSec');
      setState(() {
        current = '$finalMin:$finalSec';
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
                                                    color: Color.fromRGBO(169, 1, 1, 1),
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

class StopWatch extends StatefulWidget {
  final String goal;

  StopWatch(this.goal);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  bool startBtn = true;
  bool isStart = true;
  bool isStop = true;
  bool isReset = true;
  double percent = 0.0;
  String btnName = 'Start';
  String time = '00:00';
  var swatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void getGoal() {
    var goalMin = int.parse(widget.goal.split(':')[0]);
    var goalSec = int.parse(widget.goal.split(':')[1]);
    var finalGoalTime = (goalMin*60) + goalSec;

    var currMin = int.parse(this.time.split(':')[0]);
    var currSec = int.parse(this.time.split(':')[1]);
    var finalCurrTime = currMin * 60 + currSec;
    setState(() {
      if(finalCurrTime == 0.0)
        percent = 0.0;
      else {
        percent = (finalCurrTime * 100 / finalGoalTime) / 100;
        if(percent > 1.0)
          percent = 1.0;
      }
    });
  }

  void startTimer() {
    Timer(duration, running);
  }

  void running() {
    if (swatch.isRunning) {
      startTimer();
      getGoal();
    }
    setState(() {
      time = (swatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
          ':' +
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
      if (time == '59:59') stop();
    });
  }

  void start() {
    setState(() {
      isStop = false;
      isStart = false;
    });
    swatch.start();
    startTimer();
  }

  void stop() async {
    setState(() {
      isStop = true;
      isReset = false;
    });
    swatch.stop();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context, time);
    });
  }

  void reset() {
    setState(() {
      isStart = true;
      isReset = true;
    });
    swatch.reset();
    time = '00:00';
  }

  @override
  void initState() {
    super.initState();
    getGoal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black,
            accentColor,
            accentColor,
            Colors.black,
            Colors.black,
            Colors.black,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                alignment: Alignment.center,
                child: CircularPercentIndicator(
                  radius: 300.0,
                  progressColor: Colors.orange,
                  backgroundColor: Colors.white,
                  percent:
                      percent <= 0.0 ? 0.0 : percent >= 1.0 ? 1.0 : percent,
                  center: Text(
                    time,
                    style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: reset,
                          color: Colors.teal,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 15.0,
                          ),
                          child: Text(
                            'Reset',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: () {
                        if(startBtn){
                          setState(() {
                            btnName = 'Stop';
                            startBtn = false;
                            start();
                          });
                        } else {
                          setState(() {
                            btnName = 'Start';
                            stop();
                          });
                        }
                      },
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: 80.0,
                        vertical: 20.0,
                      ),
                      child: Text(
                        btnName,
                        style: TextStyle(fontSize: 24.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
