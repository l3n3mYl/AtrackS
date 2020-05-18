import 'package:com/SecretMenu/menu_background.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


//TODO: DELETE THIS SCREEN AND REPLACE WITH A NORMAL ONE
final Screen contactsScreen = new Screen(
  title: 'Delete this after',
  contentBuilder: (builder){
    return  Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
);

class _MainScreenState extends State<MainScreen> {
  var activeScreen = contactsScreen;//TODO: make a new screen
  var selectedMenuItemScreen = 'first';

  final menu = new Menu(items: [
    MenuItem(id: 'first', title: 'Contacts'),
    MenuItem(id: 'second', title: 'TensorFlow'),
    MenuItem(id: 'third', title: 'Products'),
  ]);

  @override
  Widget build(BuildContext context) {
    return ZoomScaffold(
      menuScreen: new MenuScreen(
        selectedItemId: selectedMenuItemScreen,
        onMenuItemSelected: (String itemId) {
          selectedMenuItemScreen = itemId;

          if (itemId == 'first') {
            setState(() {
//              activeScreen = contactsScreen;
            });
          } else if (itemId == 'second') {
            setState(() {
//              activeScreen = imageRecognitionScreen;
            });
          } else if (itemId == 'third') {
            setState(() {
//              activeScreen = productsScreen;
            });
          }
        },
        menu: menu,
      ),
      contentScreen: activeScreen,
    );
  }
}