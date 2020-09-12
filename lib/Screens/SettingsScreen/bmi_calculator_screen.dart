import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BMICalculator extends StatefulWidget {

  final User _user;

  BMICalculator(this._user);

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {


  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void countBMI() {
    setState(() {
      bmi = double.parse(((weight / ((height * height) / 100)) * 100).toStringAsFixed(1));
    });
  }

  void getUserInfo() async {
    DatabaseManagement _management = new DatabaseManagement(widget._user);

    if(_management != null) {
      await _management.getSingleFieldInfo('users', 'Age').then((value) =>
        age = int.parse(value)
      );
      await _management.getSingleFieldInfo('users', 'Gender').then((value) =>
        gender = value.toString()
      );
      await _management.getSingleFieldInfo('users', 'Weight').then((value) =>
        weight = int.parse(value)
      );
      await _management.getSingleFieldInfo('users', 'Height').then((value) =>
        height = int.parse(value)
      );

      setState(() {});
    }
  }

  String _error, gender;
  int weight, height, age;
  double bmi;

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
              width: _width,
              height: _height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: _height * 0.2,),
                    Container(
                      alignment: Alignment.center,
                      width: _width * 0.6,
                      height: _height * 0.2,
                      child: Text(
                        bmi == null ? '0.0' : bmi.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 69.0,
                          fontFamily: 'SourceSansPro',
                        ),
                      ),
                    ),
                    Form(
                      child: Column(
                        children: [
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: (){
                                  if(height - 1 > 100) {
                                    setState(() {
                                      height--;
                                    });
                                    countBMI();
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.minus,
                                  color: textColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                width: _width * 0.4,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: height == null ? '' : height.toString(),
                                      hintStyle: TextStyle(color: Colors.white,
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
                                  },
                                ),
                              ),
                              Text(
                                'cm',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'PTSerif'
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  if(height + 1 < 301) {
                                    setState(() {
                                      height++;
                                    });
                                    countBMI();
                                  }
                                },
                                icon: Icon(
                                    FontAwesomeIcons.plus,
                                    color: textColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: (){
                                  if(weight - 1 > 19) {
                                    setState(() {
                                      weight--;
                                    });
                                    countBMI();
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.minus,
                                  color: textColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                width: _width * 0.4,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: weight == null ? '' : weight.toString(),
                                      hintStyle: TextStyle(color: Colors.white,
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
                                  },
                                ),
                              ),
                              Text(
                                'kg',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'PTSerif'
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  if(weight + 1 < 201) {
                                    setState(() {
                                      weight++;
                                    });
                                    countBMI();
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.plus,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: (){
                                  if(gender == 'Male'){
                                    setState(() {
                                      gender = 'Female';
                                    });
                                  } else {
                                    setState(() {
                                      gender = 'Male';
                                    });
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  color: textColor,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                width: _width * 0.3,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'PTSerif',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w200
                                  ),
                                  cursorColor: accentColor,
                                  decoration: InputDecoration(
                                      hintText: gender == null ? 'Gender' : gender,
                                      hintStyle: TextStyle(color: Colors.white,
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
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  if(gender == 'Male'){
                                    setState(() {
                                      gender = 'Female';
                                    });
                                  } else {
                                    setState(() {
                                      gender = 'Male';
                                    });
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.arrowRight,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              )
                            ],
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
                          SizedBox(height: _height * 0.1),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
