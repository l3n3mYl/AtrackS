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

  Future<List<dynamic>> _future = _db.retrieveExerciseInfoByUid(widget._user);
    return Scaffold(
      body: Container(
        color: Colors.cyanAccent,
        child: FutureBuilder<List<dynamic>>(
          future: _future,
          builder: (context, snapshot){
            List<Widget> children;
            if(snapshot.hasData){
              final List<dynamic> exerciseInfoList = snapshot.data;
              final int exerciseLen = exerciseInfoList.length;
              children = <Widget>[
                Text('Result: $exerciseInfoList'),
                Text('Len: ${exerciseLen.toString()}')
              ];
//              children = <Widget>[
//                Icon(Icons.check_circle_outline,color: Colors.green,size: 60,),
//                Padding(
//                  padding: const EdgeInsets.only(top: 16.0),
//                  child: Text('Result: ${snapshot.data}'),
//                )
//            ];
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
