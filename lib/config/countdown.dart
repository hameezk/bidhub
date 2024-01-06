import 'package:bidhub/config/colors.dart';
import 'package:bidhub/config/get_chatroom.dart';
import 'package:bidhub/models/chatroom_model.dart';
import 'package:bidhub/models/property_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../helpers/firebase_helper.dart';
import '../models/auction_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class Countdown extends StatefulWidget {
  final AuctionModel? auctionModel;
  final PropertyModel? propertyModel;
  final DateTime endDate;
  const Countdown(
      {super.key,
      required this.endDate,
      this.auctionModel,
      this.propertyModel});

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  Uuid uuid = const Uuid();
  Stream<int> _timerStream(DateTime endTime) async* {
    while (endTime.isAfter(DateTime.now())) {
      yield endTime.difference(DateTime.now()).inSeconds;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  String _formatTime(int totalSeconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    int days = totalSeconds ~/ 86400;
    int hours = (totalSeconds % 86400) ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    if (totalSeconds == 0) {
      (widget.auctionModel == null)
          ? endAuctionProperty(context, widget.propertyModel!)
          : endAuctionCar(context, widget.auctionModel!);
    }
    return (days > 0)
        ? '$days:${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    DateTime endTime = widget.endDate;
    return StreamBuilder<int>(
      stream: _timerStream(endTime),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Text(
            '00:00:00',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: secondaryColor),
          );
        } else {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(snapshot.data ?? 0),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor),
                  ),
                  Text('Time left...',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: textColorDark)),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
      },
    );
  }

  endAuctionCar(BuildContext context, AuctionModel auctionModel) async {
    if (auctionModel.isActive ?? false) {
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
          sendMessageCar(winningBid, auctionModel.id ?? '');
        },
      );
    }
  }

  endAuctionProperty(BuildContext context, PropertyModel auctionModel) async {
    if (auctionModel.isActive ?? false) {
      auctionModel.isActive = false;
      await FirebaseFirestore.instance
          .collection("properties")
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
          sendMessageCar(winningBid, auctionModel.id ?? '');
        },
      );
    }
  }

  Future<void> sendMessageCar(Map winningBid, String auctionModelId) async {
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
        auctionType: (widget.auctionModel == null) ? 'property' : 'car',
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
