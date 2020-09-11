import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/input_manipulation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUserInfoScreen extends StatelessWidget {

  final User _user;

  EditUserInfoScreen(this._user);

  final _formKey = GlobalKey<FormState>();

  final InputManipulation _input = new InputManipulation();

  final Color _textColor = Colors.white;
  final double _padding = 20.0;

  final Map<String, String> _newSettings = {
    'Age': null,
    'Weight': null,
    'Height': null,
    'Gender': null,
  };

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
                                  validator: (ageField) {
                                    if(ageField.isNotEmpty){
                                      if(!_input.isNumeric(ageField)) return 'Wrong format';
                                        else if(int.parse(ageField) < 3 || int.parse(ageField) >= 99) return 'Please enter a valid age';
                                          else return null;
                                    }
                                    else return 'Field must not be left empty';
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
                                    _newSettings['Age'] = ageField;
                                  },
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: _padding),
                                child: TextFormField(
                                  validator: (weightField) {
                                    if(weightField.isNotEmpty){
                                      if(!_input.isNumeric(weightField)) return 'Wrong format';
                                      else if(int.parse(weightField) < 20 || int.parse(weightField) >= 200) return 'Please enter a valid weight in kilos';
                                      else return null;
                                    } else return 'Field Must not be left blank';
                                  },
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w200),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: 'Weight (kg)',
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
                                  onChanged: (weightField) {
                                    _newSettings['Weight'] = weightField;
                                  },
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: _padding),
                                child: TextFormField(
                                  validator: (heightField) {
                                    if(heightField.isNotEmpty){
                                      if(!_input.isNumeric(heightField)) return 'Wrong format';
                                      if(int.parse(heightField) < 100 || int.parse(heightField) >= 300) return 'Please enter a valid height in cm';
                                      else return null;
                                    }
                                    else return 'Field Must not be left blank';
                                  },
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      color: _textColor,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w200),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: 'Height (cm)',
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
                                  onChanged: (heightField) {
                                    _newSettings['Height'] = heightField;
                                  },
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: _padding),
                                child: TextFormField(
                                  validator: (genderField) {
                                    if (genderField.toLowerCase() != 'male')
                                      if (genderField.toLowerCase() != 'female')
                                        return 'Please enter \'male\' or \'female\'';
                                      else return null;
                                    else return null;
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
                                  onChanged: (genderField) {
                                    if(genderField.toLowerCase() == 'male')
                                      _newSettings['Gender'] = 'Male';
                                    else if (genderField.toLowerCase() == 'female')
                                      _newSettings['Gender'] = 'Female';
                                  },
                                ),
                              ),
                              SizedBox(height: _height * 0.2),
                              GestureDetector(
                                onTap: () async {
                                  if(_formKey.currentState.validate()) {
                                    await DatabaseManagement(_user)
                                        .updateUserInformation(_newSettings).then((_) {
                                        Navigator.of(context).pop();
                                      }
                                    );
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
