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
        Padding(
          padding: const EdgeInsets.only(bottom: 200),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Text(
              "Time is up",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 37,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 155,
          width: 155,
          child: OutlinedButton(
            onPressed: widget.voidCall,
            child: Text(
              "STOP",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.blue, // <-- Button color
              foregroundColor: Colors.red, // <-- Splash color
            ),
          ),
        ),
      ],
    );
  }
}
