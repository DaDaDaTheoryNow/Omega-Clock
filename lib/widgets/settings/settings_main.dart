// ignore_for_file: non_constant_identifier_names

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:omega_clock/modules/set_sound_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsMain extends StatefulWidget {
  final context_app;
  const SettingsMain(this.context_app, {super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

// Change Theme variables
List<String> themes = ["System", "Dark", "Light"];
String? selectedItemTheme = "System";

// Change the sound of the timer variables
List<String> sounds = [
  "Default",
  "Iphone",
  "Tick Tock",
  "Long Tick",
  "Nirvana"
];
String? selectedItemSound = "Default";

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
                    "Change theme",
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
                          selectedItemTheme = item;
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
                    "Change sound of timer",
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
                                      fontSize: 23,
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
      ],
    );
  }
}
