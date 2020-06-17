import 'package:flutter/material.dart';

class PictureTriangleCut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PTCut(),
      child: Container(
        color: Color.fromRGBO(38, 200, 0, 1).withOpacity(0.1),
      ),
    );
  }
}

class PTCut extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = new Path();
    final double height = size.height;
    final double width = size.width;

    path.lineTo(0.0, height);
    path.lineTo(width, height * 0.8);
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
