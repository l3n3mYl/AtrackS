import 'dart:async';
import 'package:com/Services/db_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class WalkingScreen extends StatefulWidget {

  final FirebaseUser user;

  WalkingScreen(this.user);

  @override
  _WalkingScreenState createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen>{

  Pedometer _pedometer;
  StreamSubscription<int> _subscription;
  String stepCountVal = '?';
  int resetValue = 0;
  bool reset = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
      DatabaseManagement(widget.user).getSingleFieldInfo('exercises', 'Steps');
//      DatabaseManagement(widget.user).postStepCount(stepCountVal);
    });
  }

  void _onDone() => reset = true;
  void _onError(error) => print('Error: $error');

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.deepOrange,
        child: Center(
          child: Text('Steps: $stepCountVal', style: TextStyle(
            color: Colors.black
          ),),
        )
      ),
    );
  }

}
