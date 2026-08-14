import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

enum TimesheetTypeEnum {
  present,
  shiftNotStarted,
  dayOff,
  vacation,
  unmarked,
  attestation,
  events,
  employee
}

String timesheetTypeToString(BuildContext context, TimesheetTypeEnum type) {
  switch (type) {
    case TimesheetTypeEnum.present:
      return getString(context, "gdp_timesheet_type_present");
    case TimesheetTypeEnum.shiftNotStarted:
      return getString(context, "gdp_timesheet_type_shiftNotStarted");
    case TimesheetTypeEnum.dayOff:
      return getString(context, "gdp_timesheet_type_dayOff");
    case TimesheetTypeEnum.vacation:
      return getString(context, "gdp_timesheet_type_vacation");
    case TimesheetTypeEnum.unmarked:
      return getString(context, "gdp_timesheet_type_unmarked");
    case TimesheetTypeEnum.attestation:
      return getString(context, "gdp_timesheet_type_attestation");
    case TimesheetTypeEnum.events:
      return getString(context, "gdp_timesheet_type_events");
    case TimesheetTypeEnum.employee:
      return getString(context, "gdp_timesheet_type_employee");
    default:
      return "";
  }
}
