import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com/Database/Models/exercises.dart';
import 'package:com/Database/Models/exercise_goals.dart';
import 'package:com/Database/Models/meditation.dart';
import 'package:com/Database/Models/single_month_progress_exercise.dart';
import 'package:com/Database/Models/single_month_progress_nutrition.dart';
import 'package:com/Database/Models/nutrition.dart';
import 'package:com/Database/Models/nutrition_goals.dart';
import 'package:com/Database/Models/user.dart' as UserModel;
import 'package:com/Database/Models/week_progress_exercise.dart';
import 'package:com/Database/Models/week_progress_nutrition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _reference = FirebaseFirestore.instance;
  final UserModel.NewUser newUser = UserModel.NewUser();

  final Meditation _meditation = Meditation(
    current: '00:00',
    goal: '15:00',
    weeklyStatus: '00:00, 00:00, 00:00, 00:00, 00:00, 00:00, 00:00',
    lastUpdated: DateTime.now().toString(),
  );

  final MonthExerciseProgress _singleMonthExerciseProgress = MonthExerciseProgress(
    cycling: '00:00, 00:00, 00:00, 00:00',
    jogging: '00:00, 00:00, 00:00, 00:00',
    pullUps: '0, 0, 0, 0',
    pushUps: '0, 0, 0, 0',
    sitUps: '0, 0, 0, 0,',
    steps: '0, 0, 0, 0',
    lastTimeUpdated: '${DateTime.now().toString()}1',
  );

  final MonthExerciseProgress _monthExerciseProgress = MonthExerciseProgress(
    cycling: '00:00, 00:00, 00:00, 00:00, 00:00',
    jogging: '00:00, 00:00, 00:00, 00:00, 00:00',
    pullUps: '0, 0, 0, 0, 0',
    pushUps: '0, 0, 0, 0, 0',
    sitUps: '0, 0, 0, 0, 0',
    steps: '0, 0, 0, 0, 0',
    lastTimeUpdated: '${DateTime.now().toString()}0',
  );

  final MonthNutritionProgress _singleMonthNutritionProgress = MonthNutritionProgress(
    carbs: '0, 0, 0, 0',
    protein: '0, 0, 0, 0',
    fats: '0, 0, 0, 0',
    calories: '0, 0, 0, 0',
    water: '0, 0, 0, 0',
    lastTimeUpdated: '${DateTime.now().toString()}1',
  );

  final MonthNutritionProgress _monthNutritionProgress = MonthNutritionProgress(
    carbs: '0, 0, 0, 0, 0',
    protein: '0, 0, 0, 0, 0',
    fats: '0, 0, 0, 0, 0',
    calories: '0, 0, 0, 0, 0',
    water: '0, 0, 0, 0, 0',
    lastTimeUpdated: '${DateTime.now().toString()}0',
  );

  final WeeklyExerciseProgress _exerciseProgress = WeeklyExerciseProgress(
    cycling: '00:00, 00:00, 00:00, 00:00, 00:00, 00:00, 00:00',
    jogging: '00:00, 00:00, 00:00, 00:00, 00:00, 00:00, 00:00',
    pullUps: '0, 0, 0, 0, 0, 0, 0',
    pushUps: '0, 0, 0, 0, 0, 0, 0',
    sitUps: '0, 0, 0, 0, 0, 0, 0',
    steps: '0, 0, 0, 0, 0, 0, 0',
    lastTimeUpdated: DateTime.now().toString(),
  );

  final WeeklyNutritionProgress _nutritionProgress = WeeklyNutritionProgress(
    carbs: '0, 0, 0, 0, 0, 0, 0',
    protein: '0, 0, 0, 0, 0, 0, 0',
    fats: '0, 0, 0, 0, 0, 0, 0',
    calories: '0, 0, 0, 0, 0, 0, 0',
    water: '0, 0, 0, 0, 0, 0, 0',
    lastTimeUpdated: DateTime.now().toString(),
  );

  final NutritionGoals _newNutritionGoals = NutritionGoals(
    carbs_goals: '225', //average
    protein_goals: '50', //46w and 56m
    fats_goals: '50', //44 - 70
    calorie_goals: '2000',//2k w and 2.5k m
    water_goals: '3000', //2.7w and 3.7m
  );

  final ExerciseGoals _newExerciseGoals = ExerciseGoals(
    cycling_goal: '15:00',
    jogging_goal: '15:00',
    pullUps_gaol: '15',
    pushUps_goal: '25',
    sitUps_goal: '30',
    steps_goal: '10000',
  );

  final Nutrition _newNutrition = Nutrition(
    carbs: "0",
    protein: "0",
    fats: "0",
    calories: "0",
    water: "0",
    lastTimeUpdated: DateTime.now().toString(),
  );

  final Exercises _newExercises = Exercises(
    cycling: "00:00",
    jogging: "00:00",
    pullUps: "0",
    pushUps: "0",
    sitUps: "0",
    steps: "0",
    lastTimeUpdated: DateTime.now().toString(),
  );

  Future registerWithEmailAndPass(UserModel.NewUser newUser) async {
    try{
      //TODO: CHeck if the email already exists not to overwrite the data
      var result = await _auth.createUserWithEmailAndPassword(email: newUser.mail, password: newUser.pass);
      User fUser = result.user;
      await _reference.collection('users').doc(fUser.uid).set(newUser.userInfoToMap());
      await _reference.collection('nutrition').doc(fUser.uid).set(_newNutrition.nutritionInfoToMap());
      await _reference.collection('nutrition_goals').doc(fUser.uid).set(_newNutritionGoals.nutritionGoalsInfoToMap());
      await _reference.collection('exercises').doc(fUser.uid).set(_newExercises.exerciseInfoToMap());
      await _reference.collection('exercise_goals').doc(fUser.uid).set(_newExerciseGoals.exerciseGoalInfoToMap());
      await _reference.collection('nutrition_weekly_progress').doc(fUser.uid).set(_nutritionProgress.nutritionGoalInfoToMap());
      await _reference.collection('exercise_weekly_progress').doc(fUser.uid).set(_exerciseProgress.exerciseGoalInfoToMap());
      await _reference.collection('nutrition_monthly_progress').doc(fUser.uid).set(_monthNutritionProgress.nutritionMonthProgressInfoToMap());
      await _reference.collection('exercise_monthly_progress').doc(fUser.uid).set(_monthExerciseProgress.exerciseMonthProgressInfoToMap());
      await _reference.collection('nutrition_single_month_average').doc(fUser.uid).set(_singleMonthNutritionProgress.nutritionMonthProgressInfoToMap());
      await _reference.collection('exercises_single_month_average').doc(fUser.uid).set(_singleMonthExerciseProgress.exerciseMonthProgressInfoToMap());
      await _reference.collection('meditation').doc(fUser.uid).set(_meditation.statusToMap());

      return fUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
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

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken);

      final result = await _auth.signInWithCredential(credential);
      final User user = result.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      await _googleSignIn.signIn();

      //Create a new user in case of registration needed
      UserModel.NewUser newUser = UserModel.NewUser(
        email: user.email,
        gender: 'Null',
        height: 'Null',
        weight: 'Null',
        age: 'Null',
        username: user.displayName
      );

      //Check if the user already exists in the database
      bool exists = false;
      await _reference.collection('users').get()
      .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((f) {
          if(f.id == user.uid || f.data()['Email'] == user.email) exists = true;
        });
      });

      //Add new user info if there was none prior
      if(!exists){
        await _reference.collection('users').doc(user.uid).set(newUser.userInfoToMap());
        await _reference.collection('nutrition').doc(user.uid).set(_newNutrition.nutritionInfoToMap());
        await _reference.collection('nutrition_goals').doc(user.uid).set(_newNutritionGoals.nutritionGoalsInfoToMap());
        await _reference.collection('exercises').doc(user.uid).set(_newExercises.exerciseInfoToMap());
        await _reference.collection('exercise_goals').doc(user.uid).set(_newExerciseGoals.exerciseGoalInfoToMap());
        await _reference.collection('nutrition_weekly_progress').doc(user.uid).set(_nutritionProgress.nutritionGoalInfoToMap());
        await _reference.collection('exercise_weekly_progress').doc(user.uid).set(_exerciseProgress.exerciseGoalInfoToMap());
        await _reference.collection('nutrition_monthly_progress').doc(user.uid).set(_monthNutritionProgress.nutritionMonthProgressInfoToMap());
        await _reference.collection('exercise_monthly_progress').doc(user.uid).set(_monthExerciseProgress.exerciseMonthProgressInfoToMap());
        await _reference.collection('nutrition_single_month_average').doc(user.uid).set(_singleMonthNutritionProgress.nutritionMonthProgressInfoToMap());
        await _reference.collection('exercises_single_month_average').doc(user.uid).set(_singleMonthExerciseProgress.exerciseMonthProgressInfoToMap());
        await _reference.collection('meditation').doc(user.uid).set(_meditation.statusToMap());
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
        final AuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken.token
        );
        final User user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;

        //Create a new user in case this is the first time user has signed in
        UserModel.NewUser newUser = UserModel.NewUser(
          email: user.email,
          gender: 'Null',
          height: 'Null',
          weight: 'Null',
          age: 'Null',
          username: user.displayName,
        );

        //Check if the user already exists
        bool exists = false;
        await _reference.collection('users').get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((f) {
            if(f.id == user.uid || f.data()['Email'] == user.email) exists = true;
          });
        });

        //Add new user info if there was none prior
        if(!exists){
          await _reference.collection('users').doc(user.uid).set(newUser.userInfoToMap());
          await _reference.collection('nutrition').doc(user.uid).set(_newNutrition.nutritionInfoToMap());
          await _reference.collection('nutrition_goals').doc(user.uid).set(_newNutritionGoals.nutritionGoalsInfoToMap());
          await _reference.collection('exercises').doc(user.uid).set(_newExercises.exerciseInfoToMap());
          await _reference.collection('exercise_goals').doc(user.uid).set(_newExerciseGoals.exerciseGoalInfoToMap());
          await _reference.collection('nutrition_weekly_progress').doc(user.uid).set(_nutritionProgress.nutritionGoalInfoToMap());
          await _reference.collection('exercise_weekly_progress').doc(user.uid).set(_exerciseProgress.exerciseGoalInfoToMap());
          await _reference.collection('nutrition_monthly_progress').doc(user.uid).set(_monthNutritionProgress.nutritionMonthProgressInfoToMap());
          await _reference.collection('exercise_monthly_progress').doc(user.uid).set(_monthExerciseProgress.exerciseMonthProgressInfoToMap());
          await _reference.collection('nutrition_single_month_average').doc(user.uid).set(_singleMonthNutritionProgress.nutritionMonthProgressInfoToMap());
          await _reference.collection('exercises_single_month_average').doc(user.uid).set(_singleMonthExerciseProgress.exerciseMonthProgressInfoToMap());
          await _reference.collection('meditation').doc(user.uid).set(_meditation.statusToMap());
        }

        return user;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOutEmailAndPass() async {
    try {
      await _auth.signOut();
      print('Signed Out From Firebase');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOutFacebook() async {
    try {
      await FacebookLogin().logOut();
      print('Signed Out From Facebook');
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      print('Signed out from Google');
    } catch (e) {
      print(e.toString());
    }
  }
}
