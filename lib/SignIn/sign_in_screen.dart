import 'package:com/Registration/first_registration_screen.dart';
import 'package:com/SecretMenu/menu_management.dart';
import 'package:com/Services/auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    String email = '';
    String password = '';

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
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainScreen()));
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainScreen()));
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainScreen()));
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => FirstRegistrationScreen()));
                },
              ),
              RaisedButton(
                //TODO: Delete
                child: Text('MAIN SCREEN'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainScreen())),
              )
            ],
          ),
        ),
      ),
    );
  }
}
