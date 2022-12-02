// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:omega_clock/home.dart';
import 'package:omega_clock/modules/notifications.dart';

import '../modules/set_timer_finish.dart';

class OnTimer extends StatefulWidget {
  VoidCallback voidCall;
  OnTimer(this.voidCall, {super.key});

  @override
  State<OnTimer> createState() => _OnTimerState();
}

class _OnTimerState extends State<OnTimer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Time is up",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        OutlinedButton(
            onPressed: widget.voidCall, child: Text("Timer sound stop")),
      ],
    );
  }
}
