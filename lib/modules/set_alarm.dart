import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';

setAlarm(BuildContext context, _nameAlarmController, title, alarmNameList,
    alarmTimeList, alarmFavoriteList, _timeAlarm) async {
  // add alarm
  if (_nameAlarmController.text.isNotEmpty) {
    // add alarm title
    title = _nameAlarmController.text;
    alarmNameList.add("${title!}");
  } else {
    // add alarm title if title is null
    title = Random().nextInt(1000).toString();
    alarmNameList.add("${title.toString()}");
  }

  // add alarm time
  alarmTimeList.add(_timeAlarm.format(context));

  // create alarm in system app
  FlutterAlarmClock.createAlarm(_timeAlarm.hour, _timeAlarm.minute,
      title: title!);

  final prefs = await SharedPreferences.getInstance();
  // name
  await prefs.setStringList('alarmNameList', alarmNameList);
  // time
  await prefs.setStringList('alarmTimeList', alarmTimeList);
  // favorite
  alarmFavoriteList.add("false");
  await prefs.setStringList('alarmFavoriteList', alarmFavoriteList);

  // exit
  _nameAlarmController.clear();
  Navigator.of(context).pop();
}
