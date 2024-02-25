import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppUiStyles {
  static const double borderRadius = 9;

  static TextStyle dataInputTitleTextStyle = GoogleFonts.rubik(
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white));
  static TextStyle TitleTextStyle = GoogleFonts.rubik(
      textStyle: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white));
  static TextStyle bottomTitleTextStyle = GoogleFonts.rubik(
      textStyle: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white));
  static TextStyle bottomClickableTextStyle = GoogleFonts.rubik(
      textStyle: const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Color(0xFFA0AAFF),
  ));

  static TextStyle dataInputHintTextStyle = GoogleFonts.rubik(
      textStyle: const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w300,
    color: Color(0xFF909090),
  ));
}
