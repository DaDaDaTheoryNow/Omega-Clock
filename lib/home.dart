// ignore_for_file: library_private_types_in_public_api, deprecated_member_use
import 'dart:async';

import 'package:duration/duration.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:omega_clock/generated/locale_keys.g.dart';
import 'package:omega_clock/modules/set_alarm.dart';
import 'package:omega_clock/widgets/alarm/alarm_time_picker.dart';
import 'package:omega_clock/widgets/alarm/nothing_warning_alarm.dart';
import 'package:omega_clock/widgets/timer/timer_count_down_widget.dart';
import 'package:omega_clock/widgets/timer/warning_select_timer.dart';
import 'package:omega_clock/widgets/alarm/alarm_main_widget.dart';
import 'package:omega_clock/widgets/settings/settings_info.dart';
import 'package:omega_clock/widgets/settings/settings_main.dart';
import 'package:omega_clock/screens/favorite.dart';

import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules/notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// index to select action from bottomBar
final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);

// day and time variables
TimeOfDay _timeAlarm = TimeOfDay.now();

// alarm options
List<String> alarmNameList = [];
List<String> alarmTimeList = [];
List<String> alarmFavoriteList = []; // work now

// get the name of the alarm before processing
TextEditingController _nameAlarmController = TextEditingController();

// alarm name
String? title;

// get and format timer duration
Duration _duration = Duration(minutes: 0, seconds: 1);
String? _prettyDuration;
int formatDuration = 30;

// options in bottomBar
bool alarm = true;
bool timer = false;
bool favorite = false;
bool settings = false;

// check action from bottomBar
bool _openedBar = false;

// icons in bottomBar
final List<Icon> _icons = [
  Icon(Icons.add_alarm_sharp, color: Colors.white, size: 35),
  Icon(Icons.timer_sharp, color: Colors.white, size: 35),
  Icon(Icons.star, color: Colors.white, size: 35),
  Icon(Icons.info_outline_rounded, color: Colors.white, size: 35)
];

class _HomePageState extends State<HomePage> {
  // intilizate before the page is assembled
  @override
  void initState() {
    // stream value
    _bottomBarController.stream.listen((opened) {
      debugPrint(opened.toString());
      setState(() {
        _openedBar = opened;
      });
    });
    super.initState();
    // loads saved alarms
    getAlarmListShared();
    // make list of alarms
    Noti.initialize(flutterLocalNotificationsPlugin);
    List.generate(alarmNameList.length, (index) => _creatCustomCard(index));
  }

