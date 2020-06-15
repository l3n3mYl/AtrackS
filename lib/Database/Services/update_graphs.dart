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

  void checkAllFieldsForUpdate() {
    checkMeditationUpdate();
    checkLastDayNutrUpdate();
    checkLastDayExercUpdate();
    checkMonthlyNutritionUpdate();
    checkMonthlyExerciseUpdate();
    checkFiveRecentMonthsNutritionUpdate();
    checkFiveRecentMonthsExercUpdate();
  }
  
  void checkMeditationUpdate() async {
    DatabaseManagement _management = DatabaseManagement(_user);
    dynamic lastUpdateDate = await _management
        .getSingleFieldInfo('meditation', 'LastUpdated').then((value) {
          return DateTime.parse(value);
    });

    //Check when it was last time updated
    if(lastUpdateDate != null){
      int diff = DateTime.now().difference(lastUpdateDate).inDays;

      //Update if update was done yesterday or earlier
      if(diff > 0){
        if(diff >= 7){
          //If difference more than a week, reset the values to 00:00
          await _management.updateSingleField('meditation', 'Current', '00:00');
          for(var i = 0; i < 7; ++i){
            await _management.updateMeditationWeeklyTime(i + 1, '00:00');
            await _management.updateSingleField('meditation', 'LastUpdated', DateTime.now().toString());
          }
        } else if(diff < 7) {
          //If not more than 7 days have passed
          int day = DateTime.now().weekday - diff;//calculate if only curr week needs update
          if(day < 1){
            int it = DateTime.now().weekday;
            //update curr week
            while(it >= 1){
              await _management.updateMeditationWeeklyTime(it, '00:00');
              it--;
            }

            //update prev week
            while(day <= 0){
              await _management.updateMeditationWeeklyTime(7 + day, '00:00');
              day++;
            }
          } else if (day >= 1) {
            //Update only curr week if the difference are in this week only
            for(var i = 0; i < day; ++i) {
              await _management.updateMeditationWeeklyTime(DateTime.now().weekday + i, '00:00');
            }
          }
          //Update date and current day's progress
          await _management.updateSingleField('meditation', 'Current', '00:00');
          await _management.updateSingleField('meditation', 'LastUpdated', DateTime.now().toString());
        }
      }
    }
  }

  void checkFiveRecentMonthsNutritionUpdate() async {
    int lastDigit;
    DatabaseManagement _management = DatabaseManagement(_user);
    dynamic lastUpdateDate = await _management
        .getSingleFieldInfo('nutrition_monthly_progress', 'LastUpdated')
        .then((value) {
      lastDigit = int.parse(value.substring(value.length - 1, value.length));
      if(lastDigit == 5){
        lastDigit = 0;
      }
      return DateTime.parse(value);
    });
    if(lastUpdateDate != null){
      int diff = DateTime.now().difference(lastUpdateDate).inDays;
      if(diff >= 30){
        String date = DateTime.now().toString().substring(0, DateTime.now().toString().length - 1);

        //For all exercises
        for(var i = 0; i < nutrList.length; ++i){
          String temp = await _management.getSingleFieldInfo(
              'nutrition_single_month_average',
              nutrList[i]);
          List<String> list = temp.split(", ");
          int sumOfNutritionInfo = 0;

          //Calculate average
          //Average of 4 weeks
          for(var j = 0; j < 4; ++j){
            sumOfNutritionInfo += int.parse(list[j]);
          }

          int finalAverage = sumOfNutritionInfo ~/ 4;

          //Update a proper list member

          await _management.getSingleFieldInfo('nutrition_monthly_progress', nutrList[i])
              .then((value) {
            List<String> oldValueList = value.split(", ");
            oldValueList[lastDigit] = "$finalAverage";
            String updateString = oldValueList.reduce((val, elem) => val + ', ' + elem);

            _management.updateSingleField(
                'nutrition_monthly_progress', nutrList[i], updateString);
          });
        }
        _management.updateSingleField('nutrition_monthly_progress', 'LastUpdated', '$date${lastDigit + 1}');
      }
    }
  }
  
  void checkFiveRecentMonthsExercUpdate() async {
    int lastDigit;
    DatabaseManagement _management = DatabaseManagement(_user);
    dynamic lastUpdateDate = await _management
        .getSingleFieldInfo('exercise_monthly_progress', 'LastUpdated')
        .then((value) {
          lastDigit = int.parse(value.substring(value.length - 1, value.length));
         if(lastDigit == 5){
           lastDigit = 0;
         }
         return DateTime.parse(value);
    });
    if(lastUpdateDate != null){
      int diff = DateTime.now().difference(lastUpdateDate).inDays;
      if(diff >= 30){
        String date = DateTime.now().toString().substring(0, DateTime.now().toString().length - 1);

        //For all exercises
        for(var i = 0; i < exercList.length; ++i){
          String temp = await _management.getSingleFieldInfo(
              'exercises_single_month_average',
              exercList[i]);
          List<String> list = temp.split(", ");
          int sumOfExerciseInfo = 0;

          //Calculate average
          //Average of 4 weeks
          for(var j = 0; j < 4; ++j){
            sumOfExerciseInfo += int.parse(list[j]);
          }

          int finalAverage = sumOfExerciseInfo ~/ 4;

          //Update a proper list member

          await _management.getSingleFieldInfo('exercise_monthly_progress', exercList[i])
              .then((value) {
             List<String> oldValueList = value.split(", ");
             oldValueList[lastDigit] = "$finalAverage";
             String updateString = oldValueList.reduce((val, elem) => val + ', ' + elem);

             _management.updateSingleField(
                 'exercise_monthly_progress', exercList[i], updateString);
          });
        }
        _management.updateSingleField('exercise_monthly_progress', 'LastUpdated', '$date${lastDigit + 1}');
      }
    }
  }

  void checkMonthlyNutritionUpdate() async {
    int lastDigit;
    DatabaseManagement _management = DatabaseManagement(_user);
    dynamic lastUpdateDate = await _management
        .getSingleFieldInfo('nutrition_single_month_average', 'LastUpdated')
        .then((value) {
      lastDigit = int.parse(value.substring(value.length - 1, value.length));
      if(lastDigit == 4){
        lastDigit = 0;
      }
      return DateTime.parse(value);
    });
    if(lastUpdateDate != null) {
      int diff = DateTime.now().difference(lastUpdateDate).inDays;
      if(diff >= 7) {
        String date = DateTime.now().toString().substring(0, DateTime.now().toString().length - 1);

        //For all of the nutrition values
        for( var i = 0; i < nutrList.length; ++i) {
          String temp = await _management.getSingleFieldInfo(
              'nutrition_weekly_progress',
              nutrList[i]); //Get weekly progress list
          List<String> list = temp.split(", ");
          int sumOfNutritionInfo = 0;

          //Calculate average
          //Loop 7 times because there is 7 days in a week
          for( var j = 0; j < 7; j++){
            sumOfNutritionInfo += int.parse(list[i]);
          }
          int finalAverage = sumOfNutritionInfo ~/ 7;

          //Update a proper list member
          await _management.getSingleFieldInfo('nutrition_single_month_average', nutrList[i])
              .then((value) {
            List<String> oldValueList = value.split(", ");
            oldValueList[lastDigit] = "$finalAverage";
            String updateString = oldValueList.reduce((val, elem) => val + ', ' + elem);

            _management.updateSingleField(
                'nutrition_single_month_average', nutrList[i], updateString);
          });

        }
        _management.updateSingleField(
            'nutrition_single_month_average',
            'LastUpdated',
            '$date${lastDigit + 1}');
      }
    }
  }
  
  void checkMonthlyExerciseUpdate() async {
    int lastDigit;
    DatabaseManagement _management = DatabaseManagement(_user);
    dynamic lastUpdateDate = await _management
        .getSingleFieldInfo('exercises_single_month_average', 'LastUpdated')
        .then((value) {
          lastDigit = int.parse(value.substring(value.length - 1, value.length));
          if(lastDigit == 4){
            lastDigit = 0;
          }
          return DateTime.parse(value);
    });
    if(lastUpdateDate != null) {
      int diff = DateTime.now().difference(lastUpdateDate).inDays;
      if(diff >= 7) {
        String date = DateTime.now().toString().substring(0, DateTime.now().toString().length - 1);

        //For all of the exercises
        for( var i = 0; i < exercList.length; ++i) {
          String temp = await _management.getSingleFieldInfo(
              'exercise_weekly_progress',
              exercList[i]); //Get weekly progress list
          List<String> list = temp.split(", ");
          int sumOfExerciseInfo = 0;
          //Calculate average
          //Loop 7 times because there is 7 days in a week
          for( var j = 0; j < 7; j++){
            sumOfExerciseInfo += int.parse(list[i]);
          }
          int finalAverage = sumOfExerciseInfo ~/ 7;


          //Update a proper list member
          await _management.getSingleFieldInfo('exercises_single_month_average', exercList[i])
              .then((value) {
                List<String> oldValueList = value.split(", ");
                oldValueList[lastDigit] = "$finalAverage";
                String updateString = oldValueList.reduce((val, elem) => val + ', ' + elem);
                _management.updateSingleField(
                    'exercises_single_month_average', exercList[i], updateString);
          });

        }
        _management.updateSingleField(
            'exercises_single_month_average',
            'LastUpdated',
            '$date${lastDigit + 1}');
      }
    }
  }

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
      if (diff > 7) {
        await _management.resetWeeklyExercGraphs().then((_) {
          _management.updateSingleField(
              'exercises', 'LastUpdated', DateTime.now().toString());
        });
      }
      else if (diff > 0 && diff <= 7) {
        if (DateTime.now().weekday - diff < 1) {
          diff = 7 + DateTime.now().weekday - diff;
          for (var i = 0; i < exercList.length; ++i) {
            await _management
                .getSingleFieldInfo('exercises', exercList[i])
                .then((value) {
                    _management.updateWeeklyProgress(
                        diff, value, 'exercise_weekly_progress', exercList[i]);
                    _management.updateSingleField('exercises', exercList[i], '0');
            });
          }
          _management.updateSingleField(
              'exercises', 'LastUpdated', DateTime.now().toString());
        } else {
          for (var i = 0; i < exercList.length; ++i) {
            await _management
                .getSingleFieldInfo('exercises', exercList[i])
                .then((value) {
                    _management.updateWeeklyProgress(DateTime.now().weekday - diff, value,
                        'exercise_weekly_progress', exercList[i]);
                    _management.updateSingleField('exercises', exercList[i], '0');
            });
          }
          _management.updateSingleField(
              'exercises', 'LastUpdated', DateTime.now().toString());
        }
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
      else if (diff > 0 && diff <= 7) {
        if (DateTime.now().weekday - diff < 1) {
          diff = 7 + DateTime.now().weekday - diff;
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
              _management.updateWeeklyProgress(DateTime.now().weekday - diff, value,
                  'nutrition_weekly_progress', nutrList[i]);
              _management.updateSingleField('nutrition', nutrList[i], '0');
            });
          }
        }
      }
        _management.updateSingleField(
            'nutrition', 'LastUpdated', DateTime.now().toString());
    }
  }
}
