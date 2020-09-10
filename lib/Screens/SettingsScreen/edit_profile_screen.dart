import 'package:com/Database/Models/user.dart';
import 'package:com/Database/Services/auth.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/input_manipulation.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = new AuthService();
  final InputManipulation _input = new InputManipulation();
  final NewUser _user = NewUser();

  final Color _textColor = Colors.white;
  final double _padding = 20.0;

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _padding),
                              child: TextFormField(
                                validator: (ageField) {
                                  if (ageField.isEmpty)
                                    return 'Field cannot be empty';
                                  else
                                    return null;
                                },
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                    color: _textColor,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200),
                                cursorColor: accentColor,
                                decoration: InputDecoration(
                                    hintText: 'Email',
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
                                onChanged: (ageField) {},
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _padding),
                              child: TextFormField(
                                validator: (ageField) {
                                  if (ageField.isEmpty)
                                    return 'Field cannot be empty';
                                  else
                                    return null;
                                },
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                    color: _textColor,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200),
                                cursorColor: accentColor,
                                decoration: InputDecoration(
                                    hintText: 'Username',
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
                                onChanged: (ageField) {},
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _padding),
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
                                style: TextStyle(color: _textColor,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w200
                                ),
                                cursorColor: accentColor,
                                decoration: InputDecoration(
                                    hintText: 'Age',
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
                                onChanged: (ageField){
                                },
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _padding),
                              child: TextFormField(
                                validator: (ageField) {
                                  if (ageField.isEmpty)
                                    return 'Field cannot be empty';
                                  else
                                    return null;
                                },
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                    color: _textColor,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200),
                                cursorColor: accentColor,
                                decoration: InputDecoration(
                                    hintText: 'Weight',
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
                                onChanged: (ageField) {},
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _padding),
                              child: TextFormField(
                                validator: (ageField) {
                                  if (ageField.isEmpty)
                                    return 'Field cannot be empty';
                                  else
                                    return null;
                                },
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                    color: _textColor,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200),
                                cursorColor: accentColor,
                                decoration: InputDecoration(
                                    hintText: 'Height',
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
                                onChanged: (ageField) {},
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: _padding),
                              child: TextFormField(
                                validator: (ageField) {
                                  if (ageField.isEmpty)
                                    return 'Field cannot be empty';
                                  else
                                    return null;
                                },
                                textAlign: TextAlign.left,
                                maxLines: 1,
                                style: TextStyle(
                                    color: _textColor,
                                    fontFamily: 'PTSerif',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w200),
                                cursorColor: accentColor,
                                decoration: InputDecoration(
                                    hintText: 'Gender',
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
                                onChanged: (ageField) {},
                              ),
                            ),
                            SizedBox(height: _height * 0.2),
                            GestureDetector(
                              onTap: () {
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
            )
          ],
        ),
      ),
    );
  }
}
