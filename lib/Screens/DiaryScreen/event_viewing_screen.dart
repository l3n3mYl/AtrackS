import 'package:com/Design/colours.dart';
import 'package:com/UiComponents/background_triangle_clipper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleEventScreen extends StatelessWidget {

  final String title, description;

  SingleEventScreen(this.title, this.description);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: mainColor,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              BackgroundTriangle(),
              Container(
                width: size.width,
                height: size.height,
                child: AspectRatio(
                  aspectRatio: 18 / 9,
                  child: Opacity(
                    opacity: 0.2,
                    child: Image(
                      image: AssetImage('images/main_pattern.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(26.0),
                          width: size.width,
                          child: Text(
                            '$title',
                            maxLines: null,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'PTSerif',
                              fontSize: 24.0
                            ),
                          ),
                        ),
                      Container(
                        height: 2.0,
                        width: size.width,
                        color: accentColor,
                      ),
                      Container(
                          padding: EdgeInsets.all(26.0),
                          width: size.width,
                          child: Text(
                            '$description',
                            maxLines: null,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white54,
                                fontFamily: 'PTSerif'
                            ),
                          ),
                        ),
                      SizedBox(height: 35.0,),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          alignment: Alignment.center,
                          width: 70.0,
                          height: 35.0,
                          child: Text(
                              'Close',
                            style: TextStyle(
                              color: textColor,
                              fontFamily: 'PTSerif'
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(123.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.grey.shade700,
                                Colors.grey.shade800,
                                Colors.black,
                                Colors.black,
                                Colors.black,
                                Colors.black,
                              ]
                            ),
                            border: Border.all(
                              color: textColor,
                              width: 2.0
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 35.0,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
