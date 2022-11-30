import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class FinishTimer {
  void vibration(bool play, int ms) async {
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
          if (play) {
            if (await Vibration.hasCustomVibrationsSupport() == true) {
              Vibration.vibrate(duration: ms);
            } else {
              Vibration.vibrate();
              await Future.delayed(Duration(milliseconds: ms));
              Vibration.vibrate();
            }
          } else {
            Vibration.cancel();
            break;
          }
      }
    }
  }

  void notificationSound(bool play) {
    if (play) {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: true, // Android only - API >= 28
        volume: 1, // Android only - API >= 28
        asAlarm: true, // Android only - all APIs
      );
    } else {
      FlutterRingtonePlayer.stop();
    }
  }
}
