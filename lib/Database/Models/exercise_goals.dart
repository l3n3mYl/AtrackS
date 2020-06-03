class ExerciseGoals{
  String cycling_goal, jogging_goal, pullUps_gaol, sitUps_goal, pushUps_goal, steps_goal;

  get cyclingGoal {
    return this.cycling_goal;
  }

  set cyclingGoal (String minutes){
    this.cycling_goal = minutes;
  }

  get joggingGoal {
    return this.jogging_goal;
  }

  set joggingGoal (String minutes){
    this.jogging_goal = minutes;
  }

  get pullUpTimesGoal {
    return this.pullUps_gaol;
  }

  set pullUpTimesGoal (String times) {
    this.pullUps_gaol = times;
  }

  get sitUpTimesGoal {
    return this.sitUps_goal;
  }

  set sitUpTimesGoal (String times){
    this.sitUps_goal = times;
  }

  get pushUpTimesGoal {
    return this.pushUps_goal;
  }

  set pushUpTimesGoal (String times){
    this.pushUps_goal = times;
  }

  get stepCountGoal {
    return this.steps_goal;
  }

  set stepCountGoal (String steps) {
    this.steps_goal = steps;
  }

  Map<String, Object> exerciseGoalInfoToMap(){
    Map<String, Object> info = {
      "Cycling_Goal" : cyclingGoal,
      "Jogging_Goal" : joggingGoal,
      "Pull-Ups_Goal" : pullUpTimesGoal,
      "Sit-Ups_Goal" : sitUpTimesGoal,
      "Push-Ups_Goal" : pushUpTimesGoal,
      "Steps_Goal" : stepCountGoal,
    };

    return info;
  }

  ExerciseGoals({this.cycling_goal, this.jogging_goal, this.pullUps_gaol, this.pushUps_goal, this.sitUps_goal, this.steps_goal});

}