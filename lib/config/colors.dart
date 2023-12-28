import 'package:flutter/material.dart';

const Color white = Color(0xFFFFFFFF);
const Color offWhite = Color(0xFFFEFEFE);
const Color darkWhite = Color(0xFFF3F7F9);
const Color lightBlack = Color(0xFFACADAF);
const Color darkBlack = Color(0xFF040303);
const Color mediumBlack = Colors.black54;
const Color secondaryColor = Color.fromRGBO(37, 57, 48, 1);
const Color canvasColor = Color(0xFFFFFFFF);
const Color containerColor = Color.fromRGBO(78, 95, 87, 1);
const Color textColorLight = Color.fromRGBO(178, 191, 184, 1);
const Color textColorDark = Color.fromRGBO(123, 123, 123, 1);

MaterialColor getMaterialColor(Color color) {
  final Map<int, Color> shades = {
    50: const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };
  return MaterialColor(color.value, shades);
}
