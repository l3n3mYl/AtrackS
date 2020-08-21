import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class ImageRecognitionScreen extends StatefulWidget {
  @override
  _ImageRecognitionScreenState createState() => _ImageRecognitionScreenState();
}

class _ImageRecognitionScreenState extends State<ImageRecognitionScreen> {

  bool _isloading;
  File _image;
  List _list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadModel() async {
    Tflite.loadModel(model: 'assets/Model/model_unquant.tflite');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
