import 'package:flutter/material.dart';

height(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  return height;
}

width(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return width;
}
