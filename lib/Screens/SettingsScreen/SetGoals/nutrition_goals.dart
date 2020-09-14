import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/input_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NutritionGoalSet extends StatefulWidget {

  final User _user;

  NutritionGoalSet(this._user);

  @override
  _NutritionGoalSetState createState() => _NutritionGoalSetState();
}

class _NutritionGoalSetState extends State<NutritionGoalSet> {

  Map<String, String> _nutritionSettings = {
    'Calories': null,
    'Carbs': null,
    'Fats': null,
    'Protein': null,
    'Water': null
  };

  String _error;

  final Color _textColor = Colors.white;

  final _formKey = GlobalKey<FormState>();
  final _input = new InputManipulation();
  
  @override
  void initState() {
    super.initState();
    getInitValues();
  }
  
  void getInitValues() async {
    
    DatabaseManagement _management = DatabaseManagement(widget._user);
    
    _nutritionSettings.forEach((key, value) async {
      await _management.getSingleFieldInfo('nutrition_goals', '${key}_Goals').then((newValue) {
        setState(() {
          _nutritionSettings[key] = newValue;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Categories',
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
      body: Container(
        color: mainColor,
        child: Stack(
          children: [
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                child: Text(
                                  'Daily Calories:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 69.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'This Field Is Required';
                                    else if(!_input.isNumeric(minField)) return 'Wrong Format';
                                    else return null;
                                  },
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: _nutritionSettings['Calories'] == null ? '' : _nutritionSettings['Calories'],
                                      hintStyle: TextStyle(color: _textColor,
                                          fontFamily: 'PTSerif',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      border: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0))),
                                  onChanged: (calField){
                                    setState(() {
                                      _nutritionSettings['Calories'] = calField;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'kcal',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 13.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                child: Text(
                                  'Daily Carbs:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 69.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'This Field Is Required';
                                    else if(!_input.isNumeric(minField)) return 'Wrong Format';
                                    else return null;
                                  },
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: _nutritionSettings['Carbs'] == null ? '' : _nutritionSettings['Carbs'],
                                      hintStyle: TextStyle(color: _textColor,
                                          fontFamily: 'PTSerif',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      border: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0))),
                                  onChanged: (carbsField){
                                    setState(() {
                                      _nutritionSettings['Carbs'] = carbsField;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'mg',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.0,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                child: Text(
                                  'Daily Fats:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 69.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'This Field Is Required';
                                    else if(!_input.isNumeric(minField)) return 'Wrong Format';
                                    else return null;
                                  },
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: _nutritionSettings['Fats'] == null ? '' : _nutritionSettings['Fats'],
                                      hintStyle: TextStyle(color: _textColor,
                                          fontFamily: 'PTSerif',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      border: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0))),
                                  onChanged: (fatsField){
                                    setState(() {
                                      _nutritionSettings['Fats'] = fatsField;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'mg',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Daily Protein:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 69.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'This Field Is Required';
                                    else if(!_input.isNumeric(minField)) return 'Wrong Format';
                                    else return null;
                                  },
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: _nutritionSettings['Fats'] == null ? '' : _nutritionSettings['Fats'],
                                      hintStyle: TextStyle(color: _textColor,
                                          fontFamily: 'PTSerif',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      border: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0))),
                                  onChanged: (proteinField){
                                    setState(() {
                                      _nutritionSettings['Protein'] = proteinField;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'mg',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.0),
                                child: Text(
                                  'Daily Water:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 69.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'This Field Is Required';
                                    else if(!_input.isNumeric(minField)) return 'Wrong Format';
                                    else return null;
                                  },
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: _nutritionSettings['Water'] == null ? '' : _nutritionSettings['Water'],
                                      hintStyle: TextStyle(color: _textColor,
                                          fontFamily: 'PTSerif',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0)),
                                      border: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: accentColor, width: 2.0))),
                                  onChanged: (waterField){
                                    setState(() {
                                      _nutritionSettings['Water'] = waterField;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'ml',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25.0,),
                          Center(
                            child: Text(
                              _error == null ? '' : _error,
                              style: TextStyle(
                                  fontFamily: 'PTSerif',
                                  color: Colors.red
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.13),
                          GestureDetector(
                            onTap: () async {
                              if(_formKey.currentState.validate()) {
                                await DatabaseManagement(widget._user)
                                    .updateGoals(_nutritionSettings, 'nutrition_goals')
                                    .then((value) => Navigator.of(context).pop())
                                    .catchError((error) => _error = error);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25.0),
                              child: Container(
                                width: 219,
                                height: 42,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(56.0),
                                    color: textColor),
                                child: Container(
                                  margin: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(56.0),
                                      color: Colors.black),
                                  child: Center(
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            color: textColor,
                                            fontFamily: 'PTSerif',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w200
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
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
