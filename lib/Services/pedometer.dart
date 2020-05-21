import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart' as AccelerometerEvents;
import 'package:sensors/sensors.dart';

abstract class StepListener{
  void step(int timeNs);
}

class SensorFilter {

  SensorFilter();

  Float sum(List<Float> array){
    double retval = 0 as double;
    for (var i = 0; i < array.length; ++i){
      retval += array[i] as double;
    }

    Float fRetval = retval as Float;

    return fRetval;
  }

  List<double> cross(List<double> listA, List<double> listB){
    List<double> retList = new List(3);
    retList[0] = listA[1] * listB[2] - listA[2] * listB[1];
    retList[1] = listA[2] * listB[0] - listA[0] * listB[2];
    retList[2] = listA[0] * listB[1] - listA[1] * listB[0];

    return retList;
  }

  double norm(List<double> list){
    double retval = 0;
    for(var i = 0; i < list.length; ++i){
      retval += list[i] * list[i];
    }

    return sqrt(retval);
  }

  double dot(List<double> a, List<double> b){
    double retval = a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
    return retval;
  }

  List<double> normalize(List<double> a){
    List<double> retval = new List(a.length);
    double normal = norm(a);
    for(var i = 0; i < a.length; ++i) {
      retval[i] = a[i] / normal;
    }
    return retval;
  }

}

class StepDetector {
  static int accelRingSize = 50;
  static int velRingSize = 10;

  final double stepThreshold = 50 as double;
  final int stepDelayMs = 250000000;

  int accelRingCounter = 0;
  int velRingCounter = 0;
  int lastStepTimeMs = 0;
  double oldVelocityEstimate = 0;
  List<Float> velRing = new List(velRingSize);
  List<Float> accelRingX = new List(accelRingSize);
  List<Float> accelRingY = new List(accelRingSize);
  List<Float> accelRingZ = new List(accelRingSize);

  StepListener listener;

  void updateAccel(int timeNs, double x, double y, double z){
    List<double> currentAccel = new List(3);
    currentAccel[0] = x;
    currentAccel[1] = y;
    currentAccel[2] = z;
    accelRingCounter++;
    accelRingX[accelRingCounter % accelRingSize] = currentAccel[0] as Float;
    accelRingY[accelRingCounter % accelRingSize] = currentAccel[1] as Float;
    accelRingZ[accelRingCounter % accelRingSize] = currentAccel[2] as Float;

    List<double> worldZ = new List(3);
    worldZ[0] = (SensorFilter().sum(accelRingX) as double) / min(accelRingCounter, accelRingSize);
    worldZ[1] = (SensorFilter().sum(accelRingY) as double) / min(accelRingCounter, accelRingSize);
    worldZ[2] = (SensorFilter().sum(accelRingZ) as double) / min(accelRingCounter, accelRingSize);

    double normalizationFactor = SensorFilter().norm(worldZ);

    worldZ[0] /= normalizationFactor;
    worldZ[1] /= normalizationFactor;
    worldZ[2] /= normalizationFactor;

    Float currentZ = SensorFilter().dot(worldZ, currentAccel) - normalizationFactor as Float;
    velRingCounter++;
    velRing[velRingCounter % velRingSize] = currentZ;
    double velocityEstimate = SensorFilter().sum(velRing) as double;

    if(velocityEstimate > stepThreshold && oldVelocityEstimate <= stepThreshold
        && (timeNs - lastStepTimeMs > stepDelayMs)){
      listener.step(timeNs);
      lastStepTimeMs = timeNs;
    }
    oldVelocityEstimate = velocityEstimate;
  }
}

final Screen pedomedo = new Screen(
  title: 'Pedomedo',
  contentBuilder: (ctx) => PedometerScreen()
);

class PedometerScreen extends StatefulWidget {
  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {

  AccelerometerEvent accelerometerEvent;
  StreamSubscription _subscription;
  
  static const int shakeRows = 20;
  static const int shakeColumns = 20;
  static const double shakeCellSize = 10.0;

  List<double> accelerometerValues;
  
  List<StreamSubscription<dynamic>> streamSubs = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamSubs.add(AccelerometerEvents.accelerometerEvents.listen((AccelerometerEvents.AccelerometerEvent event) {
      setState(() {
        accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for(StreamSubscription<dynamic> subscription in streamSubs){
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<String> accelerometer = accelerometerValues?.map((double v) => v.toStringAsFixed(1))?.toList();

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Text('Acceleromeerer: $accelerometer')
          ],
        ),
      ),
    );
  }
}
