class WeeklyExerciseProgress{
  String cycling, jogging, pullUps, sitUps, pushUps, steps;
  String lastTimeUpdated;

  get timeUpdated {
    return this.lastTimeUpdated;
  }

  set timeUpdated(String newTime) {
    this.lastTimeUpdated = newTime;
  }

  get cyclingProgress {
    return this.cycling;
  }

  set cyclingProgress (String minutes){
    this.cycling = minutes;
  }

  get joggingProgress {
    return this.jogging;
  }

  set joggingProgress (String minutes){
    this.jogging = minutes;
  }

  get pullUpTimesProgress {
    return this.pullUps;
  }

  set pullUpTimesProgress (String times) {
    this.pullUps = times;
  }

  get sitUpTimesProgress {
    return this.sitUps;
  }

  set sitUpTimesProgress (String times){
    this.sitUps = times;
  }

  get pushUpTimesProgress {
    return this.pushUps;
  }

  set pushUpTimesProgress (String times){
    this.pushUps = times;
  }

  get stepCountProgress {
    return this.steps;
  }

  set stepCountProgress (String steps) {
    this.steps = steps;
  }

  Map<String, Object> exerciseGoalInfoToMap(){
    Map<String, Object> info = {
      "Cycling" : cyclingProgress,
      "Jogging" : joggingProgress,
      "Pull-Ups" : pullUpTimesProgress,
      "Sit-Ups" : sitUpTimesProgress,
      "Push-ups" : pushUpTimesProgress,
      "Steps" : stepCountProgress,
      "LastUpdated" : lastTimeUpdated,
    };

    return info;
  }
  WeeklyExerciseProgress({this.cycling, this.jogging, this.pullUps, this.pushUps, this.sitUps, this.steps, this.lastTimeUpdated});

}