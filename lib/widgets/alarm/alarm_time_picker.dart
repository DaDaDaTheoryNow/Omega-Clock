// ignore_for_file: must_be_immutable

import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';

class AlarmTimePicker extends StatefulWidget {
  BuildContext context;
  TimeOfDay _timeAlarm;
  Function(TimeOfDay) onChange;
  VoidCallback onCancel;

  AlarmTimePicker(this.context, this._timeAlarm, this.onCancel, this.onChange,
      {super.key});

  @override
  State<AlarmTimePicker> createState() => _AlarmTimePickerState();
}

class _AlarmTimePickerState extends State<AlarmTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Choose time for your alarm",
          style: TextStyle(
            color: Theme.of(widget.context).dialogBackgroundColor,
            fontSize: 22,
            fontWeight: FontWeight.w300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(100, 20, 100, 0),
          child: Container(
            height: 1.7,
            width: MediaQuery.of(widget.context).size.width,
            color: Theme.of(widget.context).focusColor,
            child: null,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(widget.context).size.width,
          child: createInlinePicker(
            okText: "OK",
            okStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            barrierColor: Theme.of(widget.context).splashColor,
            elevation: 1,
            value: widget._timeAlarm,
            onChange: widget.onChange,
            onCancel: widget.onCancel,
            minuteInterval: MinuteInterval.FIVE,
            iosStylePicker: true,
            is24HrFormat: true,
            wheelHeight: 150,
          ),
        ),
      ],
    );
  }
}
