import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/PopUps/information_popup.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class IndividualNutritionScreen extends StatefulWidget {
  final User user;
  final String appBarTitle;
  final Color accentColor;
  final String field;
  final String popupText;
  final int division;
  final String measure;

  IndividualNutritionScreen({
    this.user,
    this.measure,
    this.accentColor,
    this.appBarTitle,
    this.field,
    this.popupText,
    this.division,
  });

  @override
  _IndividualNutritionScreenState createState() =>
      _IndividualNutritionScreenState();
}

class _IndividualNutritionScreenState extends State<IndividualNutritionScreen> {
  DatabaseManagement _management;

  String nutritionGoal = '-1';
  String nutritionTotal = '-1';
  double setGoal = 1.0;
  List<FlSpot> weeklyNutrProgList = new List<FlSpot>();
  List<FlSpot> monthlyNutrProgList = new List<FlSpot>();
  List<String> factsList = new List<String>(7);

  void getFacts(String field) async {
    _management = DatabaseManagement(widget.user);
    _management
        .retrieveListFromSingleDoc('nutrition_facts', '${field.toLowerCase()}')
        .then((val) {
      setState(() {
        if (val != null) factsList = val;
      });
    });
  }

  Widget factsToWidget(List<String> list) {
    return new Row(
      children: list.map((item) => new Text(item)).toList(),
    );
  }

  void getSetGoal() async {
    _management = DatabaseManagement(widget.user);
    String data = await _management.getSingleFieldInfo(
        'nutrition_goals', '${widget.field}_Goals');

    setState(() {
      setGoal = double.parse(data);
    });
  }

