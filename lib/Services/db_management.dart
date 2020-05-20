import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManagement {

  final Firestore _reference = Firestore.instance;

  Future<Map<String, dynamic>> retrieveExerciseInfoByUid(FirebaseUser user) async {
//    List exerciseInfo = new List();
    Map<String, dynamic> exerciseInfo = new Map();
    try{
//      await _reference.collection('exercises').getDocuments().then((QuerySnapshot snapshots) {
//      snapshots.documents.forEach((doc) {
//        if(doc.documentID == user.uid){
////          exerciseInfo = doc.data.values.toList();
//        }
//      });
//    });
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

}