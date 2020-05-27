class User{
  String username, password, email, weight, height, gender;

  get name {
    return this.username;
  }

  set name (String username){
    this.username = username;
  }

  get pass {
    return this.password;
  }

  set pass (String password){
    this.password = password;
  }

  get mail {
    return this.email;
  }

  set mail (String email) {
    this.email = email;
  }

  get w {
    return this.weight;
  }

  set w (String weight){
    this.weight = weight;
  }

  get h {
    return this.height;
  }

  set h (String height){
    this.height = height;
  }

  get g {
    return this.gender;
  }

  set g (String gender) {
    this.gender = gender;
  }

  Map<String, Object> userInfoToMap(){
    Map<String, Object> stats = {
      "Username" : name,
      "Email" : mail,
      "Weight" : w,
      "Height" : h,
      "Gender" : g
    };

    return stats;
  }

  User({this.username, this.password, this.email, this.weight, this.height, this.gender});

}