import 'package:com/Design/colours.dart';
import 'package:com/Screens/SettingsScreen/SetGoals/exercise_goals.dart';
import 'package:com/Screens/SettingsScreen/SetGoals/meditation_goals.dart';
import 'package:com/Screens/SettingsScreen/SetGoals/nutrition_goals.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditGoalsScreen extends StatelessWidget {

  final User _user;

  EditGoalsScreen(this._user);

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Categories',
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
              color: Colors.transparent,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: ()=>Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => ExerciseGoalsSet(_user))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      width: _width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.3),
                        border: Border(
                          bottom: BorderSide(
                            color: accentColor,
                            width: 2.0
                          )
                        )
                      ),
                      child: Text(
                        '• Exercise Goals',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.0,
                          fontFamily: 'PTSerif'
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => NutritionGoalSet(_user))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      width: _width,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.3),
                          border: Border(
                              bottom: BorderSide(
                                  color: accentColor,
                                  width: 2.0
                              )
                          )
                      ),
                      child: Text(
                        '• Nutrition Goals',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                            fontFamily: 'PTSerif'
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => MeditationGoalSet(_user))),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 6.9),
                      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      width: _width,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.3),
                          border: Border(
                              bottom: BorderSide(
                                  color: accentColor,
                                  width: 2.0
                              )
                          )
                      ),
                      child: Text(
                        '• Meditation Goal',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                            fontFamily: 'PTSerif'
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
