import 'package:flutter/material.dart';

class BackgroundTriangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: FirstTriangle(),
          child: Container(
            color: Color.fromRGBO(38, 200, 0, 1).withOpacity(0.05),
          ),
        ),
        ClipPath(
          clipper: SecondTriangle(),
          child: Container(
            color: Color.fromRGBO(38, 200, 0, 1).withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}

class SecondTriangle extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    Path path = new Path();
    final double height = size.height;
    final double width = size.width;

    path.lineTo(0.0, height);
    path.lineTo(width, height);
    path.lineTo(width, height * 0.4);
    path.lineTo(0.0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

}

class FirstTriangle extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    Path path = new Path();
    final double height = size.height;
    final double width = size.width;

    path.lineTo(width, height);
    path.lineTo(0.0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

}
