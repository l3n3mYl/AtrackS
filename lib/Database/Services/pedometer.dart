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
  //TODO check and tidy
  Stream<StepCount> _stepCountStream;
  String _steps = '?';
//  String stepCountVal = '?';
  int resetValue = 0;
  bool reset = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

//  void onPedestrianStatusChange(PedestrianStatus event) {
//    setState(() {
//      _status = event.status;
//    });
//  }

//  void onPedestrianStatusError(error) {
//    print('Pedestrian Status Error: $error');
//    setState(() {
//      _status = 'Pedestrian Status Not Available';
//    });
//  }

  void onStepCountError(error) {
    print('Step Count Error: $error');
//    setState(() {
//      _status = 'Step Count Not Available';
//    });
  }

  Future<void> initPlatformState() async {
//    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
//    _pedestrianStatusStream.listen(onPedestrianStatusChange)
//      .onError(onPedestrianStatusError);

    _stepCountStream = await Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if(!mounted) return;
  }

//  void onData(int stepCountValue){
////    print(stepCountValue);
////  }

//  Stream onData(Stream event){
//    print(event);
//  }

//  void startListening() {
//    _subscription = Pedometer.stepCountStream.asStream().listen(onData).onData(_onData);
////    _subscription = _pedometer.pedometerStream.listen(_onData, onError: _onError,
////        onDone: _onDone, cancelOnError: true);
//  }

//  Stream _onData(Stream event) {
//
//  }

//  void _onData(int newValue) async {
//    if(reset) {
//      resetValue += newValue;
//      reset = false;
//    }
//    setState(() {
//      stepCountVal = "${newValue - resetValue}";
//    });
//  }

//  void _onDone() => reset = true;
//  void _onError(error) => print('Error: $error');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Steps: $_steps'),
          ],
        ),
      ),
    );
  }

}
