import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/PopUps/progress_indicator.dart';
import 'package:com/Screens/NutritionScreen/image_recognition.dart';
import 'package:com/Screens/NutritionScreen/individual_nutrition_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/UiComponents/nutrition_card_rect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MainNutritionScreenRootClass {
  final User user;

  MainNutritionScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Nutrition Progress',
        contentBuilder: (_) => MainNutritionScreen(user));
  }
}

class MainNutritionScreen extends StatefulWidget {
  final User _user;

  MainNutritionScreen(this._user);

  @override
  _MainNutritionScreenState createState() => _MainNutritionScreenState();
}

class _MainNutritionScreenState extends State<MainNutritionScreen> {
  final List<Color> _colorPal = [
    Color.fromRGBO(189, 253, 255, 1), //blue
    Color.fromRGBO(255, 188, 122, 1), //orange
    Color.fromRGBO(156, 255, 162, 1), //green
    Color.fromRGBO(255, 163, 163, 1), //pink
    Color.fromRGBO(246, 255, 125, 1), //yellow
  ];

  DatabaseManagement _management;
  List<Widget> cardList = new List<Widget>();

  @override
  void initState() {
    super.initState();
    getNutritionInfo();
  }

  void chooseImage(String type) async {
    var image;
    type == 'Camera'
      ? image = await ImagePicker.platform.pickImage(source: ImageSource.camera)
      : image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
        ImageRecognitionScreen(image: image, user: widget._user, barcode: null,)));
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
    List<double> goals = new List<double>();
    List<double> currProgress = new List<double>();
    List<double> percentage = new List<double>();
    for (var i = 0; i < nutritionValue.length; ++i) {
      if (nutritionValue.keys.elementAt(i).toString() != 'LastUpdated') {
        await _management
            .getSingleFieldInfo('nutrition_goals',
                '${nutritionValue.keys.elementAt(i).toString()}_Goals')
            .then((value) {
          goals.add(double.parse(value));
        });
        await _management
            .getSingleFieldInfo(
                'nutrition', nutritionValue.keys.elementAt(i).toString())
            .then((value) {
          currProgress.add(double.parse(value));
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

  Future<void> scanNormal() async {
    String _result;

    try {
      await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE).then((value) => {
        _result = value,
        Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
            ImageRecognitionScreen(barcode: _result,
              user: widget._user,
              image: null,))),
      });
      print(_result);
    } catch (e) {
      print(e.toString());
    }

    if(!mounted) return;
  }

  void addDataCards(Map nutritionInfo, List<double> percentage, List<double> goals,
      List<double> currProgress) {

    final List<Widget> _screens = [
      IndividualNutritionScreen(
        division: 100,
        appBarTitle: 'Water Consumption',
        user: widget._user,
        accentColor: _colorPal[0],
        field: 'Water',
        popupText: 'This screen shows the progress of the water'
            ' you drank during the day. \n\nPress the bottles in order to add '
            'water and press and hold to remove the same amount from today\'s '
            'progress. \n\nWater bottles adds 100ml, 200ml, 500ml and 1l '
            'respectively. \n\nThe graph shows monthly and weekly progress.',
        measure: 'ml',
      ),
      IndividualNutritionScreen(
        division: 10,
        appBarTitle: 'Carbs Consumption',
        user: widget._user,
        accentColor: _colorPal[1],
        field: 'Carbs',
        popupText: 'This screen shows the progress of the carbohydrates'
            ' consumed today. Weekly and monthly progress can be seen in the '
            'graph.',
        measure: 'mg',
      ),
      IndividualNutritionScreen(
        division: 1,
        appBarTitle: 'Fats Consumption',
        user: widget._user,
        accentColor: _colorPal[2],
        field: 'Fats',
        popupText: 'This screen shows the progress of the fats'
            ' consumed today. Weekly and monthly progress can be seen in the '
            'graph.',
        measure: 'mg',
      ),
      IndividualNutritionScreen(
        division: 1,
        appBarTitle: 'Protein Consumption',
        user: widget._user,
        accentColor: _colorPal[3],
        field: 'Protein',
        popupText: 'This screen shows the progress of the protein'
            ' consumed today. Weekly and monthly progress can be seen in the '
            'graph.',
        measure: 'mg',
      ),
      IndividualNutritionScreen(
        division: 100,
        appBarTitle: 'Calorie Consumption',
        user: widget._user,
        accentColor: _colorPal[4],
        field: 'Calories',
        popupText: 'This screen shows the progress of the calories'
            ' consumed today. Weekly and monthly progress can be seen in the '
            'graph.',
        measure: 'kcal',
      ),

    ];

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Map<String, dynamic> newMap = nutritionInfo;
    newMap.remove('LastUpdated');
    if (nutritionInfo != null) {
      cardList.add(
        Stack(
          children: [
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
      );

      for (var i = 0; i < newMap.length; ++i) {
        cardList.add(GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _screens[i])),
          child: Padding(
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
                                currProgress[i] >= goals[i]
                                    ? '${goals[i]}'
                                    : '${currProgress[i]}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PTSerif',
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                nutritionInfo.keys.elementAt(i) == 'Water'
                                    ? 'ml'
                                    : nutritionInfo.keys.elementAt(i) == 'Calories'
                                      ? 'kcal'
                                      : 'g',
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
                                nutritionInfo.keys.elementAt(i) == 'Water'
                                    ? 'ml'
                                    : nutritionInfo.keys.elementAt(i) == 'Calories'
                                      ? 'kcal'
                                      : 'g',
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
          ),
        ));
      }
      cardList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => chooseImage('Camera'),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56.0), color: textColor),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56.0),
                        color: Colors.black,
                      ),
                      child: Icon(FontAwesomeIcons.cameraRetro,
                        size: 36.0,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30.0,),
                GestureDetector(
                  onTap: () => chooseImage('Gallery'),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56.0), color: textColor),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56.0),
                        color: Colors.black,
                      ),
                      child: Icon(FontAwesomeIcons.image,
                        size: 36.0,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30.0,),
                GestureDetector(
                  onTap: () => scanNormal(),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56.0), color: textColor),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(56.0),
                        color: Colors.black,
                      ),
                      child: Icon(FontAwesomeIcons.barcode,
                        size: 36.0,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: cardList.length == 0
            ? awaitResult('Food Is Important')
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
                  ],
                ),
              )
    );
  }
}




