import 'package:essentials/app_localization.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';

enum TaskCreationType { routine, serviceOrder }

extension TaskCreationTypeExtension on TaskCreationType {
  String get apiValue {
    switch (this) {
      case TaskCreationType.routine:
        return 'ROTINA';
      case TaskCreationType.serviceOrder:
        return 'ORDEM_SERVICO';
    }
  }

  String title(BuildContext context) {
    switch (this) {
      case TaskCreationType.routine:
        return "Criar uma rotina...";
      case TaskCreationType.serviceOrder:
        return "Criar uma ordem de serviço...";
    }
  }

  Color primaryColor(ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);
    switch (this) {
      case TaskCreationType.routine:
        return palette.raffle(); // Azul
      case TaskCreationType.serviceOrder:
        return palette.primary(); // Vermelho
    }
  }

  String name(BuildContext context) {
    switch (this) {
      case TaskCreationType.routine:
        return getString(context, "task_type_routine");
      case TaskCreationType.serviceOrder:
        return getString(context, "task_type_service_order");
    }
  }
}
