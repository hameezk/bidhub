// ignore_for_file: use_build_context_synchronously

import 'package:bidhub/config/countdown.dart';
import 'package:bidhub/config/navigate.dart';
import 'package:bidhub/helpers/firebase_helper.dart';
import 'package:bidhub/models/auction_model.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/auction_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../config/get_chatroom.dart';
import '../config/size.dart';
import '../models/chatroom_model.dart';
import 'chat_page.dart';

class BiddingPage extends StatefulWidget {
  final AuctionModel auctionModel;
  const BiddingPage({super.key, required this.auctionModel});

  @override
  State<BiddingPage> createState() => _BiddingPageState();
}

class _BiddingPageState extends State<BiddingPage> {
  TextEditingController bidController = TextEditingController();
  UserModel? ownerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Auction Bidding'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("auction")
              .where("id", isEqualTo: widget.auctionModel.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot dataSnapshot = snapshot.data as QuerySnapshot;
              Map<String, dynamic> auctionMap =
                  dataSnapshot.docs[0].data() as Map<String, dynamic>;
              AuctionModel auctionModel = AuctionModel.fromMap(auctionMap);
              return buildBiddingForm(context, auctionModel);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Column buildBiddingForm(BuildContext context, AuctionModel auctionModel) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: height(context) * 0.2,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: auctionModel.images!.length,
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
                                auctionModel.images![index],
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
                  widget.auctionModel.carName ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                    future: getOwnerModel(auctionModel),
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
                        'Car Details',
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
                        context, AuctionDetails(auctionModel: auctionModel));
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
                                  'See Car Details   ',
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
                        child: Countdown(
                            endDate: DateTime.parse(
                                widget.auctionModel.endDate ?? "")),
                      ),
                    ),
                    Container(
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
                                  (auctionModel.winingBid == '')
                                      ? auctionModel.startingBid ?? ''
                                      : auctionModel.winingBid ?? '',
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
                  ],
                ),
                Text(
                  'Current Bid: ${auctionModel.startingBid}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),

                // Bid form.
                TextFormField(
                  controller: bidController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Bid',
                    border: OutlineInputBorder(),
                  ),
                ),

                // Bid button.
                ElevatedButton(
                  onPressed: () {
                    // Implement your bid logic here.
                  },
                  child: const Text('Place Bid'),
                ),

                // Timer for bid end.
                Text(
                  'Bid Ends in: ${widget.auctionModel.endDate}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getOwnerModel(AuctionModel auctionModel) async {
    ownerModel =
        await FirebaseHelper.getUserModelById(auctionModel.ownerId ?? '');
  }
}
