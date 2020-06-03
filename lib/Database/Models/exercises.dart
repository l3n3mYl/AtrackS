class Exercises{
  String cycling, jogging, pullUps, sitUps, pushUps, steps;
  DateTime lastTimeUpdated;

  get timeUpdated {
    return this.timeUpdated;
  }

  set timeUpdated(DateTime newTime) {
    this.timeUpdated = newTime;
  }

  get cyclingMin {
    return this.cycling;
  }

  set cyclingMin (String minutes){
    this.cycling = minutes;
  }

  get joggingMin {
    return this.jogging;
  }

  set joggingMin (String minutes){
    this.jogging = minutes;
  }

  get pullUpTimes {
    return this.pullUps;
  }

  set pullUpTimes (String times) {
    this.pullUps = times;
  }

  get sitUpTimes {
    return this.sitUps;
  }

  set sitUpTimes (String times){
    this.sitUps = times;
  }

  get pushUpTimes {
    return this.pushUps;
  }

  set pushUpTimes (String times){
    this.pushUps = times;
  }

  get stepCount {
    return this.steps;
  }

  set stepCount (String steps) {
    this.steps = steps;
  }

  Map<String, Object> exerciseInfoToMap(){
    Map<String, Object> info = {
      "Cycling" : cyclingMin,
      "Jogging" : joggingMin,
      "Pull-Ups" : pullUpTimes,
      "Sit-Ups" : sitUpTimes,
      "Push-ups" : pushUpTimes,
      "Steps" : stepCount,
      "LastUpdated" : timeUpdated,
    };

    return info;
  }

  Exercises({this.cycling, this.jogging, this.pullUps, this.pushUps, this.sitUps, this.steps});

}