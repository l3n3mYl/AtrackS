import 'package:com/SecretMenu/menu_background.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


//TODO: DELETE THIS SCREEN AND REPLACE WITH A NORMAL ONE
final Screen firstScreen = new Screen(
  title: 'Delete this after',
  contentBuilder: (builder){
    return  Scaffold(
      body: Container(
        color: Colors.red,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
);
final Screen secondScreen = new Screen(
    title: 'Delete this after',
    contentBuilder: (builder){
      return  Scaffold(
        body: Container(
          color: Colors.green,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
);
final Screen thirdScreen = new Screen(
    title: 'Delete this after',
    contentBuilder: (builder){
      return  Scaffold(
        body: Container(
          color: Colors.blue,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
);
final Screen fourthScreen = new Screen(
    title: 'Delete this after',
    contentBuilder: (builder){
      return  Scaffold(
        body: Container(
          color: Colors.amber,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
);
final Screen fifthScreen = new Screen(
    title: 'Delete this after',
    contentBuilder: (builder){
      return  Scaffold(
        body: Container(
          color: Colors.deepOrange,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
);
final Screen settingsScreen = new Screen(
    title: 'Delete this after',
    contentBuilder: (builder){
      return  Scaffold(
        body: Container(
          color: Colors.cyanAccent,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
);

class _MainScreenState extends State<MainScreen> {
  var activeScreen = firstScreen;//TODO: make a new screen
  var selectedMenuItemScreen = '1';//TODO: CHANGE TO A NORMAL ID

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
  Widget build(BuildContext context) {
    return ZoomScaffold(
      menuScreen: new MenuScreen(
        selectedItemId: selectedMenuItemScreen,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemScreen = itemId;

          if (itemId == '1') {
            setState(() {
              activeScreen = firstScreen;
            });
          } else if (itemId == '2') {
            setState(() {
              activeScreen = secondScreen;
            });
          } else if (itemId == '3') {
            setState(() {
              activeScreen = thirdScreen;
            });
          } else if(itemId == '4'){
            setState(() {
              activeScreen = fourthScreen;
            });
          } else if(itemId == '5'){
            setState(() {
              activeScreen = fifthScreen;
            });
          } else if(itemId == '7'){
            setState(() {
              activeScreen = settingsScreen;
            });
          }
        },
        menu: menu,
      ),
      contentScreen: activeScreen,
    );
  }
}