import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCircularProgressIndicator extends StatefulWidget {
  final double size;
  final String imagePath;

  CustomCircularProgressIndicator({
    this.size = 50.0,
    this.imagePath = 'assets/logo_vetorial.svg',
  });

  @override
  _CustomCircularProgressIndicatorState createState() =>
      _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState
    extends State<CustomCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
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
    return Center(
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 2.0).animate(_controller),
        child: SvgPicture.asset(
          color: Colors.white,
          widget.imagePath,
          height: widget.size,
          width: widget.size,
        ),
      ),
    );
  }
}
