import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class ImageRecognitionScreen extends StatefulWidget {

  final image;

  ImageRecognitionScreen({this.image});

  @override
  _ImageRecognitionScreenState createState() => _ImageRecognitionScreenState();
}

class _ImageRecognitionScreenState extends State<ImageRecognitionScreen> {

  bool _isloading;
  PickedFile _image;
  String _product, _calories;

  @override
  void initState(){
    super.initState();
    _isloading = true;
    loadTFModel().then((value) {
      setState(() {
        runModelOnImage(widget.image);
        _isloading = false;
      });
    });
  }

  runModelOnImage(PickedFile image) async {
    List result = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5
    );
    setState(() {
      _isloading = false;
      _product = result[0]['label'].split(' ')[1].split('_')[0];
      _calories = result[0]['label'].split(' ')[1].split('_')[1];
    });
  }

  loadTFModel() async {
    await Tflite.loadModel(
        model: 'assets/Model/model_unquant.tflite',
        labels: 'assets/Model/labels.txt'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _product == null ? '' : '$_product',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              Text(
                _calories == null ? '' : '$_calories',
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
