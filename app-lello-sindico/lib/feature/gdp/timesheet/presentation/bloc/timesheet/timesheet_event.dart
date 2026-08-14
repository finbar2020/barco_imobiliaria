import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';

abstract class TimesheetEvent extends Equatable {
  const TimesheetEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetLoadingEvent extends TimesheetEvent {
  const TimesheetLoadingEvent();
}

class TimesheetLoadedEvent extends TimesheetEvent {
  final List<TimesheetEmployee> list;
  final bool getDetailFailed;
  final bool? saveSignatureOrNotify;

  const TimesheetLoadedEvent({
    required this.list,
    this.getDetailFailed = false,
    this.saveSignatureOrNotify,
  });

  @override
  List<Object?> get props => [list, getDetailFailed, saveSignatureOrNotify];
}

class TimesheetDetailLoadedEvent extends TimesheetEvent {
  final TimesheetEmployeeDetailEntity entity;
  final TimesheetEmployee employee;
  final File? pdf;
  final bool putFailed;

  const TimesheetDetailLoadedEvent({
    required this.employee,
    required this.entity,
    this.pdf,
    this.putFailed = false,
  });

  @override
  List<Object?> get props => [entity, employee, pdf, putFailed];
}

class TimesheetFailedEvent extends TimesheetEvent {
  const TimesheetFailedEvent();
}
