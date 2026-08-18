import 'dart:io';

import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';

abstract class TimesheetEvent {}

class TimesheetLoadingEvent extends TimesheetEvent {
  TimesheetLoadingEvent();
}

class TimesheetLoadedEvent extends TimesheetEvent {
  final List<TimesheetEmployee> list;
  final bool getDetailFailed;
  final bool? saveSignatureOrNotify;
  TimesheetLoadedEvent({
    required this.list,
    this.getDetailFailed = false,
    this.saveSignatureOrNotify,
  });
}

class TimesheetDetailLoadedEvent extends TimesheetEvent {
  final TimesheetEmployeeDetailEntity entity;
  final TimesheetEmployee employee;
  final File? pdf;
  final bool putFailed;
  TimesheetDetailLoadedEvent({
    required this.employee,
    required this.entity,
    this.pdf,
    this.putFailed = false,
  });
}

class TimesheetFailedEvent extends TimesheetEvent {
  TimesheetFailedEvent();
}
