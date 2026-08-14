import 'package:shared_features/feature/gdp/domain/entity/employee.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_event.dart';

class Timesheet {
  Employee? employee;
  DateTime? date;
  List<String>? time;
  List<String>? schedules;
  List<String>? justifications;
  String? comments;
  String? signature;
  List<String>? events;
  TimesheetEvent? eventControl;
  int? lunchHours;
  int? workedHours;
  int? extraHours50;
  int? extraHours60;
  int? extraHours75;
  int? extraHours80;
  int? extraHours100;
  int? extraHours140;
  int? extraHours200;
  int? lateHours;
  int? earlyDepartureHours;
  String? statusDay;
  DateTime? monthClosing;

  Timesheet({
    this.employee,
    this.date,
    this.time,
    this.schedules,
    this.justifications,
    this.comments,
    this.signature,
    this.events,
    this.eventControl,
    this.lunchHours,
    this.workedHours,
    this.extraHours50,
    this.extraHours60,
    this.extraHours75,
    this.extraHours80,
    this.extraHours100,
    this.extraHours140,
    this.extraHours200,
    this.lateHours,
    this.earlyDepartureHours,
    this.statusDay,
  });
}
