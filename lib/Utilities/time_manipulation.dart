class TimeManipulation {

  String timeAddition(String time1, String time2) {
    String sec = time1.split(':')[1];
    String min = time1.split(':')[0];
    String curSec = time2.split(':')[1];
    String curMin = time2.split(':')[0];
    String finalSec = (int.parse(sec) + int.parse(curSec)).toString();
    String finalMin = (int.parse(min) + int.parse(curMin)).toString();

    if(int.parse(finalSec) > 59) {
      finalMin = (int.parse(finalMin) + int.parse(finalSec) ~/ 60).toString();
      finalSec = (int.parse(finalSec) % 60).toString();
    }
    if (int.parse(finalSec) < 10) finalSec = '0$finalSec';
    if (int.parse(finalMin) < 10) finalMin = '0$finalMin';

    return '$finalMin:$finalSec';
  }

  double timeToDouble(String time){
    try{
      return double.parse('${time.split(':')[0]}.${time.split(':')[1]}');
    } catch (e) {
      e.toString();
      return double.parse('0.0');
    }
  }

  String doubleToStringTime(double time) {
    try{
      String min = time.toInt().toString();
      String sec = time.toString().split('.')[1];

      if(int.parse(sec) > 59){
        min = (int.parse(min) + int.parse(sec) ~/ 60).toString();
        sec = (int.parse(sec) % 60).toString();
      }
      if(int.parse(min) < 10) min = '0$min';
      if(sec.length < 2) sec = '$sec\0';

      return '$min:$sec';
    } catch (e) {
      print(e);
      return null;
    }
  }
}