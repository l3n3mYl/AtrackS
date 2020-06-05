import 'dart:async';
import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/PopUps/information_popup.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WalkingScreen extends StatefulWidget {
  final FirebaseUser user;

  WalkingScreen(this.user);

  @override
  _WalkingScreenState createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen> {
  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  DatabaseManagement _management;
  List<FlSpot> weeklyStepList = new List<FlSpot>();
  List<FlSpot> monthlyStepList = new List<FlSpot>();
  String stepCountVal = '0';
  String stepGoal = '0';
  String totalSteps = '0';
  int resetValue = 0;
  bool reset = true;

  @override
  void initState() {
    super.initState();
    getWeeklyStepProgress();
    getMonthlyStepProgress();
    initPlatformState();
    getTotalSteps();
    getStepGoal();
  }

  void getWeeklyStepProgress() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('exercise_weekly_progress', 'Steps')
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        for (var i = 0; i < resList.length; ++i) {
          if (double.parse(resList[i]) / 1000 > 11)
            weeklyStepList.add(FlSpot(i.toDouble() + 0.05, 11));
          else
            weeklyStepList.add(
                FlSpot(i.toDouble() + 0.05, double.parse(resList[i]) / 1000));
          if (i == resList.length - 1)
            if(double.parse(resList[i]) / 1000 > 11)
              weeklyStepList.add(FlSpot(6.95, 11));
            else weeklyStepList.add(FlSpot(6.95, double.parse(resList[i]) / 1000));
        }
      });
    });
  }

  void getMonthlyStepProgress() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('exercise_monthly_progress', 'Steps')
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        monthlyStepList.add(FlSpot(0.1, 2.0));
        for (var i = 0; i < resList.length; ++i) {
          if (double.parse(resList[i]) / 1000 >= double.parse(stepGoal))
            monthlyStepList.add(FlSpot(((i.toDouble() + 1) * 2 - 1 + 0.05), double.parse(stepGoal)));
          else
            monthlyStepList.add(
                FlSpot(((i.toDouble() + 1) * 2 - 1 + 0.05), double.parse(resList[i]) / 1000));
          if (i == resList.length - 1) if (double.parse(resList[i]) / 1000 > double.parse(stepGoal))
            monthlyStepList.add(FlSpot(9.95, double.parse(stepGoal)));
          else
            monthlyStepList.add(FlSpot(9.95, double.parse(resList[i]) / 1000));
        }
      });
    });
  }

  void initPlatformState() async {
    startListening();
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void _onData(int newValue) async {
    if (reset) {
      resetValue += newValue;
      reset = false;
    }
    setState(() {
      stepCountVal = "${newValue - resetValue}";
      _updateDB();
    });
  }

  void _onDone() async {
    reset = true;
  }

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

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Steps Progress',
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
                      progressColor: Color.fromRGBO(222, 222, 222, 1),
                      lineWidth: 3.0,
                      animationDuration: 20,
                      percent: stepGoal == null && totalSteps == null
                          ? 0.01
                          : double.parse(totalSteps) >= double.parse(stepGoal)
                              ? 1.0
                              : (double.parse(totalSteps) *
                                      100 /
                                      double.parse(stepGoal)) /
                                  100,
                      animation: true,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/Icons/steps.png',
                            width: 150,
                            height: 150,
                            color: Colors.white54,
                          ),
                          Text(stepGoal == null && totalSteps == null
                              ? '0 - 0%'
                              : '$totalSteps - ${((int.parse(totalSteps) * 100 / int.parse(stepGoal))).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Colors.white54
                              ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.0,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Center(
                    child: Text('Keep Up The Good Work!', style: TextStyle(color: Colors.white54),),
                  ),
                  SizedBox(
                    height: 1.0,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    child: LineChartSample2(
                      weeklyStepList.isEmpty
                          ? [
                              FlSpot(0.0, 0.0),
                              FlSpot(2.0, 0.0),
                              FlSpot(5.0, 0.0)
                            ]
                          : weeklyStepList,
                      monthlyStepList.isEmpty
                          ? [
                              FlSpot(0.0, 0.0),
                              FlSpot(5.0, 0.0),
                              FlSpot(6.9, 0.0)
                            ]
                          : monthlyStepList,
                      double.parse(stepGoal)
                    ),
                  )
                ],
              )),
          PopupScreen(
            title: 'Steps Tracking Information',
            text:
                'In this screen your steps will be monitored automatically.\n\n'
                'Circular Progress indicator at the top indicates todays steps. '
                'It fills in with every step untill the goal is reached.\n\n'
                'The bottom graph shows weekly/monthly average progress for steps. '
                'Press the "Monthly/Weekly" button, at the top of the graph '
                'to switch between modes. \n\n At the bottom of the weekly '
                    ' graph, letters represents the name of the day.\n\n'
                    'At the bottom of the monthly graph numbers represents the '
                    'months.',
            btnText: 'Continue',
          ),
        ],
      ),
    );
  }
}

