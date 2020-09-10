class InputManipulation{

  bool isNumeric(String s) {
    bool numeric = true;
    if(s == null) return false;
    try{
      int.parse(s);
    } catch (e) {
      numeric = false;
    }
    if(numeric) return true;
    else return false;
  }
}