import 'package:com/Registration/first_registration_screen.dart';
import 'package:com/SecretMenu/menu_management.dart';
import 'package:com/Services/auth.dart';
import 'package:com/UiComponents/swipe_button.dart';
import 'package:com/main.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final double btnSize = 40.0;

class SignInScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  Widget awaitResult() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    String email = '';
    String password = '';
    String error = '';

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
                  Text(
                    error,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: btnSize,
                        height: btnSize,
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: textColor),
                        child: RawMaterialButton(
                          onPressed: () async {
                            dynamic auth = await _authService.signInFacebook();
                            if (auth != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MainScreen(auth)));
                            } else {
                              error = 'There was an error with Facebook';
                            }
                          },
                          child: Icon(
                            FontAwesomeIcons.facebookF,
                            color: textColor,
                            size: 23,
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
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: textColor),
                        child: RawMaterialButton(
                          onPressed: () async {
                            dynamic auth = await _authService.signInGooglePlus();
                            if (auth != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => MainScreen(auth)));
                            } else {
                              error = 'There was an error with Google+';
                            }
                          },
                          child: Center(
                              child: Icon(
                            FontAwesomeIcons.googlePlusG,
                            color: textColor,
                            size: 25,
                          )),
                          shape: CircleBorder(),
                          fillColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 55.0),
                    child: TextField(
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: textColor,
                      ),
                      cursorColor: accentColor,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: textColor, fontSize: 18.0),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor))),
                      onChanged: (input) {
                        email = input.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 55.0),
                    child: TextField(
                      obscureText: true,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: textColor,
                      ),
                      cursorColor: accentColor,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: textColor, fontSize: 18.0),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: accentColor))),
                      onChanged: (input) {
                        password = input.toString();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                    child: SwipeButton(
                      onChanged: (_) async {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => awaitResult()));
                        dynamic auth = await _authService.signInEmailAndPass(
                            email, password);
                        if (auth != null) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MainScreen(auth)));
                        } else {
                          Navigator.of(context).pop();
                          error = 'Please check your credentials and try again';
                        }
                      },
                      sliderButtonColor: Colors.grey.shade400,
                      sliderBaseColor: Colors.black,
                      borderColor: textColor,
                      width: 256,
                      height: 56.0,
                      thumb: Container(
                        child: Center(
                          child: Image.asset(
                            'images/basic-logo.png',
                            color: accentColor,
                          ),
                        ),
                      ),
                      content: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 15.0),
                        child: Text(
                          'Swipe To Log In',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(56.0),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Register'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FirstRegistrationScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
