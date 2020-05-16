import 'package:com/Registration/registration_screen.dart';
import 'package:com/Services/auth.dart';
import 'package:flutter/material.dart';

final Color mainColor = Color.fromRGBO(71, 68, 70, 1);
final Color textColor = Color.fromRGBO(163, 149, 135, 1);
final Color accentColor = Color.fromRGBO(213, 1, 1, 1);

class SignInScreen extends StatelessWidget {
  String email = '';
  String password = '';

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: mainColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55.0),
                child: TextField(
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
                  onChanged: (input) {
                    email = input.toString();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55.0),
                child: TextField(
                  obscureText: true,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
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
                  onChanged: (input) {
                    password = input.toString();
                  },
                ),
              ),
              RaisedButton(
                child: Text('Log In'),
                onPressed: () async {
                  dynamic auth =
                      await _authService.signInEmailAndPass(email, password);
                  if (auth != null) {
                    print('SUCESS');
                  } else {
                    print('SOMETHING WENT WRONG');
                  }
                },
              ),
              RaisedButton(
                child: Text('Login with Google+'),
                onPressed: () async {
                  dynamic auth = await _authService.signInGooglePlus();
                  print(auth.toString());
                  if (auth != null) {
                    print('SUCESS');
                  } else {
                    print('SOMETHING WENT WRONG');
                  }
                },
              ),
              RaisedButton(
                child: Text('Sign Out from Google+'),
                onPressed: () async {
                  await _authService.signOutGoogle();
                },
              ),
              RaisedButton(
                child: Text('Sign In with Facebook'),
                onPressed: () async {
                  dynamic auth = await _authService.signInFacebook();
                  print(auth.toString());
                  if (auth != null) {
                    print('Sucess');
                  } else {
                    print('Something went wrong with db login');
                  }
                },
              ),
              RaisedButton(
                child: Text('Sign Out from facebook'),
                onPressed: () async {
                  await _authService.signOutFacebook();
                },
              ),
              RaisedButton(
                child: Text('Register'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => RegistrationScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
