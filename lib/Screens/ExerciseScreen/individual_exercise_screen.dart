import 'dart:async';

import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/PopUps/information_popup.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/calorie_calculation.dart';
import 'package:com/Utilities/time_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sensors/sensors.dart';

class IndividualExerciseScreen extends StatefulWidget {
  final FirebaseUser user;
  final String appBarTitle;
  final Color accentColor;
  final String icon;
  final String field;
  final String popupText;
  final bool stepCounter;
  final bool timeCounter;

  IndividualExerciseScreen({
    Key key,
    this.user,
    this.accentColor,
    this.icon,
    this.appBarTitle,
    this.field,
    this.popupText,
    bool stepCounter,
    bool timeCounter,
  })
      : assert(stepCounter == null || timeCounter == null),
        this.stepCounter = stepCounter ?? false,
        this.timeCounter = timeCounter ?? false,
        super(key: key);

  @override
  _IndividualExerciseScreenState createState() =>
      _IndividualExerciseScreenState();
}

class _IndividualExerciseScreenState extends State<IndividualExerciseScreen> {
  DatabaseManagement _management;

  Pedometer _pedometer;
  StreamSubscription<int> _subscription;

  //Accel vals
  List<double> xList = new List<double>();
  List<double> yList = new List<double>();
  List<double> zList = new List<double>();
  List<double> calorieResult = new List<double>();
  double vecCalledTimes = 0.0;
  int currCals = 0;
  int tempSteps = 0;
  List<double> _accelerometerValues;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
        <StreamSubscription<dynamic>>[];

  //Cycling
  var _count = 0;
  var _tapPosition;

  //Aver calc
  String exercGoal = '-1';
  String exercTotal = '-1';

  //Step Counter values
  String stepCountVal = '0';
  String stepGoal = '0';
  String totalSteps = '0';

  //Clicker values
  int timesClicked = 0;
  List<double> timeBetweenExercise = new List<double>();
  double totalCaloriesBurned = 0.0;

  //Timer value
  bool startBtn = true;
  bool isStart = true;
  bool isStop = true;
  bool isReset = true;
  bool pauseBtn = false;
  double percent = 0.0;
  String time = '00:00';
  var swatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  double setGoal = 1.0;
  bool reset = true;
  int resetValue = 0;
  List<FlSpot> weeklyExercList = new List<FlSpot>();
  List<FlSpot> monthlyExercList = new List<FlSpot>();

  void getGoal(String goal) {
    var goalMin = int.parse(goal.split(':')[0]);
    var goalSec = int.parse(goal.split(':')[1]);
    var finalGoalTime = (goalMin * 60) + goalSec;

    var currMin = int.parse(this.time.split(':')[0]);
    var currSec = int.parse(this.time.split(':')[1]);
    var finalCurrTime = currMin * 60 + currSec;
    setState(() {
      if (finalCurrTime <= 0.0)
        percent = 0.0;
      else {
        percent = finalCurrTime / finalGoalTime;
        if (percent >= 1.0) {
          percent = 1.0;
        }
      }
    });
  }

  void startTimer() {
    Timer(duration, running);
  }

