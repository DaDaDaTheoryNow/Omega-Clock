import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

class Vibro {
  void vibration() async {
    for (var i = 0; i < 3; i++) {
      switch (i) {
        case 1:
          if (await Vibration.hasVibrator() == true) {
            continue;
          } else {
            Fluttertoast.showToast(
                msg: "Vibration not available for your devices",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            break;
          }
        case 2:
          if (await Vibration.hasCustomVibrationsSupport() == true) {
            Vibration.vibrate(duration: 15000);
          } else {
            Vibration.vibrate();
            await Future.delayed(Duration(seconds: 15));
            Vibration.vibrate();
          }
      }
    }
  }
}
