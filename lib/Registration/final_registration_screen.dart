import 'package:com/Models/user.dart';
import 'package:flutter/material.dart';

final Color mainColor = Color.fromRGBO(71, 68, 70, 1);
final Color textColor = Color.fromRGBO(163, 149, 135, 1);
final Color accentColor = Color.fromRGBO(213, 1, 1, 1);

class FinalRegistrationScreen extends StatefulWidget {
  final User user;
  FinalRegistrationScreen(this.user);


  @override
  _FinalRegistrationScreenState createState() => _FinalRegistrationScreenState();
}

class _FinalRegistrationScreenState extends State<FinalRegistrationScreen> {

  final GlobalKey _formKey = new GlobalKey();

  bool isNumeric(String s){
    if(s == null) return false;
    try{
      return double.parse(s) != null;
    } catch (e) {
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: mainColor,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                      validator: (emailField) {
                        if(emailField.isEmpty) return 'This Field Is Required';
                        else if(!emailField.contains('@')) return 'Enter a valid email address';
                        else return null;
                      },
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: textColor,
                      ),
                      cursorColor: accentColor,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: textColor),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor))),
                      onChanged: (emailField){
                        widget.user.mail = emailField;
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    validator: (emailField) {
                      if(emailField.isEmpty) return 'This Field Is Required';
                      else if(!emailField.contains('@')) return 'Enter a valid email address';
                      else if(widget.user.mail != emailField) return 'Email addresseses must match';
                      else return null;
                    },
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: textColor,
                    ),
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                        hintText: 'Repeat Email Address',
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor))),
                    onChanged: (emailField){},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    validator: (weightField) {
                      if(double.parse(weightField) < 0 || double.parse(weightField) >= 200.0) return 'Leave the field empty or enter a valid weight';
                      else if(isNumeric(weightField)) return 'Only numbers';
                      else return null;
                    },
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: textColor,
                    ),
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                        hintText: 'Weight in kg (Optional)',
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor))),
                    onChanged: (weightField){
                      widget.user.w = weightField;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    validator: (heightField) {
                      if(double.parse(heightField) < 0 || double.parse(heightField) >= 269.9) return 'Leave the field empty or enter a valid height';
                      else if(isNumeric(heightField)) return 'Only numbers';
                      else return null;
                    },
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: textColor,
                    ),
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                        hintText: 'Weight in kg (Optional)',
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor))),
                    onChanged: (heightField){
                      widget.user.h = heightField;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: DropdownButton<String>(
                    items: [
                      DropdownMenuItem(
                        value: "M",
                        child: Text("Male"),
                      ),
                      DropdownMenuItem(
                        value: "F",
                        child: Text("Female"),
                      ),
                      DropdownMenuItem(
                        value: "MENTAL",
                        child: Text("Mental Illness"),
                      )
                    ],
                    onChanged: (gender) {
                      widget.user.g = gender;
                    },
                  ),
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  child: Text('Register'),
                  onPressed: () {
                    print(widget.user.name);
                    print(widget.user.pass);
                    print(widget.user.mail);
                    print(widget.user.w);
                    print(widget.user.h);
                    print(widget.user.g);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
