// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_animations/im_animations.dart';
import 'package:omega_clock/generated/locale_keys.g.dart';

class SettingsInfo extends StatelessWidget {
  final context_app;
  SettingsInfo(this.context_app, {super.key});

  @override
  Widget build(BuildContext context) {
    double version_app = 1.1;
    return SafeArea(
        maintainBottomViewPadding: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: SizedBox(
            height: 225,
            width: MediaQuery.of(context).size.width,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: HeartBeat(
                      child: Text(
                        LocaleKeys.settings_main_Thanks_for_using_my_app.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Theme.of(context_app).focusColor,
                    ),
                  ),
                  Fade(
                      duration: Duration(milliseconds: 1500),
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: OutlinedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 0, 0, 0)),
                                ),
                                onPressed: () {
                                  Fluttertoast.showToast(
                                      msg: LocaleKeys
                                          .settings_main_Your_version_up_to_date
                                          .tr(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                child: Text(
                                  LocaleKeys.settings_main_Check_update.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context_app).focusColor,
                                  ),
                                )),
                          ),
                          Text(LocaleKeys.settings_main_Current_version.tr() +
                              ": " +
                              "$version_app")
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
