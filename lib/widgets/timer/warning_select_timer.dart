// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class WarningSelectTimer extends StatefulWidget {
  BuildContext context;
  WarningSelectTimer(this.context, {super.key});

  @override
  State<WarningSelectTimer> createState() => _WarningSelectTimerState();
}

class _WarningSelectTimerState extends State<WarningSelectTimer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        _visibleNothing = true;
      });
    });
  }

  bool _visibleNothing = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _visibleNothing ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 700),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose time for your timer",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Theme.of(widget.context).dialogBackgroundColor),
            )
          ],
        ),
      ),
    );
  }
}
