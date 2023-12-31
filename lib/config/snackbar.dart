import 'package:flutter/material.dart';

showCustomSnackbar({required context, required content, Function()? onTap}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 2),
      content: GestureDetector(
        onTap: onTap,
        child: Text(
          content,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white70),
        ),
      ),
    ),
  );
}
