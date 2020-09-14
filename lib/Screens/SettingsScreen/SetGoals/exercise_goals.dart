import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/input_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExerciseGoalsSet extends StatefulWidget {

  final User _user;

  ExerciseGoalsSet(this._user);

  @override
  _ExerciseGoalsSetState createState() => _ExerciseGoalsSetState();
}

class _ExerciseGoalsSetState extends State<ExerciseGoalsSet> {

  final Color _textColor = Colors.white;
  Map<String, String> _exercSettings = {
    'Cycling_Goal': null,
    'Jogging_Goal': null,
    'Pull-Ups_Goal': null,
    'Push-Ups_Goal': null,
    'Sit-Ups_Goal': null,
    'Steps_Goal': null,
  };

  int cycMin, cycSec, jogMin, jogSec;
  String _error;

  final _formKey = GlobalKey<FormState>();
  final _input = new InputManipulation();

  @override
  void initState() {
    super.initState();
    getInitValues();
  }

  void getInitValues() async {

    DatabaseManagement _management = DatabaseManagement(widget._user);

    _exercSettings.forEach((key, value) async {
      await _management.getSingleFieldInfo('exercise_goals', '$key').then((newValue) {
        setState(() {
          _exercSettings[key] = newValue;
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
              alignment: Alignment.center,
              width: _width,
              height: _height,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  'Cycling time:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 50.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'Empty';
                                    else if(!_input.isNumeric(minField)) return 'Wrong Format';
                                    else if(int.parse(minField) > 59) return '<59';
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
                                      hintText: _exercSettings['Cycling_Goal'] == null
                                          ? ''
                                          : _exercSettings['Cycling_Goal'].split(':')[0],
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
                                  onChanged: (minField){
                                    setState(() {
                                      cycMin = int.parse(minField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'min',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 50.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (secField) {
                                    if(secField.isEmpty) return 'Empty';
                                    else if(!_input.isNumeric(secField)) return 'Wrong Format';
                                    else if(int.parse(secField) > 59) return '<59';
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
                                      hintText: _exercSettings['Cycling_Goal'] == null
                                          ? ''
                                          : _exercSettings['Cycling_Goal'].split(':')[1],
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
                                  onChanged: (secField){
                                    setState(() {
                                      cycSec = int.parse(secField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  'sec',
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
                                  'Jogging time:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 50.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'Empty';
                                    else if(!_input.isNumeric(minField)) return 'Wrong Format';
                                    else if(int.parse(minField) > 59) return '<59';
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
                                      hintText: _exercSettings['Jogging_Goal'] == null
                                          ? ''
                                          : _exercSettings['Jogging_Goal'].split(':')[0],
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
                                  onChanged: (minField){
                                    setState(() {
                                      jogMin = int.parse(minField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'min',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 50.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (secField) {
                                    if(secField.isEmpty) return 'Empty';
                                    else if(!_input.isNumeric(secField)) return 'Wrong Format';
                                    else if(int.parse(secField) > 59) return '<59';
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
                                      hintText: _exercSettings['Jogging_Goal'] == null
                                          ? ''
                                          : _exercSettings['Jogging_Goal'].split(':')[1],
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
                                  onChanged: (secField){
                                    setState(() {
                                      jogSec = int.parse(secField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Text(
                                  'sec',
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
                                  'Push Up Daily Goal:',
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
                                    if(minField.isEmpty) return 'Empty';
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
                                      hintText: _exercSettings['Push-Ups_Goal'] == null
                                          ? ''
                                          : _exercSettings['Push-Ups_Goal'],
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
                                  onChanged: (minField){
                                    setState(() {
                                      jogMin = int.parse(minField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'times',
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
                                  'Pull Up Daily Goal:',
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
                                    if(minField.isEmpty) return 'Empty';
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
                                      hintText: _exercSettings['Pull-Ups_Goal'] == null
                                          ? ''
                                          : _exercSettings['Pull-Ups_Goal'],
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
                                  onChanged: (minField){
                                    setState(() {
                                      jogMin = int.parse(minField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'times',
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
                                  'Sit Up Daily Goal:',
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
                                    if(minField.isEmpty) return 'Empty';
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
                                      hintText: _exercSettings['Sit-Ups_Goal'] == null
                                          ? ''
                                          : _exercSettings['Sit-Ups_Goal'],
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
                                  onChanged: (minField){
                                    setState(() {
                                      jogMin = int.parse(minField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'times',
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
                                  'Daily:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0
                                  ),
                                ),
                              ),
                              Container(
                                width: 150.0,
                                height: 50.0,
                                child: TextFormField(
                                  validator: (minField) {
                                    if(minField.isEmpty) return 'Empty';
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
                                      hintText: _exercSettings['Steps_Goal'] == null
                                          ? ''
                                          : _exercSettings['Steps_Goal'],
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
                                  onChanged: (minField){
                                    setState(() {
                                      jogMin = int.parse(minField);
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 26.0),
                                child: Text(
                                  'steps',
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
                                    .updateGoals(_exercSettings, 'exercise_goals')
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
