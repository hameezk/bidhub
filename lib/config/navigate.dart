import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

navigate(BuildContext context, Widget nextScreen) {
  Navigator.push(
    context,
    PageTransition(
      alignment: Alignment.bottomCenter,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 600),
      type: PageTransitionType.rightToLeft,
      child: nextScreen,
    ),
  );
}
