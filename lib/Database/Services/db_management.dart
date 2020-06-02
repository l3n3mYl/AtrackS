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
      return snapshot[field];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateSingleField(String collection, String field, String count) async {
    Map<String, String> data = {field : count};
    try{
      await _reference.collection(collection).document(_user.uid).updateData(data);
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