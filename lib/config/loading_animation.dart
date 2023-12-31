import 'package:flutter/material.dart';

class RotatingImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const RotatingImage(
      {super.key, required this.imageUrl, required this.width, required this.height});

  @override
  RotatingImageState createState() => RotatingImageState();
}

class RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Image.asset(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
