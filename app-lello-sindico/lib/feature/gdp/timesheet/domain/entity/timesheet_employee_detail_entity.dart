import 'dart:core';

import 'package:essentials/essentials.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_marks_entity.dart';

class TimesheetEmployeeDetailEntity {
  final DateTime startDateOfAssessment;
  final DateTime endDateOfAssessment;
  final dynamic signatureId;
  final bool employeeSigned;
  final bool syndicateSigned;
  final TimesheetActionEnum action;
  final List<TimesheetEmployeeMarksEntity> markings;
  TimesheetEmployeeDetailEntity({
    required this.startDateOfAssessment,
    required this.endDateOfAssessment,
    required this.signatureId,
    required this.employeeSigned,
    required this.syndicateSigned,
    required this.action,
    required this.markings,
  });

  String get signatureStatus => employeeSigned ? "ASSINADO" : 'PENDENTE';

  bool get notifyButton => action == TimesheetActionEnum.notify;

  bool get dontShowButton => action == TimesheetActionEnum.none;

  String get initDate => convertDateFromDDMMYYYY(startDateOfAssessment);

  String get endDate => convertDateFromDDMMYYYY(endDateOfAssessment);

  String convertDateFromDDMMYYYY(DateTime date) {
    DateFormat formatted = DateFormat.yMd();
    return formatted.format(date);
  }
}
