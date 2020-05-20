import 'package:com/Design/colours.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:com/Services/db_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  final DatabaseManagement _db = new DatabaseManagement();


  @override
  Widget build(BuildContext context) {

  Future<Map<String, dynamic>> _future = _db.retrieveExerciseInfoByUid(widget._user);
  List<Widget> children = new List();
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
              for(var i = 0; i <exerciseLen; ++i){
                children.add(
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(snapshot.data.keys.elementAt(i)),
                            Text(snapshot.data.values.elementAt(i))
                          ],
                        )
                      ],
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
