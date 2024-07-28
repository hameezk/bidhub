// ignore_for_file: use_build_context_synchronously

import 'package:bidhub/config/countdown.dart';
import 'package:bidhub/config/navigate.dart';
import 'package:bidhub/config/snackbar.dart';
import 'package:bidhub/helpers/firebase_helper.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/bids_show_property.dart';
import 'package:bidhub/screens/property_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../config/colors.dart';
import '../config/get_chatroom.dart';
import '../config/size.dart';
import '../models/chatroom_model.dart';
import '../models/property_model.dart';
import 'chat_page.dart';

class BiddingPageProperty extends StatefulWidget {
  final PropertyModel propertyModel;
  const BiddingPageProperty({super.key, required this.propertyModel});

  @override
  State<BiddingPageProperty> createState() => _BiddingPagePropertyState();
}

class _BiddingPagePropertyState extends State<BiddingPageProperty> {
  TextEditingController bidController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel? ownerModel;
  Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Auction Bidding'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("properties")
              .where("id", isEqualTo: widget.propertyModel.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
              Map<String, dynamic> auctionMap =
                  dataSnapshot.docs[0].data() as Map<String, dynamic>;
              PropertyModel propertyModel = PropertyModel.fromMap(auctionMap);
              if (DateTime.parse(propertyModel.endDate ?? '')
                  .isBefore(DateTime.now())) {
                endAuction(
                  context,
                  widget.propertyModel,
                );
              }
              return buildBiddingForm(context, propertyModel);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  buildBiddingForm(BuildContext context, PropertyModel propertyModel) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: height(context) * 0.2,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: propertyModel.images!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height(context) * 0.18,
                        width: height(context) * 0.18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: lightBlack,
                          image: DecorationImage(
                            image: NetworkImage(
                              propertyModel.images![index],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Car name and current bid.
              Text(
                widget.propertyModel.location ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Owner Details',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColorLight),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: getOwnerModel(propertyModel),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: textColorLight,
                                foregroundImage:
                                    NetworkImage(ownerModel!.image ?? ''),
                                child: const CircularProgressIndicator(
                                    color: textColorDark),
                              ),
                              Text(
                                '   ${ownerModel!.name}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColorDark),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () async {
                              ChatroomModel? chatroomModel =
                                  await getChatroomModel(ownerModel!);
                              if (chatroomModel != null) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ChatRoom(
                                        targetUser: ownerModel!,
                                        chatRoom: chatroomModel,
                                        userModel: UserModel.loggedinUser!,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.chat_bubble_rounded,
                              color: textColorLight,
                            ),
                          ),
                        ],
                      );
                    }
                    return Container(
                      height: 0,
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Property Details',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColorLight),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  navigate(
                      context, PropertyDetails(propertyModel: propertyModel));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: width(context) * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: textColorLight.withOpacity(0.75),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'See Property Details   ',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColorDark),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: textColorDark,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: height(context) * 0.15,
                    width: width(context) * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: textColorLight.withOpacity(0.75)),
                    child: Center(
                      child: (DateTime.parse(propertyModel.endDate ?? '')
                              .isAfter(DateTime.now()))
                          ? Countdown(
                              endDate: DateTime.parse(
                                  widget.propertyModel.endDate ?? ""),
                              propertyModel: propertyModel,
                            )
                          : Text(
                              '00:00:00',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: secondaryColor),
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      navigate(context,
                          ShowAllPropertyBids(propertyModel: propertyModel));
                    },
                    child: Container(
                      height: height(context) * 0.15,
                      width: width(context) * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: textColorLight.withOpacity(0.75)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (propertyModel.winingBid == '')
                                      ? propertyModel.startingBid ?? ''
                                      : propertyModel.winingBid ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                ),
                                Text('Current Bid',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: textColorDark)),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_circle_right_outlined,
                              color: textColorDark,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              // Bid form.
              (propertyModel.isActive ?? false)
                  ? Column(
                      children: [
                        SizedBox(
                          width: width(context) * 0.6,
                          child: TextFormField(
                            controller: bidController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Your Bid',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (propertyModel.winingBid == '') {
                                if (double.parse(value ?? '0') <=
                                    double.parse(
                                        propertyModel.startingBid ?? '0')) {
                                  return 'Bid cannot be less than current bid';
                                }
                                return null;
                              } else {
                                if (double.parse(value ?? '0') <=
                                    double.parse(
                                        propertyModel.winingBid ?? '0')) {
                                  return 'Bid cannot be less than current bid';
                                }
                                return null;
                              }
                            },
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // Bid button.
                        ElevatedButton(
                          onPressed: () {
                            if (DateTime.now().isBefore(
                                DateTime.parse(propertyModel.endDate ?? ""))) {
                              if (_formKey.currentState!.validate()) {
                                Map currentBid = {
                                  'bidId': uuid.v1(),
                                  'bidderId': UserModel.loggedinUser!.id,
                                  'bidderName': UserModel.loggedinUser!.name,
                                  'bidderImage': UserModel.loggedinUser!.image,
                                  'bidValue': bidController.text.trim(),
                                };
                                uploadBid(propertyModel, currentBid);
                              }
                            } else {
                              showCustomSnackbar(
                                  context: context,
                                  content: 'Bidding Event has been ended!');
                            }
                          },
                          child: const Text('Place Bid'),
                        ),
                      ],
                    )
                  : Container(height: 0),
            ],
          ),
        ),
      ),
    );
  }

  getOwnerModel(PropertyModel propertyModel) async {
    ownerModel =
        await FirebaseHelper.getUserModelById(propertyModel.ownerId ?? '');
  }

  Future<void> uploadBid(PropertyModel propertyModel, Map currentBid) async {
    PropertyModel updatedPropertyModel = propertyModel;
    if (updatedPropertyModel.bids == []) {
      updatedPropertyModel.bids = [currentBid];
    } else {
      updatedPropertyModel.bids!.add(currentBid);
    }
    updatedPropertyModel.winingBid = currentBid['bidValue'];
    await FirebaseFirestore.instance
        .collection("auction")
        .doc(updatedPropertyModel.id)
        .set(updatedPropertyModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("New bid added"),
          ),
        );
      },
    );
    UserModel userModel = UserModel.loggedinUser!;
    if (userModel.recentBids == []) {
      userModel.recentBids = [propertyModel.id];
    } else {
      if (userModel.recentBids!.contains(propertyModel.id)) {
      } else {
        userModel.recentBids!.add(propertyModel.id);
      }
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.id)
        .set(userModel.toMap());
  }

  endAuction(BuildContext context, PropertyModel propertyModel) async {
    propertyModel.isActive = false;
    await FirebaseFirestore.instance
        .collection("properties")
        .doc(propertyModel.id)
        .set(propertyModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("Auction closed"),
          ),
        );
      },
    );
  }
}
