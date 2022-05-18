import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = Color.fromRGBO(166, 44, 0, 1);
  static const Color loginGradientEnd = Color.fromRGBO(116, 31, 0, 1);

  static const primaryGradient = LinearGradient(
      colors: [loginGradientStart, loginGradientEnd],
      stops: [0.0, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
