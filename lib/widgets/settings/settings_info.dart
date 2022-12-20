// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:im_animations/im_animations.dart';

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
            height: 320,
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
                        "Thanks for using my app!",
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
                                      msg: "Your version up to date",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                child: Text(
                                  "Check update",
                                  style: TextStyle(
                                    color: Theme.of(context_app).focusColor,
                                  ),
                                )),
                          ),
                          Text("Current version: $version_app")
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
