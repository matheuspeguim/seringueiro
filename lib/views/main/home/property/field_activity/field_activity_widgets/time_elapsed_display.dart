import 'dart:async';
import 'package:flutter/material.dart';

class TimeElapsedDisplay extends StatefulWidget {
  final DateTime startTime;

  const TimeElapsedDisplay({Key? key, required this.startTime})
      : super(key: key);

  @override
  _TimeElapsedDisplayState createState() => _TimeElapsedDisplayState();
}

class _TimeElapsedDisplayState extends State<TimeElapsedDisplay> {
  Timer? _timer;
  Duration _elapsed = Duration();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final elapsed = now.difference(widget.startTime);
      setState(() {
        _elapsed = elapsed;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        "${_elapsed.inHours.toString().padLeft(2, '0')}:${(_elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(_elapsed.inSeconds % 60).toString().padLeft(2, '0')}";

    return Text(
      formattedTime,
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
