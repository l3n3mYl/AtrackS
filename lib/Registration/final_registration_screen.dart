import 'package:com/Models/user.dart';
import 'package:com/SecretMenu/menu_management.dart';
import 'package:com/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final AuthService _authService = AuthService();
  final double btnSize = 40.0;
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;


    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: _width,
              height: _height,
              color: mainColor,
            ),
            Container(
              width: _width,
              height: _height,
              child: AspectRatio(
                aspectRatio: 18 / 9,
                child: Opacity(
                  opacity: 0.2,
                  child: Image(
                    image: AssetImage('images/main_pattern.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: _width,
              height: _height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                      child: Center(
                          child: Container(
                              width: 190,
                              height: 190,
                              child: Image.asset('images/logo.png'))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: btnSize,
                          height: btnSize,
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: textColor),
                          child: RawMaterialButton(
                            onPressed: () async {
                              dynamic auth = await _authService.signInFacebook();
                              if (auth != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => MainScreen(auth)));
                              } else {
                                setState(() {
                                  error = 'There was an error with Facebook';
                                });
                              }
                            },
                            child: Icon(
                              FontAwesomeIcons.facebookF,
                              color: textColor,
                              size: 22,
                            ),
                            shape: CircleBorder(),
                            fillColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 60.0,
                        ),
                        Container(
                          width: btnSize,
                          height: btnSize,
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: textColor),
                          child: RawMaterialButton(
                            onPressed: () async {
                              dynamic auth =
                              await _authService.signInGooglePlus();
                              if (auth != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => MainScreen(auth)));
                              } else {
                                setState(() {
                                  error = 'There was an error with Google+';
                                });
                              }
                            },
                            child: Center(
                                child: Icon(
                                  FontAwesomeIcons.googlePlusG,
                                  color: textColor,
                                  size: 23,
                                )),
                            shape: CircleBorder(),
                            fillColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Form(
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
                              style: TextStyle(color: textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200
                              ),
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
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
                          SizedBox(
                            height: 20.0,
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
                              style: TextStyle(color: textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200
                              ),
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  hintText: 'Repeat Email Address',
                                  hintStyle: TextStyle(color: textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: accentColor)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: accentColor)),
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: accentColor))),
                              onChanged: (emailField){},
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
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
                              style: TextStyle(color: textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200
                              ),
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  hintText: 'Weight in kg (Optional)',
                                  hintStyle: TextStyle(color: textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
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
                          SizedBox(
                            height: 20.0,
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
                              style: TextStyle(color: textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200
                              ),
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  hintText: 'Height in cm (Optional)',
                                  hintStyle: TextStyle(color: textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
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
                          SizedBox(
                            height: 20.0,
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
                          GestureDetector(
                            onTap: () async {
                              if(_formKey.currentState.validate()){
                                dynamic result = await _authService.registerWithEmailAndPass(widget.user);
                                if(result != null) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen(result)));
                                }
                                else {
                                  setState(() {
                                    error = 'This email address is already taken or wrongly formated';
                                  });
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25.0),
                              child: Container(
                                width: 219,
                                height: 42,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(56.0),
                                    color: textColor),
                                child: Container(
                                  margin: const EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(56.0),
                                      color: Colors.black),
                                  child: Center(
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                            color: textColor,
                                            fontFamily: 'PTSerif',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w200
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red.shade700,
                                fontFamily: 'PTSerif',
                                fontSize: 13,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
