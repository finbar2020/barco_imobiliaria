import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';

abstract class TimesheetState extends Equatable {
  const TimesheetState();

  @override
  List<Object?> get props => [];
}

class TimesheetLoadingState extends TimesheetState {
  const TimesheetLoadingState();
}

class TimesheetLoadedState extends TimesheetState {
  final List<TimesheetEmployee> list;
  final bool getDetailFailed;
  final bool? saveSignatureOrNotify;

  const TimesheetLoadedState({
    required this.list,
    this.getDetailFailed = false,
    this.saveSignatureOrNotify,
  });

  @override
  List<Object?> get props => [list, getDetailFailed, saveSignatureOrNotify];
}

class TimesheetDetailLoadedState extends TimesheetState {
  final TimesheetEmployeeDetailEntity entity;
  final TimesheetEmployee employee;
  final File? pdf;
  final bool putFailed;

  const TimesheetDetailLoadedState({
    required this.employee,
    required this.entity,
    this.pdf,
    this.putFailed = false,
  });

  @override
  List<Object?> get props => [entity, employee, pdf, putFailed];
}

class TimesheetFailedState extends TimesheetState {
  const TimesheetFailedState();
}
