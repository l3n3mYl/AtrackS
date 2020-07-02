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
            height = double.parse(value) / 100;
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

  Future<double> getCaloriesCycling(int time, int count) async {
    _management = DatabaseManagement(user);
    String weight;

    double met = 0.0;

    if(count == 0) {
      met = 3.5;
    } else if (count == 1) {
      met = 5.8;
    } else if (count == 2) {
      met = 6.8;
    } else if (count == 3) {
      met = 10;
    }

    await _management.getSingleFieldInfo('users', 'Weight').then((value){
      weight = value;
    });

    return (met * int.parse(weight) * 3.5) / 200;
  }

  Future<double> getCaloriesSitPushUps(List<double> times) async {
    _management = DatabaseManagement(user);

    int weight = 0;
    double result = 0.0;

    await _management.getSingleFieldInfo('users', 'Weight').then((value) {
      weight = int.parse(value);
    });

    weight = (weight.toDouble() * 2.205).round();

    if(times.length >= 2){
      double finalTime = times[1] - times[0];
      result = (weight / 2.2) * 8 * 0.0175 * finalTime;
    } else {
      double finalTime = 0.05;
      result = (weight / 2.2) * 8 * 0.0175 * finalTime;
    }

    return double.parse(result.toStringAsFixed(5));
  }

}