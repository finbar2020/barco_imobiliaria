import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetElement {
  DateTime date;
  List<String> times;
  String journey;
  bool hasTreatment;
  bool dayOff;

  TimesheetElement({
    required this.date,
    required this.times,
    required this.journey,
    required this.hasTreatment,
    required this.dayOff,
  });

  String get dateFormatted {
    DateFormat dateFormat = DateFormat("dd/MM");
    return dateFormat.format(date);
  }

  String pointsFormatted(BuildContext context) {
    if (dayOff) {
      return getString(context, "timesheet_day_off");
    }
    String points = times.join(' - ');
    if (points.isEmpty) {
      return " - ";
    }
    return points;
  }
}
