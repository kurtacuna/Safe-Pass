import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// All text styles used throughout the app
class AppTextStyles {
  static TextStyle _dmSans({
    required double? fontSize,
    Color? color,
    FontWeight? fontWeight
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight
    );
  }

  // static TextStyle get bigStyle => TextStyle(
  //   fontSize: 20
  // );
  // static TextStyle get defaultStyle => TextStyle(
  //   fontSize: 14
  // );

  static TextStyle biggestPlus2Style = _dmSans(
    fontSize: 64,
  );
  static TextStyle biggestPlusStyle = _dmSans(
    fontSize: 32,
  );
  static TextStyle biggestStyle = _dmSans(
    fontSize: 20
  );
  static TextStyle biggerStyle = _dmSans(
    fontSize: 18
  );
  static TextStyle bigStyle = _dmSans(
    fontSize: 16,
  );
  static TextStyle defaultStyle = _dmSans(
    fontSize: 14,
  );
  static TextStyle smallStyle = _dmSans(
    fontSize: 12,
  );
  static TextStyle smallerStyle = _dmSans(
    fontSize: 10,
  );
}