class Meditation {
  String current, goal, lastUpdated, weeklyStatus;

  get currentTime {
    return this.current;
  }

  set currentTime(String time) {
    this.current = time;
  }

  get currentGoal {
    return this.goal;
  }

  set currentGoal(String newGoal) {
    this.goal = newGoal;
  }

  get lastUpdatedTime {
    return this.lastUpdated;
  }

  set lastUpdatedTime(String time) {
    this.lastUpdated = time;
  }

  get weeklyProgressStatus {
    return this.weeklyStatus;
  }

  set weeklyProgressStatus(String progress) {
    this.weeklyStatus = progress;
  }

  Map<String, Object> statusToMap() {
    Map<String, Object> info = {
      'Current': currentTime,
      'Goal': currentGoal,
      'WeeklyStatus': weeklyProgressStatus,
      'LastUpdated': lastUpdatedTime,
    };

    return info;
  }

  Meditation({this.current, this.goal, this.lastUpdated, this.weeklyStatus});
}