import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/PopUps/information_popup.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/time_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ExerciseScreen extends StatefulWidget {
  final FirebaseUser user;
  final String appBarTitle;
  final Color accentColor;
  final String icon;
  final String field;
  final String popupText;
  final bool isTimerDisplayed;

  //For percent calculation, 1k will be for exercises with large numbers
  //100 will be for exercises with low number, to represent the graph better
  final int division;

  ExerciseScreen({
      Key key,
      this.user,
      this.accentColor,
      this.icon,
      this.appBarTitle,
      this.field,
      this.popupText,
      this.division,
      this.isTimerDisplayed
      });

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  DatabaseManagement _management;
  TimeManipulation _manipulation = TimeManipulation();

  String exercGoal = '-1';
  String exercTotal = '-1';
  double setGoal = 1.0;
  List<FlSpot> weeklyExercList = new List<FlSpot>();
  List<FlSpot> monthlyExercList = new List<FlSpot>();

  void getSetGoal() async {
    _management = DatabaseManagement(widget.user);
    String data = await _management.getSingleFieldInfo(
        'exercise_goals', '${widget.field}_Goal');

    setState(() {
      if(widget.isTimerDisplayed)
        setGoal = _manipulation.timeToString(data);
      else setGoal = double.parse(data);
    });
  }

  void getWeeklyExercProgress() async {
    _management = DatabaseManagement(widget.user);
    double xAxis = 0.0;
    await _management
        .getSingleFieldInfo('exercise_weekly_progress', widget.field)
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        for (var i = 0; i < resList.length; ++i) {
          if(widget.isTimerDisplayed){
            xAxis = _manipulation.timeToString(resList[i]);
          } else {
            xAxis = double.parse(resList[i]);
          }
          if (xAxis / widget.division >= setGoal)
            weeklyExercList.add(FlSpot(i.toDouble(), setGoal));
          else
            weeklyExercList.add(FlSpot(i.toDouble(),
                xAxis / widget.division));
          if (i == resList.length - 1) if (xAxis /
                  widget.division >=
              setGoal)
            weeklyExercList.add(FlSpot(7, setGoal));
          else
            weeklyExercList
                .add(FlSpot(7, xAxis / widget.division));
        }
      });
    });
  }

  void getMonthlyExercProgress() async {
    _management = DatabaseManagement(widget.user);
    double xAxis = 0.0;
    await _management
        .getSingleFieldInfo('exercise_monthly_progress', widget.field)
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        monthlyExercList.add(FlSpot(0.1, 2.0));
        for (var i = 0; i < resList.length; ++i) {
          if(widget.isTimerDisplayed){
            xAxis = _manipulation.timeToString(resList[i]);
          } else {
            xAxis = double.parse(resList[i]);
          }
          if (xAxis / widget.division >= setGoal)
            monthlyExercList.add(FlSpot(((i.toDouble() + 1) * 2 - 1 + 0.05), setGoal));
          else
            monthlyExercList.add(FlSpot(((i.toDouble() + 1) * 2 - 1 + 0.05),
                xAxis / widget.division));
          if (i == resList.length - 1) if (xAxis /
                  widget.division >=
              setGoal)
            monthlyExercList.add(FlSpot(9.95, setGoal));
          else
            monthlyExercList
                .add(FlSpot(9.95, xAxis / widget.division));
        }
      });
    });
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

  @override
  void initState() {
    super.initState();
    getSetGoal();
    delayRun();
  }

  //Delay run in order for graphs to display the correct information
  void delayRun() async {
    await Future.delayed(const Duration(microseconds: 1), () {
      setState(() {
        getWeeklyExercProgress();
        getMonthlyExercProgress();
        getInitExercInfo();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    progressColor: widget.accentColor,
                    lineWidth: 3.0,
                    animationDuration: 20,
                    percent: !widget.isTimerDisplayed
                      ? exercGoal == '-1' && exercTotal == '-1'
                        ? 0.0
                        : double.parse(exercTotal) >= double.parse(exercGoal)
                            ? 1.0
                            : (double.parse(exercTotal) / double.parse(exercGoal))
                      : exercGoal != '-1' && exercTotal != '-1'
                          && widget.isTimerDisplayed
                        ? double.parse('${exercTotal.split(':')[0]}.${exercTotal.split(':')[1]}') >=
                                double.parse('${exercGoal.split(':')[0]}.${exercGoal.split(':')[1]}')
                          ? 1.0
                          : (double.parse('${exercTotal.split(':')[0]}.${exercTotal.split(':')[1]}') /
                                double.parse('${exercGoal.split(':')[0]}.${exercGoal.split(':')[1]}'))
                        : 0.0,
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
                          child: Text(!widget.isTimerDisplayed
                            ? exercGoal == '-1' && exercTotal == '-1'
                                ? '0 - 0%'
                                : '$exercTotal - ${((int.parse(exercTotal) * 100 / int.parse(exercGoal))).toStringAsFixed(0)}%'
                            : widget.isTimerDisplayed && exercGoal != '-1' && exercTotal != '-1'
                              ? '$exercTotal min' : '',
                            style: TextStyle(color: Colors.white, fontFamily: 'SourceSansPro', fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.0,
                  child: Container(
                    color: Colors.white54,
                  ),
                ),
                Center(
                  child: Text(
                    'Keep Up The Good Work!',
                    style: TextStyle(color: widget.accentColor, fontFamily: 'PTSerif'),
                  ),
                ),
                SizedBox(
                  height: 1.0,
                  child: Container(
                    color: Colors.white54,
                  ),
                ),
                Container(
                  child: LineChartSample2(
                      weeklyExercList.isEmpty
                          ? [
                              FlSpot(0.0, 0.0),
                              FlSpot(2.0, 0.0),
                              FlSpot(5.0, 0.0)
                            ]
                          : weeklyExercList,
                      monthlyExercList.isEmpty
                          ? [
                              FlSpot(0.0, 0.0),
                              FlSpot(5.0, 0.0),
                              FlSpot(6.9, 0.0)
                            ]
                          : monthlyExercList,
                      widget.accentColor,
                      setGoal != 1.0 ? setGoal : 1.0),
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

class LineChartSample2 extends StatefulWidget {
  LineChartSample2(
      this._weeklyChart, this._monthlyChart, this._color, this.setGoal);

  final List<FlSpot> _weeklyChart;
  final List<FlSpot> _monthlyChart;
  final Color _color;
  final double setGoal;

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  bool showAvg = false;

  @override
  void initState() {
    super.initState();
  }

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
                  right: 18.0, left: 12.0, top: 10, bottom: 12),
              child: LineChart(
                showAvg
                    ? monthlyData(monthlyDiag, widget._color)
                    : weeklyData(weeklyDiag, widget._color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData weeklyData(List<FlSpot> firstList, Color color) {
    int temp = 0;
    final List<Color> gradientColors = [
      color,
      color
          .withRed(color.red + -50)
          .withBlue(color.blue + -50)
          .withGreen(color.green + -50),
      color
          .withRed(color.red + -50)
          .withBlue(color.blue + -50)
          .withGreen(color.green + -50),
      color,
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
              color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'PTSerif'),
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
            fontFamily: 'SourceSansPro'
          ),
          getTitles: (value) {
            if(temp == 3){
              temp = 0;
              return '${value.toInt()}';
            } else {
              temp ++;
              return '';
            }
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
      maxY: widget.setGoal + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: firstList,
          isCurved: true,
          preventCurveOverShooting: true,
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

  LineChartData monthlyData(List<FlSpot> monthlyDiag, Color color) {
    int temp = 0;
    final List<Color> gradientColors = [
      color
          .withRed(color.red + -50)
          .withBlue(color.blue + -50)
          .withGreen(color.green + -50),
      color,
      color,
      color
          .withRed(color.red + -50)
          .withBlue(color.blue + -50)
          .withGreen(color.green + -50),
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
              color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 16),
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
            if(temp == 3){
              temp = 0;
              return '${value.toInt()}';
            } else {
              temp++;
              return '';
            }
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
      maxY: widget.setGoal + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: monthlyDiag,
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
}
