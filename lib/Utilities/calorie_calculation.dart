import 'dart:async';
import 'dart:math';

import 'package:com/Database/Services/db_management.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalorieCalculation {
  final FirebaseUser user;

  CalorieCalculation(this.user);
  DatabaseManagement _management;

  Future<double> getCaloriesWalking(List<double> xList, List<double> yList,
      List<double> zList) async {

    final x = xList[1] - xList[0];
    final y = yList[1] - yList[0];
    final z = zList[1] - zList[0];
    final distance = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2)).toStringAsFixed(3);

    //Calculate speed for more accuracy
    double speed = double.parse(distance) / 0.5;

    var weight;
    var height;
    _management = DatabaseManagement(user);

    //Get user stats
    await _management.getSingleFieldInfo('users', 'Weight').then(
        (value) {
          try{
            weight = double.parse(value);
          } catch (e) {
            weight = value;
          }
        });

    await _management.getSingleFieldInfo('users', 'Height').then(
        (value) {
          try{
            height = double.parse(value);
          } catch (e) {
            height = value;
          }
        });

    //If no information given, set default values
    if(weight == null || height == null){
      weight = 55;
      height = 1.6;
    }
    if(weight == 'Null' || height == 'Null' || weight == 'null' ||
        height == 'null'){
      weight = 55;
      height = 1.6;
    }

    if(speed / 10 < 0.9){
      speed = 0.0;
    }
    double result = ((0.035 * weight) + (pow(speed / 10, 2) / height) * 0.029 * weight);
    if(result <= 2.46)
      result = 0.0;

    return result;
  }

  Future<double> getCaloriesCycling(int time) async {
    _management = DatabaseManagement(user);

    String weight, age, gender = '';
    int averHeartRate = 200;

    await _management.getSingleFieldInfo('users', 'Gender').then((value) {
      gender = value;
    });
    await _management.getSingleFieldInfo('users', 'Weight').then((value){
      weight = value;
    });
    await _management.getSingleFieldInfo('users', 'Age').then((value) {
      age = value;
    });

    averHeartRate = (207 - (0.7 * int.parse(age))).toInt();

    if(gender != '' && gender == 'Male') {
      return (int.parse(age) * 0.2017) - (int.parse(weight) * 0.09036) + (averHeartRate * 0.6309) - 55.0969 * (time / 4.184);
    } else if(gender != '' && gender == 'Female') {
      return (int.parse(age) * 0.074) - (int.parse(weight) * 0.05741) + (averHeartRate * 0.4472) - 20.4022 * (time / 4.184);
    } else return 0.0;
  }
}