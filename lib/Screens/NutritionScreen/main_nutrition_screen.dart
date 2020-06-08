import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/UiComponents/nutrition_card_rect.dart';
import 'package:com/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    Color.fromRGBO(189, 253, 255, 1),//blue
    Color.fromRGBO(255, 188, 122, 1), //orange
    Color.fromRGBO(156, 255, 162, 1), //green
    Color.fromRGBO(0, 0, 0, 1), //pre-pre-last!
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
        addDataCards(value);
      });
    });
  }

  void addDataCards(Map nutritionInfo) async {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    if(nutritionInfo != null) {
      for(var i = 0; i < nutritionInfo.length; ++i) {
        if(nutritionInfo.keys.elementAt(i).toString() != 'LastUpdated'){
          cardList.add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 30.0),
              child: Container(
                width: _width,
                height: _height * 0.09,
                color: Colors.black26,
                child: Stack(
                  children: <Widget>[
                    NutritionCardTriangle(_colorPal[i].withOpacity(0.5)),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text(nutritionInfo.keys.elementAt(i), style: TextStyle(
                        color: _colorPal[i],
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold
                      ),),
                    )
                  ],
                ),
              ),
            )
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: cardList == []
          ? CircularProgressIndicator()
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
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Container(
                        child: Text(
                          'EAT WELL',
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400
                          ),
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
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, left: 200.0),
                      child: Container(
                        child: Text(
                          'BE WELL',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      )
    );
  }
}

























































































