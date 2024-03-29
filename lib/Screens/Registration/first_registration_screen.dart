import 'package:com/Database/Models/user.dart';
import 'package:com/Screens/Registration/final_registration_screen.dart';
import 'package:com/SecretMenu/menu_management.dart';
import 'package:com/Database/Services/auth.dart';
import 'package:com/Utilities/input_manipulation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final Color mainColor = Color.fromRGBO(71, 68, 70, 1);
final Color textColor = Color.fromRGBO(163, 149, 135, 1);
final Color accentColor = Color.fromRGBO(213, 1, 1, 1);

class FirstRegistrationScreen extends StatefulWidget {

  @override
  _FirstRegistrationScreenState createState() => _FirstRegistrationScreenState();
}

class _FirstRegistrationScreenState extends State<FirstRegistrationScreen> {
  NewUser _user = new NewUser();
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  final InputManipulation _input = new InputManipulation();
  final double btnSize = 40.0;

  // bool isNumeric(String s){
  //   bool numeric = true;
  //   if(s == null) return false;
  //   try{
  //     int.parse(s);
  //   } catch (error) {
  //     numeric = false;
  //   }
  //   if(numeric) return true;
  //   else return false;
  // }

  String error = '';

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
                            validator: (usernameField) {
                              if(usernameField.isEmpty) return 'This Field Is Required';
                              else return null;
                            },
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: TextStyle(color: textColor,
                                fontFamily: 'PTSerif',
                                fontSize: 18,
                                fontWeight: FontWeight.w200
                            ),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: 'Username',
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
                            onChanged: (usernameField){
                              _user.name = usernameField;
                            },
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 55.0),
                          child: TextFormField(
                            validator: (passwordField) {
                              if(passwordField.isEmpty) return 'This Field Is Required';
                              if(passwordField.length < 5) return 'Password must be at least 6 chars long';
                              else return null;
                            },
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            style: TextStyle(color: textColor,
                                fontFamily: 'PTSerif',
                                fontSize: 18,
                                fontWeight: FontWeight.w200
                            ),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: 'Password',
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
                            onChanged: (passwordField){
                              _user.pass = passwordField;
                            },
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 55.0),
                          child: TextFormField(
                            validator: (repPassField) {
                              if(repPassField != _user.password) return 'Passwords Must Match';
                              else return null;
                            },
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            style: TextStyle(color: textColor,
                                fontFamily: 'PTSerif',
                                fontSize: 18,
                                fontWeight: FontWeight.w200
                            ),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: 'Repeat Password',
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
                            onChanged: (repPassField){},
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 55.0),
                          child: TextFormField(
                            validator: (ageField) {
                              if(ageField.isNotEmpty){
                                if(!_input.isNumeric(ageField)) return 'Wrong format';
                                if(int.parse(ageField) < 3 || int.parse(ageField) >= 99) return 'Leave the field empty or enter a valid age';
                                else return null;
                              }
                              else return null;
                            },
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: textColor,
                                fontFamily: 'PTSerif',
                                fontSize: 18,
                                fontWeight: FontWeight.w200
                            ),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: 'Age (Optional)',
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
                            onChanged: (ageField){
                              if(ageField.isEmpty){
                                _user.setAge = "0";
                              } else _user.setAge = ageField;
                            },
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
                        SizedBox(height: 20.0,),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      FinalRegistrationScreen(_user)));
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
                                      'Next',
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
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


