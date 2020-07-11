import 'package:com/Screens/SignIn/sign_in_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("images/nutrition.jpg"), context);
    precacheImage(AssetImage("images/stairs.jpg"), context);
    precacheImage(AssetImage("images/exercise.jpg"), context);
    precacheImage(AssetImage("images/main_pattern.jpg"), context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}
