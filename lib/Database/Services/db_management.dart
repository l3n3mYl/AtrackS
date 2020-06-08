import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManagement {
  DatabaseManagement(this._user);

  final FirebaseUser _user;

  final Firestore _reference = Firestore.instance;

  Future updateWeeklyProgress(int day, String amount, String collection, String field) async {
    try{
      DocumentSnapshot snapshot =
          await _reference.collection(collection).document(_user.uid).get();
      if(snapshot[field] != null){
        List<String> list = snapshot[field].split(", ");
        list[day - 1] = amount;
        final String data = list.reduce((value, element) => value + ', ' + element);
        final Map<String, String> map = {field : data};
        await _reference.collection(collection).document(_user.uid).updateData(map);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetWeeklyExercGraphs() async {
    int iter = 1;
    try{
      await _reference.collection('exercises').getDocuments().then((value) {
        value.documents.forEach((doc) {
          updateSingleField('exercises', doc.data.keys.elementAt(iter), '0');
          iter++;
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetWeeklyNutrGraphs() async {
    int iter = 1;
    try{
      await _reference.collection('nutrition').getDocuments().then((value) {
        value.documents.forEach((doc) {
          updateSingleField('nutrition', doc.data.keys.elementAt(iter), '0');
          iter++;
        });
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> retrieveExerciseInfoMap() async {
    Map<String, dynamic> exerciseInfo = new Map();
    try {
      await _reference.collection('exercises').getDocuments().then((value) {
        value.documents.forEach((doc) {
          exerciseInfo = doc.data;
        });
      });
      return exerciseInfo;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> retrieveNutritionInfoMap() async {
    Map<String, dynamic> nutritionInfo = new Map();
    try{
      await _reference.collection('nutrition').getDocuments().then((value) {
        value.documents.forEach((doc) {
          nutritionInfo = doc.data;
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
          await _reference.collection(collection).document(_user.uid).get();
      return snapshot[field];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateSingleField(
      String collection, String field, String count) async {
    Map<String, String> data = {field: count};
    try {
      await _reference
          .collection(collection)
          .document(_user.uid)
          .updateData(data);
    } catch (e) {
      print(e.toString());
    }
  }

//TODO: DON'T TOUCH
//  Future deleteFirebaseDocs() async {
//    _reference.collection('exercises').getDocuments().then((snapshot) {
//      for(DocumentSnapshot ds in snapshot.documents){
//        ds.reference.delete();
//      }
//    });
//  }
}
