import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManagement {

  final Firestore _reference = Firestore.instance;

  Future<List<dynamic>> retrieveExerciseInfoByUid(FirebaseUser user) async {
    List exerciseInfo = new List();
    try{
      await _reference.collection('exercises').getDocuments().then((QuerySnapshot snapshots) {
      snapshots.documents.forEach((doc) {
        if(doc.documentID == user.uid){
          exerciseInfo = doc.data.values.toList();
        }
      });
    });
      print(exerciseInfo);
    return exerciseInfo;
    } catch(e) {
      print(e.toString());
      return null;
    }

    print(exerciseInfo);

//    return exerciseInfo;
  }

}