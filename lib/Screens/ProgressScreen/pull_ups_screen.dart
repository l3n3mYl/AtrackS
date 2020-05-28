import 'dart:async';
import 'package:com/Database/Services/db_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class PullUpsScreen extends StatefulWidget {

  final FirebaseUser user;

  PullUpsScreen(this.user);

  @override
  _PullUpsScreenState createState() => _PullUpsScreenState();
}

class _PullUpsScreenState extends State<PullUpsScreen>{

  Pedometer _pedometer;
  DatabaseManagement _management;
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
    });
  }

  void _onDone() async {
    reset = true;
    _management = new DatabaseManagement(widget.user);
    String oldDbValue = await _management.getSingleFieldInfo('exercises', 'Steps');
    String sumOfValues = (int.parse(oldDbValue) + int.parse(stepCountVal)).toString();
    await _management.updateSingleField('exercises', 'Steps', sumOfValues);
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
          color: Colors.transparent,
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
