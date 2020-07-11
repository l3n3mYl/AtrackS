import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:flutter/material.dart';

Widget awaitResult(String title) {

  double _width = double.infinity;
  double _height = double.infinity;

  return Material(
    type: MaterialType.transparency,
    child: Container(
      width: _width,
      height: _height,
      color: mainColor,
      child: Stack(
        children: <Widget>[
          Container(
            width: _width,
            height: _height,
            child: Opacity(
              opacity: 0.2,
              child: Image(
                fit: BoxFit.cover,
                image: AssetImage('images/main_pattern.jpg'),
              ),
            ),
          ),
          BackgroundTriangle(),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    backgroundColor: accentColor,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    strokeWidth: 2.0,
                  ),
                ),
                SizedBox(height: 25.0,),
                Text(title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PTSerif',
                    fontSize: 18.0
                ),)
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