class LineChartSample2 extends StatefulWidget {
  LineChartSample2(this._weeklyChart, this._monthlyChart, this.setGoal);

  final List<FlSpot> _weeklyChart;
  final List<FlSpot> _monthlyChart;
  final double setGoal;

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> weeklyDiag = widget._weeklyChart;
    final List<FlSpot> monthlyDiag = widget._monthlyChart;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              showAvg = !showAvg;
            });
          },
          child: Container(
            width: 120,
            height: 25,
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
                    'Monthly/Weekly',
                    style: TextStyle(
                        color: Color.fromRGBO(155, 144, 130, 1),
                        fontFamily: 'PTSerif',
                        fontSize: 10,
                        fontWeight: FontWeight.w200),
                  )),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                showAvg ? avgData(monthlyDiag) : mainData(weeklyDiag),
              ),
            ),
          ),
        ),
//        SizedBox(
//          width: 60,
//          height: 34,
//          child: FlatButton(
//            onPressed: () {
//              setState(() {
//                showAvg = !showAvg;
//              });
//            },
//            child: Text(
//              'avg',
//              style: TextStyle(
//                  fontSize: 12,
//                  color:
//                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
//            ),
//          ),
//        ),
      ],
    );
  }

  LineChartData mainData(List<FlSpot> firstList) {
    final List<Color> gradientColors = [
      Colors.grey,
      Colors.white,
      Colors.white,
      Colors.grey,
    ];
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black, //horizontal lines
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.1).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.1).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.3).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.3).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.5).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.5).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.75).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.75).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000).toInt())
              return '${(widget.setGoal ~/ 1000).toInt()}';
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.black, width: 1)),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: widget.setGoal ~/ 1000 + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: firstList,
          preventCurveOverShooting: true,
          isCurved: true,
          colors:
              gradientColors.map((color) => color.withOpacity(0.9)).toList(),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.4)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData(List<FlSpot> monthlyDiag) {
    final List<Color> gradientColors = [
      Colors.white,
      Colors.grey,
      Colors.grey,
      Colors.white,
    ];
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                if (DateTime.now().month - 4 < 1) {
                  int temp = DateTime.now().month - 4;
                  return '${12 + temp}';
                } else
                  return '${DateTime.now().month - 4}';
                break;
              case 3:
                if (DateTime.now().month - 3 < 1) {
                  int temp = DateTime.now().month - 3;
                  return '${12 + temp}';
                } else
                  return '${DateTime.now().month - 3}';
                break;
              case 5:
                if (DateTime.now().month - 2 < 1) {
                  int temp = DateTime.now().month - 2;
                  return '${12 + temp}';
                } else
                  return '${DateTime.now().month - 2}';
                break;
              case 7:
                if (DateTime.now().month - 1 < 1) {
                  int temp = DateTime.now().month - 1;
                  return '${12 + temp}';
                } else
                  return '${DateTime.now().month - 1}';
                break;
              case 9:
                return '${DateTime.now().month}';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.1).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.1).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.3).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.3).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.5).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.5).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000 * 0.75).toInt())
              return '${(widget.setGoal ~/ 1000 * 0.75).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ 1000).toInt())
              return '${(widget.setGoal ~/ 1000).toInt()}';
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true, border: Border.all(color: Colors.black, width: 1)),
      minX: 0,
      maxX: 10,
      minY: 0,
      maxY: widget.setGoal ~/ 1000 + 1.0,
      lineBarsData: [
        LineChartBarData(
          preventCurveOverShooting: true,
          spots: monthlyDiag,
          isCurved: true,
          colors: gradientColors.map((color) => color.withOpacity(0.9)).toList(),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
              show: true,
              colors: gradientColors.map((color) => color.withOpacity(0.4)).toList(),
          ),
        ),
      ],
    );
  }
}
