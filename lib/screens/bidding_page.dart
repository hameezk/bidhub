// ignore_for_file: use_build_context_synchronously

import 'package:bidhub/config/countdown.dart';
import 'package:bidhub/config/navigate.dart';
import 'package:bidhub/config/snackbar.dart';
import 'package:bidhub/helpers/firebase_helper.dart';
import 'package:bidhub/models/auction_model.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/auction_details.dart';
import 'package:bidhub/screens/bids_show.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../config/colors.dart';
import '../config/get_chatroom.dart';
import '../config/size.dart';
import '../models/chatroom_model.dart';
import '../models/message_model.dart';
import 'chat_page.dart';

class BiddingPage extends StatefulWidget {
  final AuctionModel auctionModel;
  const BiddingPage({super.key, required this.auctionModel});

  @override
  State<BiddingPage> createState() => _BiddingPageState();
}

class _BiddingPageState extends State<BiddingPage> {
  TextEditingController bidController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel? ownerModel;
  Uuid uuid = const Uuid();

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
              if (DateTime.parse(auctionModel.endDate ?? '')
                  .isBefore(DateTime.now())) {
                endAuction(
                  context,
                  widget.auctionModel,
                );
              }
              return buildBiddingForm(context, auctionModel);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  buildBiddingForm(BuildContext context, AuctionModel auctionModel) {
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
                  navigate(context, AuctionDetails(auctionModel: auctionModel));
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
                      child: (DateTime.parse(auctionModel.endDate ?? '')
                              .isAfter(DateTime.now()))
                          ? Countdown(
                              endDate: DateTime.parse(
                                  widget.auctionModel.endDate ?? ""),
                              auctionModel: auctionModel,
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
                      navigate(
                          context, ShowAllCarBids(auctionModel: auctionModel));
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
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              // Bid form.
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
                    if (auctionModel.winingBid == '') {
                      if (double.parse(value ?? '0') <=
                          double.parse(auctionModel.startingBid ?? '0')) {
                        return 'Bid cannot be less than current bid';
                      }
                      return null;
                    } else {
                      if (double.parse(value ?? '0') <=
                          double.parse(auctionModel.winingBid ?? '0')) {
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
                  if (DateTime.now()
                      .isBefore(DateTime.parse(auctionModel.endDate ?? ""))) {
                    if (_formKey.currentState!.validate()) {
                      Map currentBid = {
                        'bidId': uuid.v1(),
                        'bidderId': UserModel.loggedinUser!.id,
                        'bidderName': UserModel.loggedinUser!.name,
                        'bidderImage': UserModel.loggedinUser!.image,
                        'bidValue': bidController.text.trim(),
                      };
                      uploadBid(auctionModel, currentBid);
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
          ),
        ),
      ),
    );
  }

  getOwnerModel(AuctionModel auctionModel) async {
    ownerModel =
        await FirebaseHelper.getUserModelById(auctionModel.ownerId ?? '');
  }

  Future<void> uploadBid(AuctionModel auctionModel, Map currentBid) async {
    AuctionModel updatedAuctionModel = auctionModel;
    if (updatedAuctionModel.bids == []) {
      updatedAuctionModel.bids = [currentBid];
    } else {
      updatedAuctionModel.bids!.add(currentBid);
    }
    updatedAuctionModel.winingBid = currentBid['bidValue'];
    await FirebaseFirestore.instance
        .collection("auction")
        .doc(updatedAuctionModel.id)
        .set(updatedAuctionModel.toMap())
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
      userModel.recentBids = [auctionModel.id];
    } else {
      if (userModel.recentBids!.contains(auctionModel.id)) {
      } else {
        userModel.recentBids!.add(auctionModel.id);
      }
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.id)
        .set(userModel.toMap());
  }

  endAuction(BuildContext context, AuctionModel auctionModel) async {
    auctionModel.isActive = false;
    await FirebaseFirestore.instance
        .collection("auction")
        .doc(auctionModel.id)
        .set(auctionModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("Auction closed"),
          ),
        );
        Map winningBid = auctionModel.bids!.last;
        sendMessage(winningBid, auctionModel.id ?? '');
      },
    );
  }

  Future<void> sendMessage(Map winningBid, String auctionModelId) async {
    UserModel? winnerUserodel =
        await FirebaseHelper.getUserModelById(winningBid['bidderId']);
    ChatroomModel? chatroomModel = await getChatroomModelAdmin(winnerUserodel!);
    if (chatroomModel != null) {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: 'tBuAzA90NffCXIyfMiKR0Nw3RHc2',
        createdon: DateTime.now().toString(),
        text: 'Congragulations on winning the bid',
        seen: false,
        auctionLink: auctionModelId,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomModel.chatroomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      chatroomModel.lastMessage = 'Congragulations on winning the bid';
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomModel.chatroomId)
          .set(chatroomModel.toMap());
    }
  }
}
