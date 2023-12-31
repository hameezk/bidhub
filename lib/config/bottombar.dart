import 'package:bidhub/config/size.dart';
import 'package:bidhub/models/user_model.dart';
import 'package:bidhub/screens/add_car_auction.dart';
import 'package:bidhub/screens/chats.dart';
import 'package:bidhub/screens/home_screen_customer.dart';
import 'package:bidhub/screens/home_screen_seller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/user_profile_customer.dart';
import '../screens/user_profile_seller.dart';
import 'colors.dart';
import 'navigate.dart';

Positioned buildNavBar(BuildContext context, int pageIndex) {
  return Positioned(
    bottom: 25,
    right: 15,
    left: 15,
    child: (UserModel.loggedinUser!.role == 'Customer')
        ? customerBottomBar(context, pageIndex)
        : sellerBottombar(context, pageIndex),
  );
}

Container sellerBottombar(BuildContext context, int pageIndex) {
  return Container(
    height: 90,
    width: width(context) * 0.8,
    decoration: BoxDecoration(
        color: containerColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: textColorLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
              onPressed: () {
                if (pageIndex == 0) {
                } else {
                  navigate(context, const HomeScreenSeller());
                }
              },
              icon: const Icon(
                Icons.home,
                color: textColorDark,
                size: 28,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: textColorLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
              onPressed: () {
                if (pageIndex == 2) {
                } else {
                  navigate(context, const AddAuction());
                }
              },
              icon: const Icon(
                Icons.car_repair,
                color: textColorDark,
                size: 28,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: textColorLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
              onPressed: () {
                if (pageIndex == 1) {
                } else {
                  navigate(context, const ChatPage());
                }
              },
              icon: const Icon(
                CupertinoIcons.chat_bubble_2_fill,
                color: textColorDark,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Container customerBottomBar(BuildContext context, int pageIndex) {
  return Container(
    height: 90,
    width: width(context) * 0.8,
    decoration: BoxDecoration(
        color: containerColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: textColorLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
              onPressed: () {
                if (pageIndex == 0) {
                } else {
                  navigate(context, const HomeScreenCustomer());
                }
              },
              icon: const Icon(
                Icons.home,
                color: textColorDark,
                size: 28,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: textColorLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
              onPressed: () {
                if (pageIndex == 1) {
                } else {
                  navigate(context, const ChatPage());
                }
              },
              icon: const Icon(
                CupertinoIcons.chat_bubble_2_fill,
                color: textColorDark,
                size: 28,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: textColorLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: IconButton(
              onPressed: () {
                if (pageIndex == 2) {
                } else {
                  navigate(context, const UserProfileCustomer());
                }
              },
              icon: const Icon(
                Icons.person,
                color: textColorDark,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
