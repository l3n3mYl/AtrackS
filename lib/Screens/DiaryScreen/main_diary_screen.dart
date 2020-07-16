import 'dart:convert';

import 'package:com/Design/colours.dart';
import 'package:com/Screens/DiaryScreen/event_viewing_screen.dart';
import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryScreenRootClass {
  Screen screen() {
    return Screen(title: 'Diary', contentBuilder: (_) => DiaryScreen());
  }
}

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>{

  CalendarController _controller;
  SharedPreferences _preferences;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _initPrefs();
    _controller = CalendarController();
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
              ),..._selectedEvents.map((event) {

                String title = event.split(' _*_ ')[0];
                String description = event.split(' _*_ ')[1];

                return ListTile(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SingleEventScreen(
                          title, description))),
                  onLongPress: () {
                    setState(() {
                      if(_events[_controller.selectedDay].length > 1){
                        _events[_controller.selectedDay].remove(event);
                      } else {
                        _events[_controller.selectedDay].clear();
                      }
                      _preferences.setString("events", json.encode(encodeMap(_events)));
                      return _selectedEvents;
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
                    child: Text('$title')
                  ),
                );
              },
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
      String title, description;

      final _formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: mainColor,
            content: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text('New Event',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'PTSerif',
                          fontSize: 22.0
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 13.0),
                        child: TextFormField(
                          validator: (data) {
                            if(data.isEmpty) return 'Please Enter A Title';
                            else return null;
                          },
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          cursorColor: accentColor.withRed(150),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(color: textColor,
                                fontFamily: 'PTSerif',
                                fontSize: 18,
                                fontWeight: FontWeight.w200
                            ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor.withRed(150))),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor.withRed(150))),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor.withRed(150))),
                          ),
                          style: TextStyle(color: textColor,
                              fontFamily: 'PTSerif',
                              fontSize: 18,
                              fontWeight: FontWeight.w200
                          ),
                          onChanged: (data) {
                            title = data;
                          },
                        ),
                      ),
                      SizedBox(height: 50.0,),
                      Padding(
                        padding: EdgeInsets.only(bottom: 100.0, left: 20.0, right: 20.0),
                        child: TextFormField(
                          validator: (data) {
                            if(data.isEmpty) return 'Please Enter A Description';
                            else return null;
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          cursorColor: accentColor.withRed(150),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(color: textColor,
                                fontFamily: 'PTSerif',
                                fontSize: 18,
                                fontWeight: FontWeight.w200
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: accentColor.withRed(150))),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: accentColor.withRed(150))),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: accentColor.withRed(150))),
                          ),
                          style: TextStyle(color: textColor,
                              fontFamily: 'PTSerif',
                              fontSize: 18,
                              fontWeight: FontWeight.w200
                          ),
                          onChanged: (data) {
                            description = data;
                          },
                        ),
                      ),
                      SizedBox(height: 50.0,),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          child: Text('Save',
                          style: TextStyle(color: textColor,
                              fontFamily: 'PTSerif',
                              fontSize: 18,
                              fontWeight: FontWeight.w200
                            ),
                          ),
                          onPressed: () {
                            if(_formKey.currentState.validate()) {
                                setState(() {
                                  if(_events[_controller.selectedDay] != null){
                                    _events[_controller.selectedDay].add('$title _*_ $description');
                                  } else {
                                    _events[_controller.selectedDay] = ['$title _*_ $description'];
                                  }
                                  _preferences.setString("events", json.encode(encodeMap(_events)));
                                  Navigator.pop(context);
                                }
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      setState(() {
        _selectedEvents = _events[_controller.selectedDay];
      });
    }
}
