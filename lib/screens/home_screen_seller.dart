import 'package:bidhub/config/colors.dart';
import 'package:bidhub/config/navigate.dart';
import 'package:bidhub/config/size.dart';
import 'package:bidhub/models/property_model.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/auction_details.dart';
import 'package:bidhub/screens/property_details.dart';
import 'package:bidhub/screens/user_profile_seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/bottombar.dart';
import '../models/auction_model.dart';

class HomeScreenSeller extends StatefulWidget {
  const HomeScreenSeller({super.key});

  @override
  State<HomeScreenSeller> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenSeller> {
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  bool isCars = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: canvasColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: height(context) * 0.30,
                child: Column(
                  children: [
                    SizedBox(
                      height: height(context) * 0.06,
                    ),
                    Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height(context) * 0.24,
                                  width: height(context) * 0.24,
                                  child: Image.asset(
                                    'assets/logo.png',
                                    opacity: const AlwaysStoppedAnimation(.05),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 48.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Welcome,\n${UserModel.loggedinUser!.name}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // auctionModel.uploadDemoData(context);
                                          navigate(context,
                                              const UserProfileSeller());
                                        },
                                        child: SizedBox(
                                          height: height(context) * 0.1,
                                          width: height(context) * 0.1,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(2000),
                                            child: Image.network(
                                              UserModel.loggedinUser!.image ??
                                                  '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: height(context) * 0.7,
                width: width(context),
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 60,
                            width: width(context) * 0.75,
                            decoration: BoxDecoration(
                                color: containerColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: searchController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: textColorLight),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search ${(isCars) ? 'Cars' : 'Properties'}...',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: textColorDark),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      searchKey = searchController.text
                                          .toLowerCase()
                                          .trim();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1000),
                                color: textColorLight,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isCars = !isCars;
                                    });
                                  },
                                  icon: Icon(
                                    (!isCars)
                                        ? CupertinoIcons.car_detailed
                                        : CupertinoIcons.house_alt_fill,
                                    color: textColorDark,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (isCars) ? buildCarList() : buildPropertyList(),
                  ],
                ),
              ),
            ],
          ),
          buildNavBar(context, 0),
        ],
      ),
    );
  }

  buildPropertyList() {
    // PropertyModel.uploadDemoData(context);
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("properties")
            .where("ownerId", isEqualTo: UserModel.loggedinUser!.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

              if (dataSnapshot.docs.isNotEmpty) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> propertiesMap =
                          dataSnapshot.docs[index].data()
                              as Map<String, dynamic>;

                      PropertyModel propertyModel =
                          PropertyModel.fromMap(propertiesMap);
                      if (propertyModel.location!
                          .toLowerCase()
                          .contains(searchKey)) {
                        return buildPropertyCard(
                          propertyModel,
                          (index == dataSnapshot.docs.length - 1),
                        );
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
    );
  }

  buildAuctionCard(AuctionModel auctionModel, bool isLast) {
    return GestureDetector(
      onTap: () {
        navigate(context, AuctionDetails(auctionModel: auctionModel));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: (isLast) ? 150.0 : 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: width(context) * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: containerColor.withOpacity(0.3),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
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
      ),
    );
  }

  buildPropertyCard(PropertyModel propertyModel, bool isLast) {
    return GestureDetector(
      onTap: () {
        navigate(context, PropertyDetails(propertyModel: propertyModel));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: (isLast) ? 150.0 : 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: width(context) * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: containerColor.withOpacity(0.3),
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
                          propertyModel.images![0],
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
                            propertyModel.location ?? "",
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                propertyModel.type ?? "",
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
                                DateTime.parse(propertyModel.startDate ?? '')),
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
      ),
    );
  }

  buildCarList() {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("auction")
            .where("ownerId", isEqualTo: UserModel.loggedinUser!.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;

              if (dataSnapshot.docs.isNotEmpty) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: dataSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> auctionMap = dataSnapshot.docs[index]
                          .data() as Map<String, dynamic>;

                      AuctionModel auctionModel =
                          AuctionModel.fromMap(auctionMap);
                      if (auctionModel.carName!
                          .toLowerCase()
                          .contains(searchKey)) {
                        return buildAuctionCard(
                          auctionModel,
                          (index == dataSnapshot.docs.length - 1),
                        );
                      } else {
                        return Container();
                      }
                    });
              } else {
                return const Text(
                  "No results found!c12",
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
                "No results found!c2",
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
    );
  }
}
