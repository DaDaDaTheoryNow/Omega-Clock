// ignore_for_file: non_constant_identifier_names

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omega_clock/generated/locale_keys.g.dart';
import 'package:omega_clock/modules/set_sound_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class SettingsMain extends StatefulWidget {
  final context_app;
  const SettingsMain(this.context_app, {super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

// Change Theme variables
List<String> themes = ["System", "Light", "Dark"];
String? selectedItemTheme = "Dark";

// Change the sound of the timer variables
List<String> sounds = [
  "Default",
  "Iphone",
  "Tick Tock",
  "Long Tick",
  "Nirvana"
];
String? selectedItemSound = "Default";

bool isNotifications = true;

class _SettingsMainState extends State<SettingsMain> {
  @override
  void initState() {
    super.initState();
    getSelectSound();
  }

  void getSelectSound() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // get saving sound select item
      selectedItemSound = prefs.getString("SelectSound") ?? "Default";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Change Theme
        Padding(
          padding: EdgeInsets.only(right: 15, left: 15, bottom: 25),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.settings_main_Theme.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: DropdownButton<String>(
                        value: selectedItemTheme,
                        items: themes
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600),
                                )))
                            .toList(),
                        onChanged: (item) async {
                          setState(() {
                            selectedItemTheme = item;
                          });
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("SelectTheme", selectedItemTheme!);
                          if (selectedItemTheme == "System") {
                            AdaptiveTheme.of(context).setSystem();
                          } else if (selectedItemTheme == "Dark") {
                            AdaptiveTheme.of(context).setDark();
                          } else if (selectedItemTheme == "Light") {
                            AdaptiveTheme.of(context).setLight();
                          }
                        }),
                  )
                ],
              )),
        ),

        // Change the sound of the timer
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.settings_main_Change_sound_of_timer.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: DropdownButton<String>(
                        value: selectedItemSound,
                        items: sounds
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                )))
                            .toList(),
                        onChanged: (item) async {
                          selectedItemSound = item;
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString("SelectSound", selectedItemSound!);
                          setState(() {
                            SelectSound().getSound(selectedItemSound!);
                          });
                        }),
                  )
                ],
              )),
        ),

        // notifications switcher
        Padding(
          padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.settings_main_Reminder_notifications.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CupertinoSwitch(
                      value: isNotifications,
                      onChanged: (bool value) async {
                        setState(() {
                          isNotifications = value;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool("Notifications", isNotifications);
                        if (isNotifications) {
                          Workmanager().cancelByUniqueName("missAlarm");
                          Workmanager().cancelByUniqueName("controlAlarm");
                          // start again
                          Workmanager().registerPeriodicTask(
                              "missAlarm", "missAlarm",
                              initialDelay: Duration(hours: 54),
                              frequency: Duration(hours: 54));
                          Workmanager().registerPeriodicTask(
                              "controlAlarm", "controlAlarm",
                              initialDelay: Duration(hours: 24),
                              frequency: Duration(hours: 24));

                          debugPrint("Notifications on");
                        } else {
                          Workmanager().cancelByUniqueName("missAlarm");
                          Workmanager().cancelByUniqueName("controlAlarm");

                          debugPrint("Notifications off");
                        }
                      },
                    ),
                  ),
                ],
              )),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 15),
          child: Container(
            color: Theme.of(widget.context_app).splashColor,
            height: 1.6,
            width: MediaQuery.of(context).size.width,
          ),
        ),

        // language changer
        Container(
            width: MediaQuery.of(context).size.width,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.settings_main_Change_language.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: OutlinedButton(
                        onPressed: () {
                          switch (LocaleKeys.settings_main_language.tr()) {
                            case "English":
                              setState(() {
                                context.setLocale(Locale("ru"));
                              });
                              break;
                            case "Русский":
                              setState(() {
                                context.setLocale(Locale("en"));
                              });
                              break;
                            default:
                          }
                        },
                        child: Text(LocaleKeys.settings_main_language.tr()))),
              ],
            )),
      ],
    );
  }
}