  void running() {
    if (swatch.isRunning) {
      startTimer();
    }
    setState(() {
      time = (swatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
          ':' +
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
      if (time == '59:59') pauseFunct();
    });
  }

  void addTimeToDB(String time) async {
    _management = DatabaseManagement(widget.user);
    String oldTime = await _management.getSingleFieldInfo('exercises', widget.field);
     if(oldTime != null) {
       time = TimeManipulation().timeAddition(oldTime, time);
       await _management.updateSingleField('exercises', widget.field, time);
     }
  }

  void startFunct() {
    setState(() {
      isStop = false;
      isStart = false;
    });
    swatch.start();
    startTimer();
  }

  void pauseFunct() async {
    setState(() {
      isStop = true;
      isReset = false;
    });
    swatch.stop();
  }

  void stopFunct() async {
    swatch.stop();
    swatch.reset();
    setState(() {
      isStop = true;
      isReset = false;
    });
    addTimeToDB(time);
    setState(() {
      time = '00:00';
    });
  }

  void resetFunct() {
    setState(() {
      isStart = true;
      isReset = true;
      pauseBtn = false;
    });
    swatch.stop();
    swatch.reset();
    time = '00:00';
  }

  void initTapFunctionality() async {
    _management = DatabaseManagement(widget.user);
    int total = 0;
    timesClicked++;
    await _management.getSingleFieldInfo('exercises', widget.field).then((value){
      total = 1 + int.parse(value);
      _management.updateSingleField(
          'exercises', widget.field, '$total');
    });
  }

  void getSetGoal() async {
    _management = DatabaseManagement(widget.user);
    String data = await _management.getSingleFieldInfo(
        'exercise_goals', '${widget.field}_Goal');

    await _management.getSingleFieldInfo('nutrition', 'Calories').then((result) {
      setState(() {
        this.currCals = int.parse(result);
      });
    });

    setState(() {
      if(widget.timeCounter)
        {
          setGoal = double.parse('${data.split(':')[1]}.${data.split(':')[0]}');
          getGoal(data);
        }
      else {
        getGoal('$data:00');
        setGoal = double.parse(data);
      }
    });
  }

  //Start listening for steps
  void initPlatformState() async {
    if (widget.stepCounter) {
      getTotalSteps();
      getStepGoal();
      startListening();
    }
  }

  //Pedometer Initialization
  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  //Update db, adding new steps to an old val
  void _updateDB() async {
    _management = new DatabaseManagement(widget.user);
    String oldSteps =
    await _management.getSingleFieldInfo('exercises', 'Steps');
    String sumOfValues =
    (int.parse(oldSteps) + int.parse(stepCountVal)).toString();
    await _management.updateSingleField('exercises', 'Steps', sumOfValues);
    setState(() {
      this.totalSteps = sumOfValues;
    });
  }

  //On received data, handle and sort
  void _onData(int newValue) async {
    //Check if need to reset and count from 0
    if (reset) {
      resetValue += newValue;
      reset = false;
    }
    setState(() {
      //Update DB with new values
      stepCountVal = "${newValue - resetValue}";
      _updateDB();
    });
  }

  void getStepGoal() async {
    try {
      _management = new DatabaseManagement(widget.user);
      await _management
          .getSingleFieldInfo('exercise_goals', 'Steps_Goal')
          .then((result) {
        setState(() {
          this.stepGoal = result;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _onError(error) => print('Error: $error');

  //When done listening, reset to count from 0
  void _onDone() async {
    reset = true;
  }

  void getInitExercInfo() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('exercises', widget.field)
        .then((value) {
      setState(() {
        exercTotal = value;
      });
    });
    await _management
        .getSingleFieldInfo('exercise_goals', '${widget.field}_Goal')
        .then((value) {
      setState(() {
        exercGoal = value;
      });
    });
  }

  void getTotalSteps() async {
    try {
      _management = new DatabaseManagement(widget.user);
      await _management.getSingleFieldInfo('exercises', 'Steps').then((result) {
        setState(() {
          this.totalSteps = result;
        });
      });
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getSetGoal();
    initPlatformState();
    delayRun();

    //Accelerometer
    _streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double> [event.x, event.y, event.z];
      });
    }));
  }

  //Delay run in order for graphs to display the correct information
  void delayRun() async {
    await Future.delayed(const Duration(microseconds: 1), () {
      setState(() {
        getInitExercInfo();
      });
    });
  }
  
  void _updateUpsCalories(int totalKcal) async {
    await _management.getSingleFieldInfo('nutrition', 'Calories').then((value) {
      totalKcal += int.parse(value);
      _management.updateSingleField('nutrition', 'Calories',
          totalKcal.toString());
    });
  }

  void _updateCyclingCalories(String time) async {
    CalorieCalculation calculation = CalorieCalculation(widget.user);

    int totalKcal = -1;
    int timeInMins = int.parse(time.split(':')[0]);

    await _management.getSingleFieldInfo('nutrition', 'Calories').then((value) {
      totalKcal = int.parse(value);
    });
      if(timeInMins == 0) {
      } else if (timeInMins > 0){
        dynamic cyCals = await calculation.getCaloriesCycling(int.parse(time.split(':')[0]), _count);
        if(cyCals != null) {
          totalKcal += cyCals.round();
        }
      }
      _management.updateSingleField('nutrition', 'Calories',
          totalKcal.toString());
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.stepCounter) _subscription.cancel();
    else if (!widget.stepCounter && !widget.timeCounter)
      _updateUpsCalories(totalCaloriesBurned.floor());

    //acceler
    for(StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void getKcal(List<double> x, List<double> y, List<double> z) async {

    double res = await CalorieCalculation(widget.user).getCaloriesWalking(xList, yList, zList);
    calorieResult.add(res);
    if(calorieResult.length >= 30){
      var temp = 0.0;
      for(var i in calorieResult){
        temp += i;
      }
      calorieResult.clear();
      temp /= 30;
      if(tempSteps < int.parse(stepCountVal) && temp > 0.0){
        tempSteps = int.parse(stepCountVal);
        setState(() {
          currCals += temp.toInt();
          _management.updateSingleField('nutrition', 'Calories', currCals.toString());
        });
      }
    }
  }

  void showCustomMenu() {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
        context: context,
        items: <PopupMenuEntry<int>>[MetEntry()],
        position: RelativeRect.fromRect(_tapPosition & Size(40, 40), Offset.zero & overlay.size)
    ).then<void>((int delta) {
      if(delta == null) return;
      setState(() {
        _count = delta;
      });
    });
  }

  void selectMET(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.stepCounter){
      final List<double> a = _accelerometerValues?.map(
          (double v) => double.parse(v.toStringAsFixed(1)))?.toList();
      if(a != null) {
        xList.add(a.elementAt(0).abs());
        yList.add(a.elementAt(1).abs());
        zList.add(a.elementAt(2).abs());
        if(vecCalledTimes >= 2){
          getKcal(xList, yList, zList);
          vecCalledTimes = 0;
          xList.clear();
          yList.clear();
          zList.clear();
        }
        vecCalledTimes++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          widget.appBarTitle,
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
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            color: mainColor,
          ),
          BackgroundTriangle(),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
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
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.stepCounter || widget.timeCounter
                    ? Container(
                  margin: EdgeInsets.symmetric(vertical: 13.0),
                  width: 256,
                  height: 256,
                  child: CircularPercentIndicator(
                    backgroundColor: mainColor,
                    radius: 250.0,
                    progressColor: widget.accentColor,
                    lineWidth: 3.0,
                    animationDuration: 20,
                    percent: exercGoal == '-1' && exercTotal == '-1'
                        ? 0.0
                        : widget.timeCounter && exercGoal != '-1' && exercTotal != '-1'
                          ? double.parse('${exercTotal.split(':')[0]}.${exercTotal.split(':')[1]}') >= double.parse('${exercGoal.split(':')[0]}.${exercGoal.split(':')[1]}')
                            ? 1.0
                            : double.parse('${exercTotal.split(':')[0]}.${exercTotal.split(':')[1]}') / double.parse('${exercGoal.split(':')[0]}.${exercGoal.split(':')[1]}')
                          : widget.stepCounter
                            ? double.parse(exercTotal) / double.parse(exercGoal) >= 1.0
                              ? 1.0
                              : double.parse(exercTotal) / double.parse(exercGoal) <= 0.0
                                ? 0.0
                                : double.parse(exercTotal) / double.parse(exercGoal)
                            : 0.5,
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
                        Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: widget.stepCounter
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text('$stepCountVal',
                                      style: TextStyle(
                                        fontFamily: 'SansSourcePro',
                                        color: Colors.white,
                                        fontSize: 26.0
                                      ),),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(' steps',
                                        style: TextStyle(
                                          fontFamily: ' PTSerif',
                                          color: widget.accentColor,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('$time',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 26.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(' min',
                                    style: TextStyle(
                                        color: widget.accentColor,
                                        fontFamily: 'PTSerif'),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () async {
                    if (widget.field == 'Sit-Ups' ||
                        widget.field == 'Push-Ups') {
                      timeBetweenExercise.add(
                        DateTime.now().millisecondsSinceEpoch / 60000
                      );
                      if(timeBetweenExercise.length >= 2){
                        dynamic calories = await CalorieCalculation(widget.user).getCaloriesSitPushUps(timeBetweenExercise);
                        if(calories != null){
                          totalCaloriesBurned += calories;
                        }
                        timeBetweenExercise.clear();
                      }
                    }
                    else if (widget.field == 'Pull-Ups') {
                      totalCaloriesBurned += 1;
                    }
                    setState(() {
                      initTapFunctionality();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 13.0),
                    width: 256,
                    height: 256,
                    child: CircularPercentIndicator(
                      backgroundColor: mainColor,
                      radius: 250.0,
                      progressColor: widget.accentColor,
                      lineWidth: 3.0,
                      animationDuration: 20,
                      percent: exercGoal == '-1' && exercTotal == '-1'
                          ? 0.01
                          : double.parse(exercTotal) >=
                          double.parse(exercGoal)
                          ? 1.0
                          : (double.parse(exercTotal) *
                          100 /
                          double.parse(exercGoal)) /
                          100,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                exercTotal == '-1' ? '' : exercTotal,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'SansSourcePro'
                                ),
                              ),
                              Text(' Total',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'PTSerif'
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('$timesClicked',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'SansSourcePro',
                                  fontSize: 26.0
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(' Current',
                                  style: TextStyle(
                                    color: widget.accentColor,
                                    fontFamily: 'PTSerif'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.0,
                  child: Container(
                    color: Colors.white54,
                  ),
                ),
                GestureDetector(
                  onLongPress: showCustomMenu,
                  onTapDown: selectMET,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Keep Up The Good Work!',
                          style: TextStyle(
                              color: widget.accentColor,
                              fontSize: 20.0,
                              fontFamily: 'PTSerif'
                          ),
                        ),
                        widget.stepCounter
                        ? Padding(
                            padding: EdgeInsets.only(top: 23.0),
                            child: Text(
                                'Steps are monitored automatically here',
                              style: TextStyle(
                                color: Colors.white54,
                                fontFamily: 'PTSerif'
                              ),
                            ),
                        )
                        : SizedBox()
                      ],
                    ),
                  ),
                ),
                widget.timeCounter
                    ? Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        widget.accentColor.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                        widget.accentColor.withOpacity(0.2),
                      ]
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 1.0,
                        child: Container(
                          color: Colors.white54,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                  _updateCyclingCalories(time);
                                  stopFunct();
                                  setState(() {
                                    pauseBtn = false;
                                  });
                                },
                              child: Container(
                                alignment: Alignment.center,
                                width: 69.0,
                                height: 69.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(123.0),
                                    color: textColor
                                ),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    margin: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black,
                                              Colors.black,
                                              Colors.black87,
                                              Colors.black54
                                            ]),
                                        borderRadius:
                                        BorderRadius.circular(123.0)),
                                    child: Icon(
                                      FontAwesomeIcons.stop,
                                      color: Colors.grey.shade300,
                                      size: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: !pauseBtn
                                  ? () {
                                startFunct();
                                pauseBtn = true;
                              }
                                  : () {
                                pauseFunct();
                                pauseBtn = false;
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(123.0),
                                    color: textColor
                                ),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    margin: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black,
                                              Colors.black,
                                              Colors.black87,
                                              Colors.black54
                                            ]),
                                        borderRadius:
                                        BorderRadius.circular(123.0)),
                                    padding: !pauseBtn
                                    ? const EdgeInsets.only(left: 10.0)
                                    : const EdgeInsets.all(0.0),
                                    child: Icon(
                                      !pauseBtn
                                      ? FontAwesomeIcons.play
                                      : FontAwesomeIcons.pause,
                                      color: Colors.grey.shade300,
                                      size: 45.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: resetFunct,
                              child: Container(
                                alignment: Alignment.center,
                                width: 69.0,
                                height: 69.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(123.0),
                                  color: textColor,
                                ),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    margin: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black,
                                              Colors.black,
                                              Colors.black87,
                                              Colors.black54
                                            ]),
                                        borderRadius:
                                        BorderRadius.circular(123.0)),
                                    child: Icon(
                                      CupertinoIcons.refresh_thick,
                                      color: Colors.grey.shade300,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.0,
                        child: Container(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(
                  height: 1.0,
                  color: Colors.white54,
                ),
                Container(
                  padding: EdgeInsets.only(left: 13.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Calories Burnt: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontFamily: 'PTSerif'
                            ),
                          ),
                          Text('$currCals',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontFamily: 'PTSerif'
                            ),),
                          Text(' kcal',
                            style: TextStyle(
                              color: widget.accentColor,
                              fontSize: 24.0,
                              fontFamily: 'PTSerif'
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Set Goal: ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontFamily: 'PTSerif'
                            ),
                          ),
                          Text('$exercGoal',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontFamily: 'PTSerif'
                            ),
                          ),
                          widget.timeCounter
                            ? Text(' min',
                            style: TextStyle(
                                color: widget.accentColor,
                                fontSize: 24.0,
                                fontFamily: 'PTSerif'
                            ),
                          )
                            : Text(' steps',
                            style: TextStyle(
                                color: widget.accentColor,
                                fontSize: 24.0,
                                fontFamily: 'PTSerif'
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          PopupScreen(
            title: '${widget.field} Tracking Information',
            text: '${widget.popupText}',
            btnText: 'Continue',
          ),
        ],
      ),
    );
  }
}

class MetEntry extends PopupMenuEntry<int> {
  @override
  State<StatefulWidget> createState() => MetEntryState();

  @override
  double get height => 100;

  @override
  bool represents(int value) => value == 1 || value == -1;
}

class MetEntryState extends State<MetEntry> {

  void _leisure() {
    Navigator.pop<int>(context, 0);
  }

  void _averLeisure() {
    Navigator.pop<int>(context, 1);
  }

  void _lightEffort() {
    Navigator.pop<int>(context, 2);
  }

  void _moreEffort() {
    Navigator.pop<int>(context, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: FlatButton(onPressed: _leisure, child: Text('10 km/h'),),),
        Expanded(child: FlatButton(onPressed: _averLeisure, child: Text('15 km/h'),),),
        Expanded(child: FlatButton(onPressed: _lightEffort, child: Text('20 km/h'),),),
        Expanded(child: FlatButton(onPressed: _moreEffort, child: Text('25 km/h'),),),
      ],
    );
  }

}
