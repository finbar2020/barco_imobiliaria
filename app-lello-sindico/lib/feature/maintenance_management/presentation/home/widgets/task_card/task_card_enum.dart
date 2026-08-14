import 'package:essentials/app_localization.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';

enum TaskType { routine, serviceOrder }

extension TaskTypeExtension on TaskType {
  String name(BuildContext context) {
    switch (this) {
      case TaskType.routine:
        return getString(context, "task_type_routine");
      case TaskType.serviceOrder:
        return getString(context, "task_type_service_order");
    }
  }

  Color color(ThemeData theme) {
    final pallete = LelloTheme.palleteOf(theme);
    switch (this) {
      case TaskType.routine:
        return pallete.routineBlue();
      case TaskType.serviceOrder:
        return Color(0xFFE5073E);
    }
  }
}
