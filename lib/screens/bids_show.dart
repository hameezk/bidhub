import 'package:bidhub/config/colors.dart';
import 'package:bidhub/config/size.dart';
import 'package:bidhub/config/theme.dart';
import 'package:bidhub/models/auction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

class ShowAllCarBids extends StatefulWidget {
  final AuctionModel auctionModel;
  const ShowAllCarBids({super.key, required this.auctionModel});

  @override
  State<ShowAllCarBids> createState() => _ShowAllCarBidsState();
}

class _ShowAllCarBidsState extends State<ShowAllCarBids> {
  Uuid uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bids'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height(context) * 0.85,
            width: width(context),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("auction")
                    .where("id", isEqualTo: widget.auctionModel.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      Map<String, dynamic> auctionMap =
                          dataSnapshot.docs[0].data() as Map<String, dynamic>;
                      AuctionModel auctionModel =
                          AuctionModel.fromMap(auctionMap);
                      return buildBiddsList(context, auctionModel);
                    } else {
                      return const Center(child: Text('No bids to show...'));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  buildBiddsList(BuildContext context, AuctionModel auctionModel) {
    return (auctionModel.bids!.isEmpty)
        ? const Center(
            child: Text('No bids to show...'),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: auctionModel.bids!.length,
            itemBuilder: (context, index) {
              List orderedBids = auctionModel.bids!.reversed.toList();
              Map bids = orderedBids[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: (index == 0) ? Colors.yellow[600] : textColorDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: textColorLight,
                        backgroundImage: AssetImage(
                          (index > 2)
                              ? 'assets/medal.png'
                              : 'assets/$index.png',
                        ),
                      ),
                      title: Text(
                        bids['bidderName'],
                        style: myTheme.textTheme.displaySmall!.copyWith(
                            color:
                                (index == 0) ? textColorDark : textColorLight),
                      ),
                      subtitle: Text(
                        bids['bidValue'],
                        style: myTheme.textTheme.displayMedium!.copyWith(
                            color:
                                (index == 0) ? textColorDark : textColorLight,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: (bids['bidderId'] == UserModel.loggedinUser!.id)
                          ? const Icon(
                              Icons.person,
                              color: containerColor,
                              size: 30,
                            )
                          : Container(
                              height: 0,
                              width: 0,
                            ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
