import 'package:com/Screens/DiaryScreen/main_diary_screen.dart';
import 'package:com/Screens/ExerciseScreen/exercise_screen.dart';
import 'package:com/Screens/MeditationScreen/meditation_screen.dart';
import 'package:com/Screens/NutritionScreen/main_nutrition_screen.dart';
import 'package:com/Screens/ProgressScreen/main_progress_screen.dart';
import 'package:com/Screens/SettingsScreen/main_settings_screen.dart';
import 'package:com/SecretMenu/menu_background.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {

  final User _user;

  MainScreen(this._user);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  var activeScreen;

  var selectedMenuItemScreen = '1';

  final menu = new Menu(items: [
    MenuItem(id: '1', title: 'Progress'),
    MenuItem(id: '2', title: 'Nutrition'),
    MenuItem(id: '3', title: 'Exercise'),
    MenuItem(id: '4', title: 'Meditation'),
    MenuItem(id: '5', title: 'Diary'),
    MenuItem(id: '0', title: ''),
    MenuItem(id: '7', title: 'Settings'),
  ]);

  @override
  void initState() {
    super.initState();
    activeScreen = new MainProgressScreenRootClass(widget._user).screen();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      menuScreen: new MenuScreen(
        selectedItemId: selectedMenuItemScreen,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemScreen = itemId;

          if (itemId == '1') {
            setState(() {
              activeScreen = new MainProgressScreenRootClass(widget._user).screen();
            });
          } else if (itemId == '2') {
            setState(() {
              activeScreen = new MainNutritionScreenRootClass(widget._user).screen();
            });
          } else if (itemId == '3') {
            setState(() {
              activeScreen = new MainExerciseScreenRootClass(widget._user).screen();
            });
          } else if(itemId == '4'){
            setState(() {
              activeScreen = new MeditationScreenRootClass(widget._user).screen();
            });
          } else if(itemId == '5'){
            setState(() {
              activeScreen = new DiaryScreenRootClass().screen();
            });
          } else if(itemId == '7'){
            setState(() {
              activeScreen = new SettingsScreenRootClass(widget._user).screen();
            });
          }
        },
        menu: menu,
      ),
      contentScreen: activeScreen,
    );
  }
}