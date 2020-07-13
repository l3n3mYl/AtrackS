import 'dart:convert';

import 'package:com/Design/colours.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryScreenRootClass {
  final FirebaseUser user;

  DiaryScreenRootClass(this.user);

  Screen screen() {
    return Screen(title: 'Diary', contentBuilder: (_) => DiaryScreen(user));
  }
}

class DiaryScreen extends StatefulWidget {
  final FirebaseUser _user;

  DiaryScreen(this._user);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>{

  CalendarController _controller;
  SharedPreferences _preferences;
  Map<DateTime, List<dynamic>> _events;
  TextEditingController _eventController;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _initPrefs();
    _controller = CalendarController();
    _eventController = TextEditingController();
  }

  void _initPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(decodeMap(
          json.decode(_preferences.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });

    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              TableCalendar(
                builders: CalendarBuilders(
                  todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                  selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ),
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
                events: _events,
                initialCalendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  headerMargin: EdgeInsets.only(bottom: 13.0),
                  titleTextStyle: TextStyle(
                    fontSize: 20.0
                  ),
                  leftChevronIcon: Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    FontAwesomeIcons.chevronRight,
                    color: Colors.black,
                  ),
                  formatButtonShowsNext: false,
                  formatButtonTextStyle: TextStyle(
                    color: Colors.amber
                  ),
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(123.0),
                    border: Border.all(color: Colors.amber, width: 1.0, style: BorderStyle.solid)
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        mainColor,
                        Colors.grey.shade700,
                        Colors.grey.shade700,
                        Colors.black45,
                      ]
                    )
                  )
                ),
                calendarStyle: CalendarStyle(
                  markersMaxAmount: 4,
                  highlightSelected: true,
                  highlightToday: true,
                  markersColor: Colors.green,
                  renderDaysOfWeek: true,
                ),
                calendarController: _controller,
              ),..._selectedEvents.map((event) => ListTile(
                onLongPress: () {
                  setState(() {
                    if(_events[_controller.selectedDay] != null) {
                      setState(() {
                        _preferences.remove(event);
                        _events[_controller.selectedDay].remove(event);
                      });
                    }
                  });
                },
                title: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
                  margin: EdgeInsets.symmetric(horizontal: 25.0, vertical: 13.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: Colors.black
                    )
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text('$event')
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.plus),
        onPressed: _showAddDialog,
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _eventController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('save'),
            onPressed: (){
              if(_eventController.text.isEmpty) return;
              setState(() {
                if(_events[_controller.selectedDay] != null) {
                  _events[_controller.selectedDay].add(_eventController.text);
                } else {
                  _events[_controller.selectedDay] = [_eventController.text];
                }
                _preferences.setString("events", json.encode(encodeMap(_events)));
                _eventController.clear();
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
    );
  }
}
