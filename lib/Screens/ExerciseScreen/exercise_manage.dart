import 'package:com/Design/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ExerciseManage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size _size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Container(
          alignment: Alignment.center,
          color: mainColor,
          child: SingleChildScrollView(
            child: Center(
              child: CheckboxList(),
            ),
          ),
        ),
    );
  }
}


class CheckboxList extends StatefulWidget {
  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {

  Map<String, bool> _exListSort = {
    'Cycling':true,
    'Jogging':true,
    'Pull-Ups':true,
    'Push-Ups':true,
    'Sit-Ups':true,
    'Steps':true,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Cycling'),
          value: _exListSort['Cycling'],
          onChanged: (bool cycValue) {
            setState(() {
              _exListSort.update('Cycling', (value) => cycValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Jogging'),
          value: _exListSort['Jogging'],
          onChanged: (bool jogValue) {
            setState(() {
              _exListSort.update('Jogging', (value) => jogValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Pull-Ups'),
          value: _exListSort['Pull-Ups'],
          onChanged: (bool pullValue) {
            setState(() {
              _exListSort.update('Pull-Ups', (value) => pullValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Push-Ups'),
          value: _exListSort['Push-Ups'],
          onChanged: (bool pushValue) {
            setState(() {
              _exListSort.update('Push-Ups', (value) => pushValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Sit-Ups'),
          value: _exListSort['Sit-Ups'],
          onChanged: (bool sitValue) {
            setState(() {
              _exListSort.update('Sit-Ups', (value) => sitValue);
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Steps'),
          value: _exListSort['Steps'],
          onChanged: (bool stepValue) {
            setState(() {
              _exListSort.update('Steps', (value) => stepValue);
            });
          },
        ),
      ],
    );
  }
}
