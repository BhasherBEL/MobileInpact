import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/internal_data.dart';
import '../../services/time.dart';

class TimeElapsed extends StatefulWidget {
  const TimeElapsed({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeElapsed> createState() => _TimeElapsedState();
}

class _TimeElapsedState extends State<TimeElapsed> {
  late Timer _timer;
  DateTime lastUpdate = InternalData.lastUpdate;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _update());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _update() {
    setState(() {
      lastUpdate = InternalData.lastUpdate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Last update : " +
          (InternalData.lastUpdate.millisecondsSinceEpoch > 0
              ? timeElapsed(InternalData.lastUpdate)
              : 'Never'),
    );
  }
}
