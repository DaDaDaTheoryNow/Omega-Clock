// deprecated_member_use

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NothingWarning extends StatefulWidget {
  final IconData icon;
  final String alarmText;
  final BuildContext context;
  NothingWarning(this.icon, this.alarmText, this.context, {super.key});

  @override
  State<NothingWarning> createState() => _NothingWarningState();
}

class _NothingWarningState extends State<NothingWarning> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() {
        _visibleNothing = true;
      });
    });
  }

  bool _visibleNothing = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: _visibleNothing ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Click on the",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color:
                              Theme.of(widget.context).accentColor),
                    ),
                    WidgetSpan(
                        child: Container(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child:  FloatingActionButton(onPressed: (){
                        Fluttertoast.showToast(
        msg: "↓   ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
                      }, backgroundColor: Theme.of(widget.context).focusColor, child: Icon(
                        widget.icon,
                        color: Theme.of(widget.context).accentColor,
                        size: 40,
                      )),
                    )),
                    TextSpan(
                      text: "button",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color:
                              Theme.of(widget.context).accentColor),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              widget.alarmText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Theme.of(widget.context).accentColor),
            )
          ],
        ),
      ),
    );
  }
}
