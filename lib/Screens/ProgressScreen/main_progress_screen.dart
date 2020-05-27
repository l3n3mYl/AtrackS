import 'package:com/Design/colours.dart';
import 'package:com/Screens/ProgressScreen/walking_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/Database/Services/db_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainProgressScreenRootClass {

  final FirebaseUser user;
  MainProgressScreenRootClass(this.user);

  Screen screen(){
    return Screen(
      title: 'Overall Progress',
      contentBuilder: (_) => MainProgressScreen(user)
    );
  }
}

class MainProgressScreen extends StatefulWidget {

  final FirebaseUser _user;

  MainProgressScreen(this._user);

  @override
  _MainProgressScreenState createState() => _MainProgressScreenState();
}

class _MainProgressScreenState extends State<MainProgressScreen> {

  final List<Color> colorPal = [
    Color.fromRGBO(255, 139, 103, 1),
    Color.fromRGBO(51, 192, 183, 1),
    Color.fromRGBO(78, 166, 88, 1),
    Color.fromRGBO(209, 29, 30, 1),
    Color.fromRGBO(255, 139, 103, 1),
    Color.fromRGBO(255, 139, 103, 1),
    Color.fromRGBO(255, 139, 103, 1),
  ];

  @override
  Widget build(BuildContext context) {

    final DatabaseManagement _db = new DatabaseManagement(widget._user);

    Future<Map<String, dynamic>> _future = _db.retrieveExerciseInfoByUid();
    List<Widget> children = new List();

  //TODO: make everything tidy
    return Scaffold(
      body: Container(
        color: mainColor,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot){
            if(snapshot.hasData){
              children.clear();
              final Map<String, dynamic> exerciseInfoList = snapshot.data;
              final int exerciseLen = exerciseInfoList.length;
              children.add(
                Container(
                  child: RaisedButton(
                    child: Text('Navigate To Step Screen'),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WalkingScreen(widget._user))),
                  ),
                )
              );
              for(var i = 0; i <exerciseLen; ++i){
                children.add(
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: 256,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          width: 2.0,
                          color: colorPal[i].withOpacity(0.7)
                        ),
                        color: colorPal[i].withOpacity(0.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(snapshot.data.keys.elementAt(i), style: TextStyle(color: colorPal[i].withOpacity(0.7)),),
                              Text(snapshot.data.values.elementAt(i), style: TextStyle(color: colorPal[i].withOpacity(0.7)),)
                            ],
                          ),
                          Container(
                            width: 2.0,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  colorPal[i].withOpacity(0.7),
                                  colorPal[i].withOpacity(0.1),
                                  Colors.transparent,
                                  colorPal[i].withOpacity(0.1),
                                  colorPal[i].withOpacity(0.7),
                                ]
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Icon(
                                FontAwesomeIcons.stepForward
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                );
              }
            } else if(snapshot.hasError){
              children = <Widget>[
                Text('There was an error')
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 55,
                  height: 55,
                ),
                const Padding(padding: EdgeInsets.only(top: 16.0),child: Text('avai'),),
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          },
        )
      ),
    );
  }
}
