import 'package:flutter/material.dart';

class ZigzagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double zigzagWidth = 15.0;
    double zigzagHeight = 9.0;

    path.moveTo(0, 0);

    for (double i = 0; i < size.width; i += zigzagWidth) {
      path.lineTo(i + zigzagWidth / 2, zigzagHeight);
      path.lineTo(i + zigzagWidth, 0);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
