import 'package:com/Models/user.dart';
import 'package:com/SecretMenu/menu_management.dart';
import 'package:com/Services/auth.dart';
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

  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String dropDownValue = 'Male';
  String error = '';

  bool isNumeric(String s){
    bool numeric = true;
    if(s == null) return false;
    try{
      double.parse(s);
    } catch (error) {
      numeric = false;
    }
    if(numeric) return true;
    else return false;
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
                      if(weightField.isNotEmpty){
                        if(!isNumeric(weightField)) return 'OnlyNumbers';
                        if(double.parse(weightField) < 0 || double.parse(weightField) >= 200.0) return 'Leave the field empty or enter a valid weight';
                        else return null;
                      }
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
                      if(weightField.isEmpty){
                        widget.user.w = "0";
                      } else widget.user.w = weightField;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: TextFormField(
                    validator: (heightField) {
                      if(heightField.isNotEmpty){
                        if(!isNumeric(heightField)) return 'OnlyNumbers';
                        if(double.parse(heightField) < 0 || double.parse(heightField) >= 269.9) return 'Leave the field empty or enter a valid height';
                        else return null;
                      }
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
                        hintText: 'Height in cm (Optional)',
                        hintStyle: TextStyle(color: textColor),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor)),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: accentColor))),
                    onChanged: (heightField){
                      if(heightField.isEmpty){
                        widget.user.h = "0";
                      } else widget.user.h = heightField;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55.0),
                  child: DropdownButton<String>(
                    hint: Text('Gender'),
                    value: dropDownValue,
                    items: <String>[
                      'Male',
                      'Female',
                      'Mental',
                    ].map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (gender) {
                      widget.user.g = gender;
                      setState(() {
                        dropDownValue = gender;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  child: Text('Register'),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      dynamic result = await _auth.registerWithEmailAndPass(widget.user);
                      if(result != null) Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainScreen()));
                      else {
                        setState(() {
                          error = 'This email address is already taken or wrongly formated';
                        });
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
