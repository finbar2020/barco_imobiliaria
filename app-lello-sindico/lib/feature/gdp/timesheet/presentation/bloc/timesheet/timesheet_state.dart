import 'dart:io';

import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';

abstract class TimesheetState {
  TimesheetState();
}

class TimesheetLoadingState extends TimesheetState {
  TimesheetLoadingState();
}

class TimesheetLoadedState extends TimesheetState {
  final List<TimesheetEmployee> list;
  final bool getDetailFailed;
  final bool? saveSignatureOrNotify;
  TimesheetLoadedState({
    required this.list,
    this.getDetailFailed = false,
    this.saveSignatureOrNotify,
  });
}

class TimesheetDetailLoadedState extends TimesheetState {
  final TimesheetEmployeeDetailEntity entity;
  final TimesheetEmployee employee;
  File? pdf;
  final bool putFailed;
  TimesheetDetailLoadedState({
    required this.employee,
    required this.entity,
    this.pdf,
    this.putFailed = false,
  });
}

class TimesheetFailedState extends TimesheetState {
  TimesheetFailedState() : super();
}
