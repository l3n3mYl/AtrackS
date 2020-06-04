import 'package:com/Database/Services/db_management.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateGraphs {
  final FirebaseUser _user;

  UpdateGraphs(this._user);

  final List<String> exercList = [
    'Cycling',
    'Jogging',
    'Pull-Ups',
    'Push-Ups',
    'Sit-Ups',
    'Steps',
  ];

  final List<String> nutrList = [
    'Calories',
    'Carbs',
    'Fats',
    'Protein',
    'Water',
  ];

  //TODO: check if still updates correctly
  //Check Last Day the exercise was updated
  //Update the weekly graph
  void checkLastDayExercUpdate() async {
    DatabaseManagement _management = DatabaseManagement(_user);
    dynamic lastUpdateDate = await _management
        .getSingleFieldInfo('exercises', 'LastUpdated')
        .then((value) {
      return DateTime.parse(value);
    });
    if (lastUpdateDate != null) {
      int diff = DateTime.now().difference(lastUpdateDate).inDays;
      if (diff > 7) _management.resetWeeklyExercGraphs();
      else if (diff > 0 && diff <= 7) {
        if (DateTime.now().day - diff < 1) {
//          if (diff > 7) _management.resetWeeklyExercGraphs();
          diff = 7 + DateTime.now().day - diff;
          for (var i = 0; i < exercList.length; ++i) {
            await _management
                .getSingleFieldInfo('exercises', exercList[i])
                .then((value) {
                  if(!value.contains(" ")){
                    _management.updateWeeklyProgress(
                        diff, value, 'exercise_weekly_progress', exercList[i]);
                    _management.updateSingleField('exercises', exercList[i], '0');
                  }
            });
          }
        } else {
          for (var i = 0; i < exercList.length; ++i) {
            await _management
                .getSingleFieldInfo('exercises', exercList[i])
                .then((value) {
                  if(!value.contains(" ")){
                    _management.updateWeeklyProgress(DateTime.now().day - diff, value,
                        'exercise_weekly_progress', exercList[i]);
                    _management.updateSingleField('exercises', exercList[i], '0');
                  }
            });
          }
        }
        _management.updateSingleField(
            'exercises', 'LastUpdated', DateTime.now().toString());
      }
    }
  }

  //Check Last Day the nutrition was updated
  //Update the weekly graph
  void checkLastDayNutrUpdate() async {
    DatabaseManagement _management = DatabaseManagement(_user);
    dynamic lastUpdateDate = await _management
        .getSingleFieldInfo('nutrition', 'LastUpdated')
        .then((value) {
      return DateTime.parse(value);
    });
    if (lastUpdateDate != null) {
      int diff = DateTime.now().difference(lastUpdateDate).inDays;
      if (diff > 7) _management.resetWeeklyNutrGraphs();
      else if (diff > 0 && diff < 7) {
        if (DateTime.now().day - diff < 1) {
          diff = 7 + DateTime.now().day - diff;
          for (var i = 0; i < nutrList.length; ++i) {
            await _management
                .getSingleFieldInfo('nutrition', nutrList[i])
                .then((value) {
              _management.updateWeeklyProgress(
                  diff, value, 'nutrition_weekly_progress', nutrList[i]);
              _management.updateSingleField('nutrition', nutrList[i], '0');
            });
          }
        } else {
          for (var i = 0; i < nutrList.length; ++i) {
            await _management
                .getSingleFieldInfo('nutrition', nutrList[i])
                .then((value) {
              _management.updateWeeklyProgress(DateTime.now().day - diff, value,
                  'nutrition_weekly_progress', nutrList[i]);
              _management.updateSingleField('nutrition', nutrList[i], '0');
            });
          }
        }
        _management.updateSingleField(
            'nutrition', 'LastUpdated', DateTime.now().toString());
      }
    }
  }
}
