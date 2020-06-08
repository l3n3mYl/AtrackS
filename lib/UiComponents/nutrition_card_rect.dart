import 'package:flutter/material.dart';

class NutritionCardTriangle extends StatelessWidget {

  final Color _color;

  NutritionCardTriangle(this._color);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomRect(),
          child: Container(
            color: _color,
          ),
        ),
      ],
    );
  }
}

class CustomRect extends CustomClipper<Path>{
  @override
  getClip(Size size) {
    Path path = new Path();
    final double height = size.height;
    final double width = size.width;

    path.lineTo(width * 0.4 - 25, 0.0);
    path.lineTo(width * 0.45, height);
    path.lineTo(0.0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

}
