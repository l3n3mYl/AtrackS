import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/Database/Models/exercises.dart';
import 'package:com/Database/Models/nutrition.dart';
import 'package:com/Database/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _reference = Firestore.instance;
  final User newUser = User();

  final Nutrition _newNutrition = Nutrition(
    calories: "0",
    carbs: "0",
    fats: "0",
    protein: "0",
    water: "0",
  );

  final Exercises _newExercises = Exercises(
    cycling: "0",
    jogging: "0",
    pullUps: "0",
    pushUps: "0",
    sitUps: "0",
    steps: "0",
  );

  Future registerWithEmailAndPass(User newUser) async {
    try{
      //TODO: CHeck if the email already exists not to overwrite the data
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: newUser.mail, password: newUser.pass);
      FirebaseUser fUser = result.user;
      await _reference.collection('users').document(fUser.uid).setData(newUser.userInfoToMap());
      await _reference.collection('nutrition').document(fUser.uid).setData(_newNutrition.nutritionInfoToMap());
      await _reference.collection('exercises').document(fUser.uid).setData(_newExercises.exerciseInfoToMap());

      return fUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInGooglePlus() async {
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication authentication =
          await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);

      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      await _googleSignIn.signIn();

      //Create a new user in case of registration needed
      User newUser = User(
        email: user.email,
        gender: 'Null',
        height: 'Null',
        weight: 'Null',
        username: user.displayName
      );

      //Check if the user already exists in the database
      bool exists = false;
      await _reference.collection('users').getDocuments()
      .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) {
          if(f.documentID == user.uid || f.data['Email'] == user.email) exists = true;
        });
      });

      //Add new user info if there was none prior
      if(!exists){
        await _reference.collection('users').document(user.uid).setData(newUser.userInfoToMap());
        await _reference.collection('nutrition').document(user.uid).setData(_newNutrition.nutritionInfoToMap());
        await _reference.collection('exercises').document(user.uid).setData(_newExercises.exerciseInfoToMap());
      }

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInFacebook() async {
    try {
      final FacebookLogin facebookLogin = new FacebookLogin();
      final result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: result.accessToken.token);
        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;

        //Create a new user in case this is the first time user has signed in
        User newUser = User(
          email: user.email,
          gender: 'Null',
          height: 'Null',
          weight: 'Null',
          username: user.displayName,
        );

        //Check if the user already exists
        bool exists = false;
        await _reference.collection('users').getDocuments().then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((f) {
            if(f.documentID == user.uid || f.data['Email'] == user.email) exists = true;
          });
        });

        //Add new user info if there was none prior
        if(!exists){
          await _reference.collection('users').document(user.uid).setData(newUser.userInfoToMap());
          await _reference.collection('nutrition').document(user.uid).setData(_newNutrition.nutritionInfoToMap());
          await _reference.collection('exercises').document(user.uid).setData(_newExercises.exerciseInfoToMap());
        }

        return user;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOutFacebook() async {
    try {
      await FacebookLogin().logOut();
      print('Signed Out From Facebook');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      print('Signed out from Google');
    } catch (e) {
      print(e.toString());
    }
  }
}
