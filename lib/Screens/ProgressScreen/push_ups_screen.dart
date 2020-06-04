import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/PopUps/information_popup.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PushUpsScreen extends StatefulWidget {
  final FirebaseUser user;
  final String appBarTitile;
  final Color accentColor;
  final String icon;
  final String field;
  final String popupText;
  //For percent calculation, 1k will be for exercises with large numbers
  //100 will be for exercises with low number, to represent the graph better
  final int division;

  PushUpsScreen(
      {this.user, this.accentColor, this.icon, this.appBarTitile, this.field, this.popupText, this.division});

  @override
  _PushUpsScreenState createState() => _PushUpsScreenState();
}

class _PushUpsScreenState extends State<PushUpsScreen> {

  DatabaseManagement _management;

  String exercGoal = '-1';
  String exercTotal = '-1';
  double setGoal = 1.0;
  List<FlSpot> weeklyExercList = new List<FlSpot>();
  List<FlSpot> monthlyExercList = new List<FlSpot>();
  
  void getSetGoal() async {
    _management = DatabaseManagement(widget.user);
    String data = await _management.getSingleFieldInfo('exercise_goals', '${widget.field}_Goal');

    setState(() {
      setGoal = double.parse(data);
    });
  }

  void getWeeklyExercProgress() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('exercise_weekly_progress', widget.field)
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        for (var i = 0; i < resList.length; ++i) {
          if (double.parse(resList[i]) / widget.division >= setGoal)
            weeklyExercList.add(FlSpot(i.toDouble() + 0.05, setGoal));
          else
            weeklyExercList.add(
                FlSpot(i.toDouble() + 0.05, double.parse(resList[i]) / widget.division));
          if (i == resList.length - 1)
            if(double.parse(resList[i]) / widget.division >= setGoal)
              weeklyExercList.add(FlSpot(6.95, setGoal));
            else weeklyExercList.add(FlSpot(6.95, double.parse(resList[i]) / widget.division));
        }
      });
    });
  }

  void getMonthlyExercProgress() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('exercise_monthly_progress', widget.field)
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        for (var i = 0; i < resList.length; ++i) {
          if (double.parse(resList[i]) / widget.division > setGoal - 1.0)
            monthlyExercList.add(FlSpot(i.toDouble() + 0.05, 10));
          else
            monthlyExercList.add(
                FlSpot(i.toDouble() + 0.05, double.parse(resList[i]) / widget.division));
          if (i == resList.length - 1) if (double.parse(resList[i]) / widget.division > setGoal - 1.0)
            monthlyExercList.add(FlSpot(9.95, setGoal - 1.0));
          else
            monthlyExercList.add(FlSpot(9.95, double.parse(resList[i]) / widget.division));
        }
      });
    });
  }

  void getInitExercInfo() async {
    _management = DatabaseManagement(widget.user);
    await _management.getSingleFieldInfo('exercises', widget.field).then((
        value) {
      setState(() {
        exercTotal = value;
      });
    });
    await _management.getSingleFieldInfo('exercise_goals', '${widget.field}_Goal').then((
        value) {
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

  void delayRun() async {
    await Future.delayed(const Duration(microseconds: 1), () {
      setState(() {
        getWeeklyExercProgress();
        getMonthlyExercProgress();
        getInitExercInfo();
      });
    }
    );
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
          widget.appBarTitile,
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
                    percent: exercGoal == '-1' && exercTotal == '-1'
                        ? 0.01
                        : double.parse(exercTotal) >= double.parse(exercGoal)
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
                        Text(exercGoal == '-1' && exercGoal == '-1'
                            ? '0 - 0%'
                            : '$exercTotal - ${((int.parse(exercTotal) * 100 /
                            int.parse(exercGoal))).toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: Colors.white54
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.0,
                  child: Container(
                    color: widget.accentColor.withOpacity(0.8),
                  ),
                ),
                Center(
                  child: Text('Keep Up The Good Work!', style: TextStyle(color: widget.accentColor),),
                ),
                SizedBox(
                  height: 1.0,
                  child: Container(
                    color: widget.accentColor.withOpacity(0.8),
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
                    setGoal
                  ),
                )
              ],
            ),
          ),
          PopupScreen(
            title: '${widget.field} Tracking Information',
            text:'${widget.popupText}', //TODO: change
            btnText: 'Continue',
          ),
        ],
      ),
    );
  }
}

class LineChartSample2 extends StatefulWidget {
  LineChartSample2(this._weeklyChart, this._monthlyChart, this._color, this.setGoal);

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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              width: 50,
              height: 40,
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
                          fontSize: 10,
                          fontWeight: FontWeight.w200
                      ),
                    )),
              ),
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
                showAvg ? avgData(monthlyDiag, widget._color) : mainData(weeklyDiag, widget._color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(List<FlSpot> firstList, Color color) {

    final List<Color> gradientColors = [
      color.withRed(color.red - 20)
          .withBlue(color.blue - 20)
          .withGreen(color.green - 20),
      color.withRed(color.red + 20)
          .withBlue(color.blue + 20)
          .withGreen(color.green + 20),
      color.withRed(color.red - 20)
          .withBlue(color.blue - 20)
          .withGreen(color.green - 20),
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
            if(value.toInt() == (widget.setGoal * 0.1).toInt())
              return '${(widget.setGoal * 0.1).toInt()}';
            if(value.toInt() == (widget.setGoal * 0.25).toInt())
              return '${(widget.setGoal * 0.25).toInt()}';
            if(value.toInt() == (widget.setGoal * 0.5).toInt())
              return '${(widget.setGoal * 0.5).toInt()}';
            if(value.toInt() == (widget.setGoal * 0.75).toInt())
              return '${(widget.setGoal * 0.75).toInt()}';
            if(value.toInt() == (widget.setGoal).toInt())
              return '${(widget.setGoal).toInt()}';
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
      maxY: widget.setGoal + 1.0,
      lineBarsData: [
        LineChartBarData(
          spots: firstList,
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

  LineChartData avgData(List<FlSpot> monthlyDiag, Color color) {
    final List<Color> gradientColors = [
      color.withRed(color.red - 20)
          .withBlue(color.blue - 20)
          .withGreen(color.green - 20),
      color.withRed(color.red + 20)
          .withBlue(color.blue + 20)
          .withGreen(color.green + 20),
      color.withRed(color.red - 20)
          .withBlue(color.blue - 20)
          .withGreen(color.green - 20),
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
            switch (value.toInt()) {
              case 1:
                return '1k';
              case 5:
                return '5k';
              case 10:
                return '10k';
            }
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
      maxY: widget.setGoal + 1.0,
      lineBarsData: [
        LineChartBarData(
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
