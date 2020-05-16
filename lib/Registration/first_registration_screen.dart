import 'package:com/Models/user.dart';
import 'package:com/Registration/final_registration_screen.dart';
import 'package:flutter/material.dart';

final Color mainColor = Color.fromRGBO(71, 68, 70, 1);
final Color textColor = Color.fromRGBO(163, 149, 135, 1);
final Color accentColor = Color.fromRGBO(213, 1, 1, 1);

class FirstRegistrationScreen extends StatefulWidget {

  @override
  _FirstRegistrationScreenState createState() => _FirstRegistrationScreenState();
}

class _FirstRegistrationScreenState extends State<FirstRegistrationScreen> {
  User _user = new User();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: mainColor,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    validator: (usernameField) {
                      if(usernameField.isEmpty) return 'This Field Is Required';
                      else return null;
                    },
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: textColor,
                    ),
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor))),
                    onChanged: (usernameField){
                      _user.name = usernameField;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    validator: (passwordField) {
                      if(passwordField.isEmpty) return 'This Field Is Required';
                      if(passwordField.length < 5) return 'Passwords must be at least 6 chars long';
                      else return null;
                    },
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: textColor,
                    ),
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor))),
                    onChanged: (passwordField){
                      _user.pass = passwordField;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    validator: (repPassField) {
                      if(repPassField != _user.password) return 'Password Must Match';
                      else return null;
                    },
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: textColor,
                    ),
                    cursorColor: accentColor,
                    decoration: InputDecoration(
                        hintText: 'Repeat Password',
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor))),
                    onChanged: (repPassField){},
                  ),
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  child: Text('Next'),
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      print(_user.name);
                      print(_user.pass);
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => FinalRegistrationScreen(_user)));
                    }
                  },
                ),
                RaisedButton(
                  child: Text('skip'),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FinalRegistrationScreen(_user))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


