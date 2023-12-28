import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bidhub/config/colors.dart';
import 'package:bidhub/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: containerColor,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(
              child: AnimatedSplashScreen(
            duration: 1200,
            backgroundColor: Colors.transparent,
            splashTransition: SplashTransition.rotationTransition,
            animationDuration: const Duration(seconds: 1, milliseconds: 100),
            pageTransitionType: PageTransitionType.fade,
            splash: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/logo.png"),
              ],
            ),
            nextScreen: const LoginPage(),
            splashIconSize: 450,
          )),
        ),
      ),
    );
  }
}
