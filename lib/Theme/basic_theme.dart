import 'package:com/Design/colours.dart';
import 'package:flutter/material.dart';

ThemeData basicTheme() {
  TextTheme basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
        fontFamily: 'PTSerif',
        color: Color.fromRGBO(222, 222, 222, 1),
      ),
    );
  }



  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: basicTextTheme(base.textTheme),
    backgroundColor: mainColor,
    primaryColor: mainColor,
  );
}