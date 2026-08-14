import 'package:essentials/app_localization.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';

Future<DateTime> datePicker(BuildContext context,
    {DateTime? selectedDate, DateTime? firstDate, DateTime? lastDate}) async {
  selectedDate = selectedDate ?? DateTime.now();
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2900),
      cancelText: getString(context, "cancel").toUpperCase(),
      confirmText: getString(context, "ok").toUpperCase(),
      helpText: getString(context, "pick_a_date").toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: CalendarTheme(context),
          child: child!,
        );
      });

  if (picked != null && picked != selectedDate) return picked;
  return selectedDate;
}

CalendarTheme(BuildContext context) {
  final theme = Theme.of(context);
  return ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
        primary: theme.primaryColor,
        onPrimary: LelloTheme.palleteOf(theme).customColor(),
        surface: LelloTheme.palleteOf(theme).background(),
        onSurface: Colors.black,
        outlineVariant: LelloTheme.palleteOf(theme).background()),
    dialogBackgroundColor: LelloTheme.palleteOf(theme).background(),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        color: LelloTheme.palleteOf(theme).customColor(),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: theme.primaryColor,
      headerForegroundColor: LelloTheme.palleteOf(theme).background(),
      dividerColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
  );
}
