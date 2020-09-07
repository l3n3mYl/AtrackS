class ExerciseJsonManipulation {

  ExerciseJsonManipulation();

  Map<String, Map<String, dynamic>> encodeMap(Map<String, Map<String, dynamic>> map) {
    Map<String, Map<String, dynamic>> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });

    return newMap;
  }
}