// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:omega_clock/generated/locale_keys.g.dart';
import 'package:omega_clock/modules/notifications.dart';
import 'package:omega_clock/modules/set_timer_finish.dart';

import 'package:neon_circular_timer/neon_circular_timer.dart';
import 'package:omega_clock/screens/ontimer.dart';

import '../../home.dart';

class TimerCountDown extends StatefulWidget {
  int _duration;
  BuildContext context_app;
  TimerCountDown(this._duration, this.context_app, {Key? key})
      : super(key: key);

  @override
  State<TimerCountDown> createState() => _TimerCountDownState();
}

bool blurWidget = false;

class _TimerCountDownState extends State<TimerCountDown> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  final CountDownController controller = new CountDownController();

  bool _start = false;

  void startTimer() {
    Future.delayed(const Duration(milliseconds: 1), () {
      controller.start();
      controller.pause();
    });
  }

  setNotification(title, body) {
    Noti.showBigTextNotification(
        title: title, body: body, fln: flutterLocalNotificationsPlugin);
  }

  void closeTimer() {
    setState(() {
      FinishTimer().vibration(false);
      FinishTimer().notificationSound(false);
      blurWidget = false;
    });
    Noti.deleteAllNotifications(fln: flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: blurWidget,
                child: Column(
                  children: [
                    NeonCircularTimer(
                        onComplete: () {
                          FinishTimer().vibration(true);
                          FinishTimer().notificationSound(true);
                          setState(() {
                            // includes blur and timer off page
                            blurWidget = true;
                            _start = false;

                            // set notification
                            setNotification(LocaleKeys.timer_main_Timer.tr(),
                                LocaleKeys.timer_main_Time_is_up.tr());

                            // puts the last durations
                            startTimer();
                          });
                        },
                        textFormat: TextFormat.MM_SS,
                        textStyle: TextStyle(
                          fontSize: 45,
                          fontFamily: "PTMono",
                        ),
                        autoStart: false,
                        isReverse: true,
                        isReverseAnimation: true,
                        width: 300,
                        controller: controller,
                        duration: widget._duration,
                        strokeWidth: 10,
                        isTimerTextShown: true,
                        neumorphicEffect: true,
                        outerStrokeColor: Colors.grey.shade100,
                        innerFillGradient: LinearGradient(colors: [
                          Color.fromARGB(255, 31, 197, 19),
                          Color.fromARGB(255, 186, 144, 67),
                          Color.fromARGB(255, 31, 197, 19)
                        ]),
                        neonGradient: LinearGradient(colors: [
                          Colors.greenAccent.shade200,
                          Colors.blueAccent.shade400,
                          Colors.purple.shade800,
                        ]),
                        strokeCap: StrokeCap.round,
                        innerFillColor: Colors.black12,
                        backgroudColor: Colors.grey.shade100,
                        neonColor: Colors.blue.shade900),
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(children: [
                        Container(
                          color: Theme.of(widget.context_app).splashColor,
                          width: MediaQuery.of(context).size.width,
                          height: 1.6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    icon: (_start)
                                        ? Icon(Icons.pause, size: 35)
                                        : Icon(Icons.play_arrow, size: 35),
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_start) {
                                        setState(() {
                                          controller.pause();
                                          _start = false;
                                        });
                                      } else {
                                        setState(() {
                                          controller.resume();
                                          _start = true;
                                        });
                                      }
                                    }),
                                SizedBox(
                                  width: 95,
                                  height: 40,
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      onPressed: () {
                                        controller.restart();
                                        setState(() {
                                          _start = true;
                                        });
                                      },
                                      child: Text(
                                        LocaleKeys.timer_main_Restart.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              if (blurWidget) ...[
                Center(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 3.5, sigmaY: 3.5, tileMode: TileMode.clamp),
                    child: Column(
                      children: [
                        OnTimer(closeTimer),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