  // loads saved alarms function
  getAlarmListShared() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alarmNameList = prefs.getStringList('alarmNameList')!;
      alarmTimeList = prefs.getStringList('alarmTimeList')!;
      alarmFavoriteList = prefs.getStringList('alarmFavoriteList')!;
    });
  }

  void onCancelAlarm() {
    setState(() {
      _bottomBarController.closeSheet();
    });
  }

  void onDurationChanged() async {
    // format duration for timer
    setState(() {
      _prettyDuration = prettySeconds(_duration, terse: true);
      formatDuration =
          int.tryParse(_prettyDuration!.replaceAll(RegExp(r'[^0-9]'), ''))!;
    });

    // exit
    _bottomBarController.closeSheet();
    _duration = Duration(seconds: 1);
  }

  void onTimeChanged(TimeOfDay newTime) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              LocaleKeys.alarm_main_Set_alarm_name.tr(),
              style: TextStyle(
                color: Theme.of(context).focusColor,
              ),
            ),
            content: TextField(
              autofocus: true,
              obscureText: false,
              controller: _nameAlarmController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: LocaleKeys.alarm_main_Enter_name_for_the_alarm.tr(),
                hintStyle: const TextStyle(
                  color: Colors.black26,
                ),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor, width: 3)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor, width: 1)),
                prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconTheme(
                      data: IconThemeData(color: Theme.of(context).focusColor),
                      child: Icon(
                        Icons.alarm,
                        size: 25,
                        shadows: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                    )),
              ),
            ),
            actions: [
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _timeAlarm = newTime;
                          });

                          setAlarm(
                            context,
                            _nameAlarmController,
                            title,
                            alarmNameList,
                            alarmTimeList,
                            alarmFavoriteList,
                            _timeAlarm,
                          );
                        },
                        child: Text(
                            LocaleKeys.alarm_main_Create_a_New_Alarm.tr())),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _timeAlarm = newTime;
                          });

                          setAlarm(
                              context,
                              _nameAlarmController,
                              title,
                              alarmNameList,
                              alarmTimeList,
                              alarmFavoriteList,
                              _timeAlarm);
                        },
                        child: Text(
                          LocaleKeys.alarm_main_Thanks_no.tr(),
                          style: TextStyle(color: Colors.grey),
                        ))
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _creatCustomCard(index) {
    return Slidable(
      key: Key(alarmNameList[index]),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        extentRatio: 1,
        children: [
          SlidableAction(
            onPressed: (context) async {
              EasyLoading.instance.indicatorType =
                  EasyLoadingIndicatorType.dualRing;
              EasyLoading.show(
                status: LocaleKeys.alarm_main_Deleting_please_wait.tr(),
                maskType: EasyLoadingMaskType.black,
              );

              Noti.showBigTextNotification(
                  title: LocaleKeys.alarm_main_Go_back_click.tr(),
                  body:
                      "${LocaleKeys.alarm_main_Sucess_delete.tr()} \'${alarmNameList[index]} ${LocaleKeys.alarm_main_alarm.tr()}\', ${LocaleKeys.alarm_main_go_back.tr()}",
                  fln: flutterLocalNotificationsPlugin);

              Fluttertoast.showToast(
                  msg: LocaleKeys
                      .alarm_main_Go_back_by_clicking_on_the_notification
                      .tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              Future.delayed(const Duration(milliseconds: 500), () async {
                setState(() {
                  FlutterAlarmClock.deleteAlarm(
                      title: alarmNameList[index], skipUi: true);
                  alarmNameList.removeAt(index);
                  alarmTimeList.removeAt(index);
                  alarmFavoriteList.removeAt(index);
                  if (alarmFavoriteNameList.isNotEmpty) {
                    alarmFavoriteNameList.removeAt(index);
                  }
                  if (alarmFavoriteTimeList.isNotEmpty) {
                    alarmFavoriteTimeList.removeAt(index);
                  }
                  EasyLoading.dismiss();
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setStringList('alarmNameList', alarmNameList);
                await prefs.setStringList('alarmTimeList', alarmTimeList);
                await prefs.setStringList(
                    'alarmFavoriteNameList', alarmFavoriteNameList);
                await prefs.setStringList(
                    'alarmFavoriteTimeList', alarmFavoriteTimeList);
                await prefs.setStringList(
                    'alarmFavoriteList', alarmFavoriteList);
              });
            },
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8), topLeft: Radius.circular(8)),
            backgroundColor: Color.fromARGB(255, 247, 58, 58),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: LocaleKeys.alarm_main_Delete.tr(),
          ),
        ],
      ),
      child: AlarmMainWidget(
        alarmNameList[index],
        alarmTimeList[index],
        alarmFavoriteList[index], // list of the favorite buttons etc work
        "false", // work with delete alarm on background if time is up
        index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      home: Scaffold(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          centerTitle: true,
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // appBar selected option
              if (alarm == true) ...[
                Text(
                  LocaleKeys.app_bar_Alarm.tr(),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ] else if (timer == true) ...[
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text:
                          "${LocaleKeys.app_bar_Timer.tr()} (0-1 ${LocaleKeys.app_bar_hour.tr()}",
                      style: TextStyle(
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle!.color,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 22,
                      )),
                  WidgetSpan(
                      child: Icon(
                    Icons.timer_sharp,
                    color: Theme.of(context).appBarTheme.titleTextStyle!.color,
                    size: 25,
                  )),
                  TextSpan(
                      text: ")",
                      style: TextStyle(
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle!.color,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 22,
                      )),
                ]))
              ] else if (favorite == true) ...[
                Text(
                  LocaleKeys.app_bar_Favorite.tr(),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ] else if (settings == true) ...[
                Text(
                  LocaleKeys.app_bar_Settings.tr(),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ]
            ],
          ),
        ),
        // page
        body: (alarm)
            ? (alarmNameList.isNotEmpty)
                ? ListView.builder(
                    itemCount: alarmNameList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: _creatCustomCard(index),
                      );
                    },
                  )
                : NothingWarning(Icons.alarm_add_sharp,
                    LocaleKeys.alarm_main_To_add_a_new_alarm.tr(), context)
            : (timer)
                ? (_openedBar)
                    ? WarningSelectTimer(context)
                    : TimerCountDown(formatDuration, context)
                : (favorite == true)
                    ? FavoritePage(context)
                    : (settings == true)
                        ? SettingsMain(context)
                        : null,
        bottomNavigationBar: BottomBarWithSheet(
          controller: _bottomBarController,
          bottomBarTheme: BottomBarTheme(
            heightOpened: alarm
                ? 550
                : timer
                    ? 550
                    : favorite
                        ? 300
                        : settings
                            ? 350
                            : 550,
            selectedItemIconColor: Theme.of(context).focusColor,
            mainButtonPosition: MainButtonPosition.middle,
            decoration: BoxDecoration(
              color: Theme.of(context).errorColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            itemIconColor: Theme.of(context).hintColor,
            itemTextStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 10.0,
            ),
            selectedItemTextStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 10.0,
            ),
          ),
          mainActionButtonTheme: MainActionButtonTheme(
              color: Theme.of(context).focusColor,
              icon: alarm
                  ? _icons[0]
                  : timer
                      ? _icons[1]
                      : favorite
                          ? _icons[2]
                          : settings
                              ? _icons[3]
                              : null),
          onSelectItem: (index) {
            switch (index) {
              case 0:
                setState(() {
                  alarm = true;
                  timer = false;
                  favorite = false;
                  settings = false;
                });
                break;
              case 1:
                setState(() {
                  alarm = false;
                  timer = true;
                  favorite = false;
                  settings = false;
                });
                break;
              case 2:
                setState(() {
                  alarm = false;
                  timer = false;
                  favorite = true;
                  settings = false;
                });
                break;
              case 3:
                setState(() {
                  alarm = false;
                  timer = false;
                  favorite = false;
                  settings = true;
                });
                break;
              default:
                return null;
            }
          },
          sheetChild: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // action in opened bottomBar
              if (alarm) ...[
                AlarmTimePicker(
                    context, _timeAlarm, onCancelAlarm, onTimeChanged)
              ] else if (timer) ...[
                Column(
                  children: [
                    DurationPicker(
                      height: 300,
                      width: 300,
                      baseUnit: BaseUnit.second,
                      duration: _duration,
                      onChange: (val) {
                        if (val == Duration(seconds: 0, milliseconds: 0))
                          setState(() => _duration = Duration(seconds: 1));
                        else if (val >= Duration(minutes: 60))
                          setState(() =>
                              _duration = Duration(minutes: 59, seconds: 59));
                        else
                          setState(() => _duration = val);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  _bottomBarController.closeSheet();
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: TextButton(
                                onPressed: onDurationChanged,
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ] else if (favorite) ...[
                Column(
                  children: [
                    Center(
                      child: Text(
                        LocaleKeys.favorite_main_Adding_a_Favorite_Alarm.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .color,
                        ),
                      ),
                    ),
                    Card(
                      child: Text(LocaleKeys
                          .favorite_main_To_add_an_alarm_to_your_favorites
                          .tr()),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        LocaleKeys.favorite_main_Deleting_a_Favorite_Alarm.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle!
                              .color,
                        ),
                      ),
                    ),
                    Card(
                      child: Text(LocaleKeys
                          .favorite_main_To_remove_an_alarm_from_favorites
                          .tr()),
                    ),
                  ],
                )
              ] else if (settings) ...[
                SettingsInfo(context)
              ]
            ],
          )),
          items: const [
            BottomBarWithSheetItem(icon: Icons.alarm),
            BottomBarWithSheetItem(icon: Icons.timer_sharp),
            BottomBarWithSheetItem(icon: Icons.star),
            BottomBarWithSheetItem(icon: Icons.settings),
          ],
        ),
      ),
    );
  }
}
