import 'package:flutter/material.dart';

Widget awaitResult() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black.withOpacity(0.4),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}