import 'package:bidhub/helpers/firebase_helper.dart';
import 'package:bidhub/screens/home_screen_customer.dart';
import 'package:bidhub/screens/home_screen_seller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'config/theme.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'screens/splash_screen.dart';

var uuid = const Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    UserModel? thisUserModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUserModel != null) {
      UserModel.loggedinUser = thisUserModel;
      runApp(const MyAppLoggedIn());
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: const SplashScreen(),
    );
  }
}

class MyAppLoggedIn extends StatelessWidget {
  const MyAppLoggedIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      home: (UserModel.loggedinUser!.role == 'Seller')
          ? const HomeScreenSeller()
          : const HomeScreenCustomer(),
    );
  }
}
