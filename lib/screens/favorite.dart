// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:omega_clock/generated/locale_keys.g.dart';
import 'package:omega_clock/home.dart';
import 'package:omega_clock/widgets/alarm/alarm_favorite_widget.dart';
import 'package:omega_clock/widgets/alarm/nothing_warning_alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/notifications.dart';

class FavoritePage extends StatefulWidget {
  final context_app;
  FavoritePage(this.context_app, {super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

List<String> alarmFavoriteNameList = [];
List<String> alarmFavoriteTimeList = [];

class _FavoritePageState extends State<FavoritePage> {
  // intilizate before the page is assembled
  @override
  void initState() {
    super.initState();
    // loads saved alarms
    getFavoriteAlarmListShared();
    // make list of alarms
    Noti.initialize(flutterLocalNotificationsPlugin);
    List.generate(alarmFavoriteNameList.length,
        (index) => _creatFavoriteCustomCard(index));
  }

  // loads saved alarms function
  getFavoriteAlarmListShared() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alarmFavoriteNameList = prefs.getStringList('alarmFavoriteNameList')!;
      alarmFavoriteTimeList = prefs.getStringList('alarmFavoriteTimeList')!;
    });
  }

  Widget _creatFavoriteCustomCard(index) {
    return AlarmFavoriteWidget(
      alarmFavoriteNameList[index],
      alarmFavoriteTimeList[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (alarmFavoriteNameList.isNotEmpty)
          ? ListView.builder(
              itemCount: alarmFavoriteNameList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: _creatFavoriteCustomCard(index),
                );
              },
            )
          : NothingWarning(
              Icons.star,
              LocaleKeys.favorite_main_To_see_information_about_favorites.tr(),
              widget.context_app),
    );
  }
}
