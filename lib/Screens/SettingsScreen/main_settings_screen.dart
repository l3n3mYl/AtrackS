import 'package:com/Database/Services/auth.dart';
import 'package:com/Design/colours.dart';
import 'package:com/Screens/SettingsScreen/bmi_calculator_screen.dart';
import 'package:com/Screens/SettingsScreen/edit_goals_screen.dart';
import 'package:com/Screens/SettingsScreen/edit_user_info_screen.dart';
import 'package:com/Screens/SignIn/sign_in_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:com/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'edit_user_acc_screen.dart';

class SettingsScreenRootClass {
  final User user;

  SettingsScreenRootClass(this.user);

  Screen screen() {
    return Screen(
        title: 'Settings', contentBuilder: (_) => SettingsScreen(user));
  }
}

class SettingsScreen extends StatelessWidget {

  final User _user;

  SettingsScreen(this._user);

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
              alignment: Alignment.topLeft,
              width: _width,
              height: _height,
              color: Colors.transparent,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => EditUserInfoScreen(_user))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      width: _width,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '• Edit User Information',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19.0,
                                fontFamily: 'PTSerif'
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.3),
                        border: Border(
                          bottom: BorderSide(
                            color: accentColor,
                            width: 2.0
                          )
                        )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => EditUserAccScreen(_user))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                      width: _width,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• Edit User Account',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19.0,
                                fontFamily: 'PTSerif'
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.3),
                          border: Border(
                              bottom: BorderSide(
                                  color: accentColor,
                                  width: 2.0
                              )
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BMICalculator(_user))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                      width: _width,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• BMI Calculator',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19.0,
                                fontFamily: 'PTSerif'
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.weight,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.3),
                          border: Border(
                              bottom: BorderSide(
                                  color: accentColor,
                                  width: 2.0
                              )
                          )
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: (){},
                  //   child: Container(
                  //     alignment: Alignment.centerLeft,
                  //     padding: EdgeInsets.only(left: 6.9),
                  //     margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                  //     width: _width,
                  //     height: 50.0,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           '• Change Theme',
                  //           style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 19.0,
                  //               fontFamily: 'PTSerif'
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Icon(
                  //             FontAwesomeIcons.adjust,
                  //             color: Colors.white,
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //     decoration: BoxDecoration(
                  //         color: mainColor.withOpacity(0.3),
                  //         border: Border(
                  //             bottom: BorderSide(
                  //                 color: accentColor,
                  //                 width: 2.0
                  //             )
                  //         )
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: ()=>Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => EditGoalsScreen(_user))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      margin: EdgeInsets.only(bottom: _height * 0.3, top: 10.0,
                        right: 40.0, left: 40.0
                      ),
                      width: _width,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• Set Goals',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19.0,
                                fontFamily: 'PTSerif'
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.checkCircle,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.3),
                          border: Border(
                              bottom: BorderSide(
                                  color: accentColor,
                                  width: 2.0
                              )
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      AuthService _auth = new AuthService();
                      await _auth.signOutGoogle();
                      await _auth.signOutEmailAndPass();
                      await _auth.signOutFacebook();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignInScreen()));
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      width: _width * 0.6,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PTSerif'
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.powerOff,
                              color: accentColor,
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.69),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
