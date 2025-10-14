import 'package:flutter/material.dart';

class KConstant {
  static const String themeModKey = 'isDarkKey';
}

class KTextStyle {
  static const TextStyle normalText = TextStyle(
    color: Colors.deepPurple,
    fontSize: 19,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle descriptionText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle cardtitleText = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle descriptionTextQuestion = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle descriptionTextAnswer = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.green,
  );

  static const TextStyle titleText = TextStyle(
    fontSize: 35,
    fontWeight: FontWeight.normal,
    letterSpacing: 50.0,
    decoration: TextDecoration.none,
    color: Color.fromARGB(255, 169, 199, 251),
    fontFamily: 'Arial',
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}
