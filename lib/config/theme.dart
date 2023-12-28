import 'package:bidhub/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData myTheme = ThemeData(
  scaffoldBackgroundColor: canvasColor,
  primarySwatch: Colors.grey,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.montserrat(
      color: darkBlack,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    ),
    displayMedium: GoogleFonts.montserrat(
      color: darkBlack,
      fontSize: 26,
      fontWeight: FontWeight.normal,
    ),
    displaySmall: GoogleFonts.montserrat(
      color: darkBlack,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: GoogleFonts.montserrat(
      color: darkBlack,
      fontSize: 12,
    ),
    bodyLarge: GoogleFonts.montserrat(
      color: mediumBlack,
      fontSize: 14,
    ),
  ),
);
