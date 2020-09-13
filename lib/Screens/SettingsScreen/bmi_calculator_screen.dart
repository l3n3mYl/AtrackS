import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/Utilities/input_manipulation.dart';
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

  TextEditingController _weightController = new TextEditingController();
  TextEditingController _heightController = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final _input = new InputManipulation();

  String gender;
  int weight, height, age;
  double bmi;

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

  @override
  Widget build(BuildContext context) {

    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'BMI Calculator',
          style: TextStyle(fontFamily: 'PTSerif'),
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
          ),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        bmi == null ? 'N/A'
                            : bmi < 18.5 ? 'Underweight'
                            : bmi >= 18.5 && bmi <= 25 ? 'Normal'
                            : bmi < 30 && bmi > 25 ? 'Overweight'
                            : 'Obese',
                        style: TextStyle(
                          color: bmi == null ? Colors.white
                              : bmi < 18.5 ? Colors.amber
                              : bmi >= 18.5 && bmi <= 25 ? Colors.green
                              : bmi < 30 && bmi > 25 ? Colors.amber
                              : Colors.red,
                          fontFamily: 'PTSerif',
                          fontSize: 19.0
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 69.9,
                    ),
                    Form(
                      key: _formKey,
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
                                  validator: (heightField) {
                                    if(!_input.isNumeric(heightField)) return 'Wrong format';
                                    else return null;
                                  },
                                  controller: _heightController,
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
                                  onChanged: (heightField){
                                    setState(() {
                                      height = int.parse(heightField);
                                    });
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
                                  validator: (weightField) {
                                    if(!_input.isNumeric(weightField)) return 'Wrong format';
                                    else return null;
                                  },
                                  controller: _weightController,
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
                                  onChanged: (weightField){
                                    setState(() {
                                      weight = int.parse(weightField);
                                    });
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
                          SizedBox(height: _height * 0.2),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                countBMI();
                                _weightController.clear();
                                _heightController.clear();
                              });
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
