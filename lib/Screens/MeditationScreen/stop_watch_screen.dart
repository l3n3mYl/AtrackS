import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:com/Design/colours.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StopWatch extends StatefulWidget {
  final String goal;

  StopWatch(this.goal);

  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  bool startBtn = true;
  bool isStart = true;
  bool isStop = true;
  bool isReset = true;
  double percent = 0.00;
  String btnName = 'Start';
  String time = '00:00';
  var swatch = Stopwatch();
  final duration = const Duration(seconds: 1);

  void getGoal() {
    var goalMin = int.parse(widget.goal.split(':')[0]);
    var goalSec = int.parse(widget.goal.split(':')[1]);
    var finalGoalTime = (goalMin * 60) + goalSec;

    var currMin = int.parse(this.time.split(':')[0]);
    var currSec = int.parse(this.time.split(':')[1]);
    var finalCurrTime = currMin * 60 + currSec;
    setState(() {
      if (finalCurrTime <= 0.0)
        percent = 0.0;
      else {
        percent = finalCurrTime / finalGoalTime;
        if (percent >= 1.0) {
          percent = 1.0;
        }
      }
    });
  }

  void completedSound() async {
    AudioCache ac = AudioCache();
    try{
      await ac.play('Sounds/metal-gong.mp3');
    } catch (e) {
      print(e.toString());
    }
  }

  void startTimer() {
    Timer(duration, running);
  }

  void running() {
    if (swatch.isRunning) {
      startTimer();
      getGoal();
    }
    setState(() {
      time = (swatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
          ':' +
          (swatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
      if(time == widget.goal) {
        completedSound();
      }
      if (time == '59:59') stop();
    });
  }

  void start() {
    setState(() {
      isStop = false;
      isStart = false;
    });
    swatch.start();
    startTimer();
  }

  void stop() async {
    setState(() {
      isStop = true;
      isReset = false;
    });
    swatch.stop();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context, time);
    });
  }

  void reset() {
    setState(() {
      isStart = true;
      isReset = true;
    });
    swatch.reset();
    time = '00:00';
  }

  @override
  void initState() {
    super.initState();
    getGoal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.black,
            Colors.black,
            Colors.black,
            Colors.black,
            mainColor,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(
                  alignment: Alignment.center,
                  child: CircularPercentIndicator(
                    radius: 300.0,
                    progressColor: Colors.red.shade900,
                    backgroundColor: Colors.white,
                    percent:
                    percent <= 0.0 ? 0.0 : percent >= 1.0 ? 1.0 : percent,
                    center: Text(
                      time,
                      style: TextStyle(
                          fontSize: 66.0,
                          color: Colors.white,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.only(bottom: 48.0),
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            if (startBtn) {
                              setState(() {
                                btnName = 'Stop';
                                startBtn = false;
                                start();
                              });
                            } else {
                              setState(() {
                                btnName = 'Start';
                                stop();
                              });
                            }
                          },
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              width: 120.0,
                              height: 120.0,
                              child: startBtn
                                  ? Center(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  margin: EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.black,
                                            Colors.black87,
                                            Colors.black54
                                          ]
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(123.0)),
                                  padding:
                                  const EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    FontAwesomeIcons.play,
                                    color: Colors.grey.shade300,
                                    size: 50.0,
                                  ),
                                ),
                              )
                                  : Center(
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  margin: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.black,
                                            Colors.black87,
                                            Colors.black54
                                          ]
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(123.0)),
                                  child: Icon(
                                    FontAwesomeIcons.stop,
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(123.0),
                                  color: textColor),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: reset,
                          child: Container(
                            width: 69.0,
                            height: 69.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(123.0),
                                color: textColor
                            ),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(right: 2.5),
                                width: double.infinity,
                                height: double.infinity,
                                margin: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black,
                                          Colors.black,
                                          Colors.black87,
                                          Colors.black54
                                        ]
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(123.0)),
                                child: Icon(
                                  FontAwesomeIcons.backward,
                                  color: Colors.grey.shade300,
                                  size: 40.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
