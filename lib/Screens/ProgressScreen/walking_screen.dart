import 'dart:async';
import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WalkingScreen extends StatefulWidget {

  final FirebaseUser user;

  WalkingScreen(this.user);

  @override
  _WalkingScreenState createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen>{

  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  DatabaseManagement _management;
  String stepCountVal = '?';
  String stepGoal = '0';
  String totalSteps = '0';
  int resetValue = 0;
  bool reset = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getTotalSteps();
    getStepGoal();
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  void startListening() {
    _pedometer = new Pedometer();
    _subscription = _pedometer.pedometerStream.listen(_onData, onError: _onError,
        onDone: _onDone, cancelOnError: true);
  }

  void _onData(int newValue) async {
    if(reset) {
      resetValue += newValue;
      reset = false;
    }
    setState(() {
      stepCountVal = "${newValue - resetValue}";
    });
  }

  void _onDone() async {
    reset = true;
    _management = new DatabaseManagement(widget.user);
    String sumOfValues = (int.parse(totalSteps) + int.parse(stepCountVal)).toString();
    await _management.updateSingleField('exercises', 'Steps', sumOfValues);

  }

  void getTotalSteps() async {
    try{
      _management = new DatabaseManagement(widget.user);
      await _management.getSingleFieldInfo(
        'exercises', 'Steps').then((result) {
          setState(() {
            totalSteps = result;
          });
      });
    }catch(e){
      print('Error ${e.toString()}');
    }
  }

   void getStepGoal() async {
    try{
      _management = new DatabaseManagement(widget.user);
      await _management.getSingleFieldInfo(
        'exercise_goals', 'Steps_Goal').then((result){
          setState(() {
            stepGoal = result;
          });
      });
    }catch(e){
      print(e.toString());
    }
  }

  void _onError(error) => print('Error: $error');

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _onDone();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text('Steps: $stepCountVal', style: TextStyle(
                color: Colors.black
              ),),
            ),
            Container(
              width: 256,
              height: 256,
              child: CircularPercentIndicator(
                backgroundColor: Colors.black,
                radius: 100.0,
                progressColor: Colors.white,
                lineWidth: 2.0,
                animationDuration: 20,
                percent: stepGoal == null && totalSteps == null ? 0.01 : (double.parse(totalSteps) * 100 / double.parse(stepGoal)) / 100,
                animation: true,
                center: Icon(
                  FontAwesomeIcons.infinity,
                  color: Colors.white,
                  size: 50.0,
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text('Stop'),
                onPressed: () => _onDone(),
              ),
            )
          ],
        )
      ),
    );
  }
}
