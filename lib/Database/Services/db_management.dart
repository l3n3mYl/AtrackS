import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManagement {
  DatabaseManagement(this._user);

  final User _user;

  final FirebaseFirestore _reference = FirebaseFirestore.instance;

  Future updateMeditationWeeklyTime(int day, String time) async {
    String collection = 'meditation';
    String field = 'WeeklyStatus';
    try{
      DocumentSnapshot snapshot = await _reference.collection('meditation')
              .doc(_user.uid).get();
      if(snapshot.data()[field] != null) {
        List<String> scList = snapshot.data()[field].split(", ");
        scList[day - 1] = time;
        final String data = scList.reduce((value, element) => value + ', ' + element);
        final Map<String, String> map = {field : data};
        await _reference.collection(collection).doc(_user.uid).update(map);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<String>> retrieveListFromSingleDoc(String collection,
      String document) async {
    List<String> _list = new List<String>();
    try{
      DocumentSnapshot snapshot = await _reference.collection(collection)
          .doc(document).get();
      for(var i = 0; i < snapshot.data().length; ++i){
        _list.add(snapshot.data()["$i"]);
      }
      return _list;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateWeeklyProgress(int day, String amount, String collection, String field) async {
    try{
      DocumentSnapshot snapshot =
          await _reference.collection(collection).doc(_user.uid).get();
      if(snapshot.data()[field] != null){
        List<String> list = snapshot.data()[field].split(", ");
        list[day - 1] = amount;
        final String data = list.reduce((value, element) => value + ', ' + element);
        final Map<String, String> map = {field : data};
        await _reference.collection(collection).doc(_user.uid).update(map);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetWeeklyExercGraphs() async {
    try{
      await _reference.collection('exercises').get().then((value) {
        value.docs.forEach((doc) {
          for(var i = 0; i < doc.data().length; ++i) {
            if(doc.data().keys.elementAt(i) != 'LastUpdated'){
              if(doc.data().keys.elementAt(i) == 'Cycling')
                updateSingleField('exercises', doc.data().keys.elementAt(i), '00:00');
              else if(doc.data().keys.elementAt(i) == 'Jogging')
                updateSingleField('exercises', doc.data().keys.elementAt(i), '00:00');
              else updateSingleField('exercises', doc.data().keys.elementAt(i), '0');
            }
          }
        });
      });
      await _reference.collection('exercise_weekly_progress').get()
          .then((value) {
         value.docs.forEach((doc) {
           for(var i = 0; i < doc.data().length; ++i) {
             if(doc.data().keys.elementAt(i) != 'LastUpdated'){
               if(doc.data().keys.elementAt(i) == 'Cycling')
                 updateSingleField('exercise_weekly_progress',
                     doc.data().keys.elementAt(i),
                     '00:00, 00:00, 00:00, 00:00, 00:00, 00:00, 00:00');
               else if(doc.data().keys.elementAt(i) == 'Jogging')
                 updateSingleField('exercise_weekly_progress',
                     doc.data().keys.elementAt(i),
                     '00:00, 00:00, 00:00, 00:00, 00:00, 00:00, 00:00');
               else updateSingleField('exercise_weekly_progress',
                     doc.data().keys.elementAt(i),
                     '0, 0, 0, 0, 0, 0, 0');
             }
           }
         });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetWeeklyNutrGraphs() async {
    try{
      await _reference.collection('nutrition').get().then((value) {
        value.docs.forEach((doc) {
          for(var i = 0; i < doc.data().length; ++i) {
            if(doc.data().keys.elementAt(i) != 'LastUpdated')
              updateSingleField('nutrition', doc.data().keys.elementAt(i), '0');
          }
        });
      });
      await _reference.collection('nutrition_weekly_progress').get()
        .then((value) {
          value.docs.forEach((doc) {
            for(var i = 0; i < doc.data().length; ++i) {
              updateSingleField('nutrition_weekly_progress',
                  doc.data().keys.elementAt(i), '0, 0, 0, 0, 0, 0, 0');
            }
          });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> retrieveExerciseInfoMap() async {
    Map<String, dynamic> exerciseInfo;
    try {
      await _reference.collection('exercises').doc(_user.uid).get().then((value) {
        exerciseInfo = value.data();
        // return value.data();
      });
      // await _reference.collection('exercises').get().then((value) {
      //   value.docs.forEach((doc) {
      //     print('${doc.data()} doooooooooc');
      //     exerciseInfo = doc.data();
      //   });
      // });
      // return exerciseInfo;
      if(exerciseInfo != null) {
        return exerciseInfo;
      }
    } catch (e) {
      print('${e.toString()} ERRORORROOROROROROROROR');
      return null;
    }
  }

  Future<Map<String, dynamic>> retrieveNutritionInfoMap() async {
    Map<String, dynamic> nutritionInfo = new Map();
    try{
      await _reference.collection('nutrition').get().then((value) {
        value.docs.forEach((doc) {
          nutritionInfo = doc.data();
        });
      });
      return nutritionInfo;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> getSingleFieldInfo(String collection, String field) async {
    try {
      DocumentSnapshot snapshot =
          await _reference.collection(collection).doc(_user.uid).get();
      return snapshot.data()[field];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updateSingleField(
      String collection, String field, String count) async {
    Map<String, String> data = {field: count};
    try {
      await _reference
          .collection(collection)
          .doc(_user.uid)
          .update(data);
    } catch (e) {
      print(e.toString());
    }
  }
  
  Future<void> updateUserInformation(Map<String, String> info) async {
    try{
      info.forEach((key, value) async {
        await _reference
            .collection('users')
            .doc(_user.uid)
            .update({key:value});
      });
    } catch (e) {
      print(e.toString());
    }
  }
  
  Future<void> updateGoals(Map<String, String> goals, String collection) async {
    try{
      goals.forEach((key, value) async {
        if(value != null){
          await _reference.collection(collection).doc(_user.uid)
              .update({key:value});
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateMeditationGoal(String time) async {
    try{
      await _reference.collection('meditation').doc(_user.uid)
          .update({'Goal':time});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updateEmailAndPassword(String email, String password) async {

    String emailCheck, passCheck;

    try{
      await _user.updateEmail(email).then((value) => emailCheck = 'Success');
      await _user.updatePassword(password).then((value) => passCheck = 'Success');
    } catch (e) {
      print(e.toString());
    }

    if(emailCheck != null && passCheck != null)
      return emailCheck;
    else return null;
  }
  
  Future<String> updateNutritionWithProduct(List<String> nutritionList,
      String nutritionMass) async {

    final List<String> nutritionNames = [
      'Calories',
      'Carbs',
      'Fats',
      'Protein',
    ];

    double temp;
    nutritionList.removeAt(0);

    try{
      await _reference.collection('nutrition').doc(_user.uid)
            .get().then((value) => {
              for(var i = 0; i < value.data().keys.length; ++i) {
                for(var j = 0; j < nutritionNames.length; ++j) {
                  if(value.data().keys.elementAt(i) == nutritionNames[j]) {
                    temp = double.parse(value.data().values.elementAt(i)),
                    temp += double.parse(nutritionList[j]),
                    temp *= double.parse(nutritionMass) / 100,
                    _reference.collection('nutrition').doc(_user.uid)
                          .update({'${value.data().keys.elementAt(i)}':'${temp.toStringAsFixed(2)}'})
                  }
                },
              },
      });

      return 'Success';
    } catch (e) {
      print(e.toString());
    }
  }

//TODO: DON'T TOUCH
//  Future deleteFirebaseDocs() async {
//    _reference.collection('exercises').get().then((snapshot) {
//      for(DocumentSnapshot ds in snapshot.docs){
//        ds.reference.delete();
//      }
//    });
//  }
}
