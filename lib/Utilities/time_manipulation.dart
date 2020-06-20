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

  double timeToString(String time){
    try{
      return double.parse('${time.split(':')[0]}.${time.split(':')[1]}');
    } catch (e) {
      e.toString();
      return double.parse('0.0');
    }
  }
}