  void getWeeklyNutritionProgress() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('nutrition_weekly_progress', widget.field)
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        for (var i = 0; i < resList.length; ++i) {
          if (double.parse(resList[i]) >= setGoal)
            weeklyNutrProgList
                .add(FlSpot(i.toDouble(), setGoal / widget.division));
          else
            weeklyNutrProgList.add(FlSpot(
                i.toDouble(), double.parse(resList[i]) / widget.division));
          if (i == resList.length - 1) if (double.parse(resList[i]) >= setGoal)
            weeklyNutrProgList.add(FlSpot(7, setGoal / widget.division));
          else
            weeklyNutrProgList
                .add(FlSpot(7, double.parse(resList[i]) / widget.division));
        }
      });
    });
  }

  void getMonthlyNutritionProgress() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('nutrition_monthly_progress', widget.field)
        .then((result) {
      List<String> resList = result.split(", ");
      setState(() {
        monthlyNutrProgList.add(FlSpot(0.1, 2.0));
        for (var i = 0; i < resList.length; ++i) {
          if (double.parse(resList[i]) >= setGoal)
            monthlyNutrProgList.add(FlSpot(((i.toDouble() + 1) * 2 - 1 + 0.05),
                setGoal / widget.division));
          else
            monthlyNutrProgList.add(FlSpot(((i.toDouble() + 1) * 2 - 1 + 0.05),
                double.parse(resList[i]) / widget.division));
          if (i == resList.length - 1) if (double.parse(resList[i]) >= setGoal)
            monthlyNutrProgList.add(FlSpot(9.95, setGoal / widget.division));
          else
            monthlyNutrProgList
                .add(FlSpot(9.95, double.parse(resList[i]) / widget.division));
        }
      });
    });
  }

  void getInitNutrInfo() async {
    _management = DatabaseManagement(widget.user);
    await _management
        .getSingleFieldInfo('nutrition', widget.field)
        .then((value) {
      setState(() {
        nutritionTotal = value;
      });
    });
    await _management
        .getSingleFieldInfo('nutrition_goals', '${widget.field}_Goals')
        .then((value) {
      setState(() {
        nutritionGoal = value;
      });
    });
    if(double.parse(nutritionTotal) >= double.parse(nutritionGoal)){
      nutritionTotal = nutritionGoal;
    }
  }

  void _addWater(String count) async {
    _management = DatabaseManagement(widget.user);
    await _management.getSingleFieldInfo('nutrition', widget.field).then((value) {
      count = (int.parse(value) + int.parse(count)).toString();
      _management.updateSingleField('nutrition', widget.field, count);
    });
    setState(() {
      getInitNutrInfo();
    });
  }

  void _removeWater(String count) async {
    _management = DatabaseManagement(widget.user);
    await _management.getSingleFieldInfo('nutrition', widget.field).then((value) {
      if(int.parse(value) - int.parse(count) >= 0) {
        count = (int.parse(value) - int.parse(count)).toString();
        _management.updateSingleField('nutrition', widget.field, count);
      }
    });
    setState(() {
      getInitNutrInfo();
    });
  }

  @override
  void initState() {
    super.initState();
    getFacts(widget.field);
    getSetGoal();
    delayRun();
  }

  //Delay run in order for graphs to display the correct information
  void delayRun() async {
    await Future.delayed(const Duration(microseconds: 1), () {
      setState(() {
        getWeeklyNutritionProgress();
        getMonthlyNutritionProgress();
        getInitNutrInfo();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 13.0),
                    width: _width * 0.9,
                    height: _height * 0.169,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: _height * 0.0125,
                          left: _width * 0.069,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              nutritionTotal == '-1'
                                  ? Text(
                                      '0',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 45.0,
                                          fontFamily: 'LibreBaskerville'),
                                    )
                                  : Text(
                                      // nutritionTotal,
                                      widget.field == 'Calorie' ? '${int.parse(nutritionTotal)}' : '$nutritionTotal',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30.0,
                                          fontFamily: 'LibreBaskerville'),
                                    ),
                              Text(
                                widget.measure,
                                style: TextStyle(
                                    color: widget.accentColor,
                                    fontSize: 30.0,
                                    fontFamily: 'LibreBaskerville'),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: _height * 0.02,
                          left: _width * 0.46,
                          child: Container(
                            child: Transform.rotate(
                              angle: 0.45,
                              child: SizedBox(
                                width: 2.0,
                                height: 65.0,
                                child: Container(
                                  color: widget.accentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: _height * 0.069,
                          right: _width * 0.169,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              nutritionGoal == '-1'
                                  ? Text(
                                      '0',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 45.0,
                                          fontFamily: 'LibreBaskerville'),
                                    )
                                  : Text(
                                      nutritionGoal,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontFamily: 'LibreBaskerville'),
                                    ),
                              Text(
                                widget.measure,
                                style: TextStyle(
                                    color: widget.accentColor,
                                    fontSize: 20.0,
                                    fontFamily: 'LibreBaskerville'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      width: _width,
                      height: _height * 0.13,
                      child: LinearPercentIndicator(
                        alignment: MainAxisAlignment.center,
                        percent: setGoal == 1.0 && nutritionTotal == '-1'
                            ? 0.1
                            : (double.parse(nutritionTotal) / setGoal).abs() >= 1.0 ? 1.0 : (double.parse(nutritionTotal) / setGoal).abs(),
                        center: setGoal == 1.0 && nutritionTotal == '-1'
                            ? Text('0%')
                            : Text(
                                '${(double.parse(nutritionTotal) / setGoal * 100).toStringAsFixed(0)}%'),
                        width: _width * 0.69,
                        lineHeight: 25.0,
                        progressColor: widget.accentColor,
                        backgroundColor: Colors.white,
                      )),
                  Container(
                    child: LineChartSample2(
                        weeklyNutrProgList.isEmpty
                            ? [
                                FlSpot(0.0, 0.0),
                                FlSpot(2.0, 0.0),
                                FlSpot(5.0, 0.0)
                              ]
                            : weeklyNutrProgList,
                        monthlyNutrProgList.isEmpty
                            ? [
                                FlSpot(0.0, 0.0),
                                FlSpot(5.0, 0.0),
                                FlSpot(6.9, 0.0)
                              ]
                            : monthlyNutrProgList,
                        widget.accentColor,
                        setGoal,
                        widget.division),
                  ),
                  widget.field == 'Water'
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _addWater('100');
                          },
                          onLongPress: () {
                            _removeWater('100');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('images/Water/100ml.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _addWater('200');
                          },
                          onLongPress: () {
                            _removeWater('200');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('images/Water/200ml.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _addWater('500');
                          },
                          onLongPress: () {
                            _removeWater('500');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('images/Water/500ml.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _addWater('1000');
                          },
                          onLongPress: () {
                            _removeWater('1000');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Image.asset('images/Water/1kml.png'),
                          ),
                        ),
                      ],
                    )
                  : Container(),
                  SizedBox(height: 13.0,),
                  SizedBox(
                    height: 1.0,
                    child: Container(
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Fact about ${widget.field}',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PTSerif',
                          fontSize: 24.0),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                                  Text(
                                    factsList == [] ? '' : '⦿ ${factsList[DateTime.now().weekday - 1]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'PTSerif',
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 13.0,
                                  )
                                ],
                    ),
                  ),
                ],
              ),
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
  LineChartSample2(this._weeklyChart, this._monthlyChart, this._color,
      this.setGoal, this.division);

  final List<FlSpot> _weeklyChart;
  final List<FlSpot> _monthlyChart;
  final Color _color;
  final double setGoal;
  final int division;

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
        Padding(
          padding: const EdgeInsets.only(bottom: 38.0),
          child: GestureDetector(
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
        ),
      ],
    );
  }

  LineChartData weeklyData(List<FlSpot> firstList, Color color) {
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
              color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 16),
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
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.1).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.1).toInt()}';
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.25).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.25).toInt()}';
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.5).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.5).toInt()}';
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.75).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.75).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ widget.division).toInt())
              return '${(widget.setGoal ~/ widget.division).toInt()}';
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
      maxY: widget.setGoal ~/ widget.division + 1.0,
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
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.1).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.1).toInt()}';
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.25).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.25).toInt()}';
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.5).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.5).toInt()}';
            if (value.toInt() ==
                (widget.setGoal ~/ widget.division * 0.75).toInt())
              return '${(widget.setGoal ~/ widget.division * 0.75).toInt()}';
            if (value.toInt() == (widget.setGoal ~/ widget.division).toInt())
              return '${(widget.setGoal ~/ widget.division).toInt()}';
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
      maxY: widget.setGoal ~/ widget.division + 1.0,
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
