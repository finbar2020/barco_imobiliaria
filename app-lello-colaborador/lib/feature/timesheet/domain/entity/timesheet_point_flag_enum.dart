import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

enum TimesheetPointFlagEnum { none, inserted, preInsert, notInserted }

class TimesheetPointFlag {
  static Color color(BuildContext context, TimesheetPointFlagEnum flag) {
    ThemeData theme = Theme.of(context);
    switch (flag) {
      case (TimesheetPointFlagEnum.none):
        return LelloTheme.palleteOf(theme).hubText();
      case (TimesheetPointFlagEnum.inserted):
        return LelloTheme.palleteOf(theme).success();
      case (TimesheetPointFlagEnum.preInsert):
        return LelloTheme.palleteOf(theme).warning();
      case (TimesheetPointFlagEnum.notInserted):
        return LelloTheme.palleteOf(theme).error();
    }
  }

  static String symbol(TimesheetPointFlagEnum flag) {
    switch (flag) {
      case (TimesheetPointFlagEnum.inserted):
        return "I";
      case (TimesheetPointFlagEnum.preInsert):
        return "P";
      case (TimesheetPointFlagEnum.notInserted):
        return "D";
      default:
        return "";
    }
  }

  static String titleKey(TimesheetPointFlagEnum flag) {
    switch (flag) {
      case (TimesheetPointFlagEnum.inserted):
        return "timesheet_info_page_type_included";
      case (TimesheetPointFlagEnum.preInsert):
        return "timesheet_info_page_type_pre_signed";
      case (TimesheetPointFlagEnum.notInserted):
        return "timesheet_info_page_type_not_considered";
      case (TimesheetPointFlagEnum.none):
        return "timesheet_info_page_type_none";
      default:
        return "";
    }
  }

  static String descriptionKey(TimesheetPointFlagEnum flag) {
    switch (flag) {
      case (TimesheetPointFlagEnum.inserted):
        return "timesheet_info_page_type_included_description";
      case (TimesheetPointFlagEnum.preInsert):
        return "timesheet_info_page_type_pre_signed_description";
      case (TimesheetPointFlagEnum.notInserted):
        return "timesheet_info_page_type_not_considered_description";
      default:
        return "";
    }
  }
}
