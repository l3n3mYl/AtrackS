import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ExerciseJsonManipulation {

  ExerciseJsonManipulation();

  Map<String, Map<String, dynamic>> _exerciseDisplaySettings = {};
  SharedPreferences _preferences;

  Map<String, Map<String, dynamic>> encodeMap(Map<String, Map<String, dynamic>> map) {
    Map<String, Map<String, dynamic>> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });

    return newMap;
  }

  Map<String, Map<String, dynamic>> checkSettings(SharedPreferences _preferences) {
    ExerciseJsonManipulation _ejm = new ExerciseJsonManipulation();

    Map<String, bool> _controlSettings = {
      'Cycling': true,
      'Jogging': true,
      'Pull-Ups': true,
      'Push-Ups': true,
      'Sit-Ups': true,
      'Steps': true,
    };

    if (_exerciseDisplaySettings["exerciseSettings"] == null) {
      _exerciseDisplaySettings["exerciseSettings"] = _controlSettings;
      _preferences.setString("exerciseSettings",
          json.encode(_ejm.encodeMap(_exerciseDisplaySettings)));

      return _exerciseDisplaySettings;
    }

    return null;
  }

  Future<Map<String, Map<String, dynamic>>> initSettings() async {
    _preferences = await SharedPreferences.getInstance();
    _exerciseDisplaySettings = Map<String, Map<String, dynamic>>.from(
        json.decode(_preferences.getString("exerciseSettings")));

    dynamic result = checkSettings(_preferences);

    if(result == null)
      return _exerciseDisplaySettings;
    else
      return result;
  }
}