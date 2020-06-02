import 'package:com/Design/colours.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopupScreen extends StatefulWidget {

  final String title;
  final String text;
  final String btnText;

  PopupScreen({@required this.title, @required this.text, @required this.btnText});

  @override
  _PopupScreenState createState() => _PopupScreenState();
}

class _PopupScreenState extends State<PopupScreen> {

  void _dialogMsg(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: mainColor,
            title: Text(
                widget.title,
                style: TextStyle(
                  color: Color.fromRGBO(222, 222, 222, 1),
                  fontFamily: 'PTSerif',
                ),
            ),
            content: Text(
                widget.text,
                style: TextStyle(
                  color: Color.fromRGBO(222, 222, 222, 1),
                  fontFamily: 'PTSerif',
                ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(widget.btnText, style: TextStyle(color: Colors.red.shade700),),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _dialogMsg(),
      child: Container(
        padding: EdgeInsets.all(12.0),
        alignment: Alignment.topRight,
        child: Container(
          width: 40,
          height: 40,
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(56.0), color: textColor),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(56.0),
              color: Colors.black,
            ),
            child: Icon(FontAwesomeIcons.question,
              size: 20.0,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
