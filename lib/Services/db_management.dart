import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManagement {

  DatabaseManagement(this._user);

  final FirebaseUser _user;

  final Firestore _reference = Firestore.instance;

  Future<Map<String, dynamic>> retrieveExerciseInfoByUid() async {
    Map<String, dynamic> exerciseInfo = new Map();
    try{
      await _reference.collection('exercises').getDocuments().then((value) {
        value.documents.forEach((doc){
          exerciseInfo = doc.data;
        });
      });
    return exerciseInfo;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> getSingleFieldInfo(String collection, String field) async {
    try{
      DocumentSnapshot snapshot = await _reference.collection(collection).document(_user.uid).get();
      print(snapshot[field]);
      return snapshot[field];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future postStepCount(String stepCount) async {
    Map<String, String> steps = {'Steps': stepCount};
    try{
      await _reference.collection('exercises').document(_user.uid).updateData(steps);
    } catch (e) {
      print(e.toString());
    }
  }

}