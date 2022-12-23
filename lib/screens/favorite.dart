import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:omega_clock/home.dart';
import 'package:omega_clock/widgets/alarm/alarm_main_widget.dart';
import 'package:omega_clock/widgets/alarm/nothing_warning_alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/notifications.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

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
    return Slidable(
      key: Key(alarmFavoriteNameList[index]),
      startActionPane: ActionPane(
        motion: DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (context) {},
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8), topRight: Radius.circular(8)),
            backgroundColor: Color.fromARGB(255, 255, 17, 0),
            foregroundColor: Colors.white,
            icon: Icons.report,
            label: 'Report',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        extentRatio: 1,
        children: [
          SlidableAction(
            onPressed: (context) async {
              EasyLoading.instance.indicatorType =
                  EasyLoadingIndicatorType.dualRing;
              EasyLoading.show(
                status: 'Deleting, please wait...',
                maskType: EasyLoadingMaskType.black,
              );

              Noti.showBigTextNotification(
                  title: "Go back (click)",
                  body:
                      "Sucess delete \'${alarmFavoriteNameList[index]} alarm\', go back",
                  fln: flutterLocalNotificationsPlugin);

              Fluttertoast.showToast(
                  msg:
                      "Sucess deleting \"${alarmFavoriteNameList[index]} OMEGA ALARM\",  go back by clicking on the new notification",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              Future.delayed(const Duration(milliseconds: 500), () async {
                setState(() {
                  FlutterAlarmClock.deleteAlarm(
                      title: alarmFavoriteNameList[index], skipUi: true);
                  alarmFavoriteNameList.removeAt(index);
                  alarmFavoriteTimeList.removeAt(index);
                  EasyLoading.dismiss();
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setStringList(
                    'alarmFavoriteNameList', alarmFavoriteNameList);
                await prefs.setStringList(
                    'alarmFavoriteTimeList', alarmFavoriteTimeList);
              });
            },
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8), topLeft: Radius.circular(8)),
            backgroundColor: Color.fromARGB(255, 247, 58, 58),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete?',
          ),
        ],
      ),
      child: AlarmMainWidget(
        alarmFavoriteNameList[index],
        alarmFavoriteTimeList[index],
        "true", // list of the favorite buttons etc work,
        "false", // work with delete alarm on background if time is up
        index,
      ),
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
          : NothingWarning(Icons.star, context),
    );
  }
}
