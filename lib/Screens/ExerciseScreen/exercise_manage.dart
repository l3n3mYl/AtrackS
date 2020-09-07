import 'dart:convert';

import 'package:com/Design/colours.dart';
import 'package:com/Utilities/exercise_json_manipulation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseManage extends StatelessWidget {

  final String _settings;

  ExerciseManage(this._settings);

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.transparent,
      child: Container(
          alignment: Alignment.center,
          color: mainColor,
          child: SingleChildScrollView(
            child: Center(
              child: CheckboxList(_settings),
            ),
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

  bool _loaded = false;
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
  Widget build(BuildContext context) {

    if(!_loaded) {
      _exListSort = jsonDecode(widget._settings)['exerciseSettings'];
      _loaded = true;
    }

    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Cycling'),
          value: _exListSort['Cycling'],
          onChanged: (bool cycValue) {
            setState(() {
              _exListSort.update('Cycling', (value) => cycValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Jogging'),
          value: _exListSort['Jogging'],
          onChanged: (bool jogValue) {
            setState(() {
              _exListSort.update('Jogging', (value) => jogValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Pull-Ups'),
          value: _exListSort['Pull-Ups'],
          onChanged: (bool pullValue) {
            setState(() {
              _exListSort.update('Pull-Ups', (value) => pullValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Push-Ups'),
          value: _exListSort['Push-Ups'],
          onChanged: (bool pushValue) {
            setState(() {
              _exListSort.update('Push-Ups', (value) => pushValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Sit-Ups'),
          value: _exListSort['Sit-Ups'],
          onChanged: (bool sitValue) {
            setState(() {
              _exListSort.update('Sit-Ups', (value) => sitValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Steps'),
          value: _exListSort['Steps'],
          onChanged: (bool stepValue) {
            setState(() {
              _exListSort.update('Steps', (value) => stepValue);
            });
          },
        ),
        FlatButton(
          onPressed: () async {
            _preferences = await SharedPreferences.getInstance();
            if(_preferences != null) {
              _preferences.setString("exerciseSettings",
                  json.encode(_ejm.encodeMap({'exerciseSettings':_exListSort})));
              Navigator.of(context).pop();
            }
          },
          child: Text('Save and Exit'),
        ),
      ],
    );
  }
}
