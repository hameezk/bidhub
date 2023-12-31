import 'package:bidhub/config/colors.dart';
import 'package:bidhub/config/loading_animation.dart';
import 'package:bidhub/config/theme.dart';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, String title) {
  AlertDialog loadingDialog = AlertDialog(
    content: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const RotatingImage(
            imageUrl: 'assets/logo.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: myTheme.textTheme.bodyLarge!.copyWith(
              color: textColorDark,
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loadingDialog;
      });
}
