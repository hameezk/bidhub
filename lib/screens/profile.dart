// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:bidhub/config/bottombar.dart';
import 'package:bidhub/config/colors.dart';
import 'package:bidhub/config/navigate.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/edit_profile.dart';
import 'package:bidhub/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/size.dart';
import '../models/auction_model.dart';

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
        foregroundColor: textColorLight,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColorLight,
            fontSize: 25,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
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
                size: 25,
                color: textColorLight,
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                alignment: Alignment.bottomRight,
                height: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(1500),
                  ),
                  color: secondaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
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
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.transparent,
                          foregroundImage:
                              NetworkImage(UserModel.loggedinUser!.image ?? ''),
                          child: const CircularProgressIndicator(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0, top: 10),
                          child: IconButton(
                            onPressed: () {
                              navigate(
                                context,
                                EditProfile(
                                    newUserModel: UserModel.loggedinUser!),
                              );
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: secondaryColor,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
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
                          Row(
                            children: [
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
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("auction")
                      .where("ownerId", isEqualTo: UserModel.loggedinUser!.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;

                        if (dataSnapshot.docs.isNotEmpty) {
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> auctionMap =
                                    dataSnapshot.docs[index].data()
                                        as Map<String, dynamic>;

                                AuctionModel auctionModel =
                                    AuctionModel.fromMap(auctionMap);
                                if (auctionModel.carName!
                                    .toLowerCase()
                                    .contains('')) {
                                  return buildAuctionCard(auctionModel,
                                      (index == dataSnapshot.docs.length - 1));
                                } else {
                                  return Container();
                                }
                              });
                        } else {
                          return const Text(
                            "No results found!",
                            style: TextStyle(
                              color: Colors.blueGrey,
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return const Text(
                          "An error occoured!",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        );
                      } else {
                        return const Text(
                          "No results found!",
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        );
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
          buildNavBar(context, 2),
        ],
      ),
    );
  }

  Padding buildAuctionCard(AuctionModel auctionModel, bool isLast) {
    return Padding(
      padding: EdgeInsets.only(bottom: (isLast) ? 150.0 : 0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          width: width(context) * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: containerColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        auctionModel.images![0],
                        fit: BoxFit.cover,
                        height: 130,
                        width: width(context) * 0.4,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width(context) * 0.4,
                        child: Text(
                          auctionModel.carName ?? "",
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: textColorLight),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Text(
                              auctionModel.location ?? "",
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: textColorLight),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.0),
                          child: Icon(
                            Icons.timer,
                            color: textColorLight,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMM d, yyyy HH:mm').format(
                              DateTime.parse(auctionModel.startDate ?? '')),
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: textColorLight),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
