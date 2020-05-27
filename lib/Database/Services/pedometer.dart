import 'dart:async';

import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

final Screen pedomedo = new Screen(
  title: 'Pedomedo',
  contentBuilder: (ctx) => PedometerScreen()
);

class PedometerScreen extends StatefulWidget {
  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen>{

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

  void onData(int stepCountValue){
    print(stepCountValue);
  }

  void startListening() {
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
        child: Column(
          children: <Widget>[
            Text('Steps: ${stepCountVal}'),
          ],
        ),
      ),
    );
  }

}
