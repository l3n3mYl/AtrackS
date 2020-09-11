import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUserAccScreen extends StatelessWidget {

  final User _user;

  EditUserAccScreen(this._user);

  final _formKey = GlobalKey<FormState>();

  final Color _textColor = Colors.white;
  final double _padding = 20.0;

  String email, password1, password2, _error;

  @override
  Widget build(BuildContext context) {

    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: mainColor,
        child: Stack(
          children: [
            Container(
              width: _width,
              height: _height,
              color: mainColor,
            ),
            BackgroundTriangle(),
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
              alignment: Alignment.center,
              margin: const EdgeInsets.all(50.0),
              width: _width,
              height: _height,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 20.0,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: _padding),
                            child: TextFormField(
                              validator: (emailField) {
                                if(emailField.isEmpty) return 'This Field Is Required';
                                else if(!emailField.contains('@')) return 'Enter a valid email address';
                                else return null;
                              },
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: _textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200
                              ),
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0))),
                              onChanged: (emailField){
                                email = emailField;
                              },
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: _padding),
                            child: TextFormField(
                              validator: (passwordField) {
                                if(passwordField.isEmpty) return 'This Field Is Required';
                                if(passwordField.length < 5) return 'Password must be at least 6 chars long';
                                else return null;
                              },
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(
                                  color: _textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w200),
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                      color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0))),
                              onChanged: (passField) {
                                password1 = passField;
                              },
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: _padding),
                            child: TextFormField(
                              validator: (passwordField) {
                                if(passwordField.isEmpty) return 'This Field Is Required';
                                if(passwordField.length < 5) return 'Password must be at least 6 chars long';
                                if(password1 != passwordField) return 'Passwords must match';
                                else return null;
                              },
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(
                                  color: _textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w200),
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  hintText: 'Repeat Password',
                                  hintStyle: TextStyle(
                                      color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: accentColor, width: 2.0))),
                              onChanged: (passField) {
                                password2 = passField;
                              },
                            ),
                          ),
                          SizedBox(height: 25.0,),
                          Center(
                            child: Text(
                              _error == null ? '' : _error,
                              style: TextStyle(
                                fontFamily: 'PTSerif',
                                color: Colors.red
                              ),
                            ),
                          ),
                          SizedBox(height: _height * 0.13),
                          GestureDetector(
                            onTap: () async {
                              if(_formKey.currentState.validate()) {
                                await DatabaseManagement(_user)
                                    .updateEmailAndPassword(email, password2)
                                    .then((value) => Navigator.of(context).pop())
                                    .catchError((error) => _error = error);
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
                                        'Save',
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
                    )
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
