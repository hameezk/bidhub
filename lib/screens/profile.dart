// ignore_for_file: use_build_context_synchronously

import 'package:bidhub/config/colors.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key? key,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            alignment: Alignment.bottomLeft,
            height: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: secondaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 1,
                            backgroundColor: Colors.white,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 120,
                                  backgroundColor: Colors.transparent,
                                  foregroundImage: NetworkImage(
                                      UserModel.loggedinUser!.image ?? ""),
                                  child: const CircularProgressIndicator(
                                    color: containerColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                      child: const Text(
                                        "Change profile",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) {
                                        //       return EditProfile(
                                        //           userModel: widget.userModel,
                                        //           firebaseUser:
                                        //               widget.firebaseUser);
                                        //     },
                                        //   ),
                                        // );
                                      }),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.transparent,
                      foregroundImage:
                          NetworkImage(UserModel.loggedinUser!.image ?? ''),
                      child: const CircularProgressIndicator(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {
                  //         Navigator.popUntil(context, (route) => route.isFirst);
                  //         Navigator.pushReplacement(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) {
                  //               return HomePage(
                  //                   userModel: widget.userModel,
                  //                   firebaseUser: widget.firebaseUser);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //       icon: const Icon(
                  //         Icons.home,
                  //         color: Colors.white,
                  //         size: 30,
                  //       ),
                  //     ),
                  //     IconButton(
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) {
                  //               return EditProfile(
                  //                   userModel: widget.userModel,
                  //                   firebaseUser: widget.firebaseUser);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //       icon: const Icon(
                  //         Icons.settings,
                  //         color: Colors.white,
                  //         size: 30,
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  alignment: Alignment.topLeft,
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const SplashScreen();
                      }),
                    );
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 50,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "  Log Out",
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            UserModel.loggedinUser!.name ?? "",
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      Row(children: [
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          UserModel.loggedinUser!.email ?? "",
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 18,
                            color: containerColor,
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
