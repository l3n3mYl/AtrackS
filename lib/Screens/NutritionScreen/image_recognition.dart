import 'package:com/Database/Services/db_management.dart';
import 'package:com/Design/colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class ImageRecognitionScreen extends StatefulWidget {
  final image;
  final User user;
  final String barcode;

  ImageRecognitionScreen({this.image, this.user, this.barcode});

  @override
  _ImageRecognitionScreenState createState() => _ImageRecognitionScreenState();
}

class _ImageRecognitionScreenState extends State<ImageRecognitionScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  bool _isloading;
  PickedFile _image;
  String _nutritionMass = '100';
  String _product;
  List<String> _nutritionList = new List<String>();
  dom.Document _doc;

  @override
  void initState() {
    super.initState();
    _isloading = true;
    if(widget.image != null){
      loadTFModel().then((value) {
      setState(() {
        runModelOnImage(widget.image);
        _isloading = false;
        });
      });
    } else {
      getData();
    }
  }

  void getData() async {
    var _url = 'https://world.openfoodfacts.org/product/${widget.barcode}';
    var _result = await http.get(_url);
    _doc = parser.parse(_result.body);

    getValues();
  }

  void getValues() {
    if(_doc != null) {
      try {
        final List<String> _nutriments = ['energy-kcal', 'fat',
        'carbohydrates', 'proteins'];
        var mainClass, nutriment;
        _nutritionList.add('none');
        for(var i = 0; i < 4; ++i) {
          mainClass = _doc.getElementById('nutriment_${_nutriments[i]}_tr');
          nutriment = mainClass.getElementsByClassName('nutriment_value ')[0]
              .innerHtml;

          _nutritionList.add(nutriment.split(' ')[0].replaceAll(new RegExp(r"\s+"), "").toString());
          print(_nutritionList);
        }
        setState(() {});
      } catch (e) {
        _nutritionList = ['0', '0', '0', '0', '0'];
        setState(() {});
      }
    }
  }

  runModelOnImage(PickedFile image) async {
    List result = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 1,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5);
    setState(() {
      _isloading = false;
      _product = result[0]['label'].split(' ')[1].split('_')[0];
      _nutritionList = result[0]['label'].split(' ')[1].split('_');
    });
  }

  loadTFModel() async {
    await Tflite.loadModel(
        model: 'assets/Model/model_unquant.tflite',
        labels: 'assets/Model/labels.txt');
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

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
              alignment: Alignment.center,
              width: _width,
              height: _height,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Is it ',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'PTSerif',
                            fontSize: 36
                          ),
                        ),
                        Text(
                          _product == null ? 'right?' : '$_product?',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: textColor,
                              fontFamily: 'PTSerif',
                              fontSize: 36
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 50,
                            child: Text(
                                'Calories',
                                style: TextStyle(
                                  fontFamily: 'PTSerif',
                                  fontSize: 18.0,
                                  color: Colors.white54
                                ),
                            ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 50.0),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: 'SourceSansPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w200),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: _nutritionList.length <= 0
                                    ? ''
                                    : '${_nutritionList[1]}',
                                hintStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'SourceSansPro',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w200),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor))),
                            onChanged: (calorieField) {
                              _nutritionList[1] = double.parse(calorieField)
                                  .toStringAsFixed(2);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 50,
                            child: Text(
                              'Carbs',
                              style: TextStyle(
                                  fontFamily: 'PTSerif',
                                  fontSize: 18.0,
                                  color: Colors.white54
                              ),
                            )),
                        Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 50.0),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: 'SourceSansPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w200),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: _nutritionList.length <= 1
                                    ? ''
                                    : '${_nutritionList[2]}',
                                hintStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'SourceSansPro',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w200),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor))),
                            onChanged: (carbsField) {
                              _nutritionList[2] = double.parse(carbsField)
                                  .toStringAsFixed(2);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 50,
                            child: Text(
                              'Fats',
                              style: TextStyle(
                                  fontFamily: 'PTSerif',
                                  fontSize: 18.0,
                                  color: Colors.white54
                              ),
                            )),
                        Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 50.0),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: 'SourceSansPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w200),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: _nutritionList.length <= 2
                                    ? ''
                                    : '${_nutritionList[3]}',
                                hintStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'SourceSansPro',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w200),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor))),
                            onChanged: (fatsField) {
                              _nutritionList[3] = double.parse(fatsField)
                                  .toStringAsFixed(2);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 50,
                            child: Text(
                              'Protein',
                              style: TextStyle(
                                  fontFamily: 'PTSerif',
                                  fontSize: 18.0,
                                  color: Colors.white54
                              ),
                            )),
                        Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 50.0),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: 'SourceSansPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w200),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: _nutritionList.length <= 3
                                    ? ''
                                    : '${_nutritionList[4]}',
                                hintStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'SourceSansPro',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w200),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor))),
                            onChanged: (proteinField) {
                              _nutritionList[4] = double.parse(proteinField)
                                  .toStringAsFixed(2);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 50,
                            child: Text(
                              'Grams',
                              style: TextStyle(
                                  fontFamily: 'PTSerif',
                                  fontSize: 18.0,
                                  color: Colors.white54
                              ),
                            )),
                        Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 50.0),
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                color: textColor,
                                fontFamily: 'SourceSansPro',
                                fontSize: 18,
                                fontWeight: FontWeight.w200),
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                hintText: '100',
                                hintStyle: TextStyle(
                                    color: textColor,
                                    fontFamily: 'SourceSansPro',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w200),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor))),
                            onChanged: (massField) {
                              _nutritionMass = double.parse(massField)
                                  .toStringAsFixed(2);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await DatabaseManagement(widget.user)
                            .updateNutritionWithProduct(_nutritionList,
                              _nutritionMass).then((value) {
                                if(value == 'Success') {
                                  Navigator.of(context).pop();
                                } else {
                                  print('Error upon updating the Database');
                                }
                              }
                            );
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
                              'Proceed',
                              style: TextStyle(
                                  color: textColor,
                                  fontFamily: 'PTSerif',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w200),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
