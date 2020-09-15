import 'dart:convert';

import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/exercise_json_manipulation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseManage extends StatelessWidget {

  final String _settings;

  ExerciseManage(this._settings);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Container(
        child: Stack(
          children: [
            BackgroundTriangle(),
            Container(
              width: size.width,
              height: size.height,
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
                width: size.width,
                height: size.height,
                color: mainColor.withOpacity(0.3),
                child: SingleChildScrollView(
                  child: Center(
                    child: CheckboxList(_settings),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class CheckboxList extends StatefulWidget {

  final String _settings;

  CheckboxList(this._settings);

  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {

  SharedPreferences _preferences;
  ExerciseJsonManipulation _ejm = new ExerciseJsonManipulation();
  Map<String, dynamic> _exListSort = {
    'Cycling':false,
    'Jogging':false,
    'Pull-Ups':false,
    'Push-Ups':false,
    'Sit-Ups':true,
    'Steps':true,
  };

  @override
  void initState() {
    super.initState();
    _exListSort = json.decode(widget._settings);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        CheckboxListTile(
          activeColor: accentColor,
          checkColor: Colors.black,
          title: Text('Cycling', style: TextStyle(
              color: textColor,
              fontFamily: 'PTSerif',
              fontSize: 18
            ),
          ),
          value: _exListSort['Cycling'],
          onChanged: (bool cycValue) {
            setState(() {
              _exListSort.update('Cycling', (value) => cycValue);
            });
          },
        ),
        CheckboxListTile(
          activeColor: accentColor,
          checkColor: Colors.black,
          title: Text('Jogging', style: TextStyle(
              color: textColor,
              fontFamily: 'PTSerif',
              fontSize: 18
            ),
          ),
          value: _exListSort['Jogging'],
          onChanged: (bool jogValue) {
            setState(() {
              _exListSort.update('Jogging', (value) => jogValue);
            });
          },
        ),
        CheckboxListTile(
          activeColor: accentColor,
          checkColor: Colors.black,
          title: Text('Pull-Ups', style: TextStyle(
              color: textColor,
              fontFamily: 'PTSerif',
              fontSize: 18
            ),
          ),
          value: _exListSort['Pull-Ups'],
          onChanged: (bool pullValue) {
            setState(() {
              _exListSort.update('Pull-Ups', (value) => pullValue);
            });
          },
        ),
        CheckboxListTile(
          activeColor: accentColor,
          checkColor: Colors.black,
          title: Text('Push-Ups', style: TextStyle(
              color: textColor,
              fontFamily: 'PTSerif',
              fontSize: 18
            ),
          ),
          value: _exListSort['Push-Ups'],
          onChanged: (bool pushValue) {
            setState(() {
              _exListSort.update('Push-Ups', (value) => pushValue);
            });
          },
        ),
        CheckboxListTile(
          activeColor: accentColor,
          checkColor: Colors.black,
          title: Text('Sit-Ups', style: TextStyle(
              color: textColor,
              fontFamily: 'PTSerif',
              fontSize: 18
            ),
          ),
          value: _exListSort['Sit-Ups'],
          onChanged: (bool sitValue) {
            setState(() {
              _exListSort.update('Sit-Ups', (value) => sitValue);
            });
          },
        ),
        CheckboxListTile(
          activeColor: accentColor,
          checkColor: Colors.black,
          title: Text('Steps', style: TextStyle(
              color: textColor,
              fontFamily: 'PTSerif',
              fontSize: 18
            ),
          ),
          value: _exListSort['Steps'],
          onChanged: (bool stepValue) {
            setState(() {
              _exListSort.update('Steps', (value) => stepValue);
            });
          },
        ),
        SizedBox(
          height: 69.0,
        ),
        GestureDetector(
          onTap: () async {
            _preferences = await SharedPreferences.getInstance();
            if(_preferences != null) {
              _preferences.setString('exerciseSettings', json.encode(_exListSort));
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              width: 120,
              height: 50,
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
                      'Save',
                      style: TextStyle(
                          color: Color.fromRGBO(155, 144, 130, 1),
                          fontFamily: 'PTSerif',
                          fontSize: 20,
                          fontWeight: FontWeight.w200
                      ),
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
