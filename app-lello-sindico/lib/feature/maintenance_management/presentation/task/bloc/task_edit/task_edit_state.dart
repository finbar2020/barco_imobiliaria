import 'package:equatable/equatable.dart';

import '../../../../domain/entity/task_details_entity.dart';

enum TaskEditDialogType { none, discard, scope }

enum TaskScheduleMode { daily, weekly, monthly, yearly }

enum TaskWeekDay {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday
}

enum TaskEditScope {
  /// Editar apenas a tarefa atual (THIS)
  current,
  
  /// Editar a partir desta tarefa (NEXT)
  fromThis;

  /// Valor para enviar na API
  String get apiValue {
    switch (this) {
      case TaskEditScope.current:
        return 'THIS';
      case TaskEditScope.fromThis:
        return 'NEXT';
    }
  }

  /// Título para exibir na UI
  String get displayTitle {
    switch (this) {
      case TaskEditScope.current:
        return 'Editar tarefa atual';
      case TaskEditScope.fromThis:
        return 'Editar a partir desta';
    }
  }
}

enum TaskEditOutcome { savedSingle, savedFuture, discarded, error }

class TaskEditState extends Equatable {
  final TaskDetailsEntity task;
  final TaskScheduleMode mode;
  final bool isAllDay;
  final String? checkInTime;
  final String reminder;
  final Set<TaskWeekDay> selectedWeekDays;
  final String orientation;
  final TaskEditDialogType dialog;
  final TaskEditScope? pendingScope;
  final bool isSaving;
  final TaskEditOutcome? outcome;
  final String? errorMessage;
  final String? startDate;
  final String? endDate;
  final String? editedTaskId; // ID retornado pela API após edição

  TaskEditState({
    required this.task,
    required this.mode,
    required this.isAllDay,
    required this.checkInTime,
    required this.reminder,
    required Set<TaskWeekDay> selectedWeekDays,
    required this.orientation,
    this.dialog = TaskEditDialogType.none,
    this.pendingScope,
    this.isSaving = false,
    this.outcome,
    this.errorMessage,
    this.startDate,
    this.endDate,
    this.editedTaskId,
  }) : selectedWeekDays = Set.unmodifiable(selectedWeekDays);

  TaskEditState copyWith({
    TaskDetailsEntity? task,
    TaskScheduleMode? mode,
    bool? isAllDay,
    String? checkInTime,
    String? reminder,
    Set<TaskWeekDay>? selectedWeekDays,
    String? orientation,
    TaskEditDialogType? dialog,
    TaskEditScope? pendingScope,
    bool? isSaving,
    TaskEditOutcome? outcome,
    String? errorMessage,
    String? startDate,
    String? endDate,
    String? editedTaskId,
  }) {
    return TaskEditState(
      task: task ?? this.task,
      mode: mode ?? this.mode,
      isAllDay: isAllDay ?? this.isAllDay,
      checkInTime: checkInTime ?? this.checkInTime,
      reminder: reminder ?? this.reminder,
      selectedWeekDays: selectedWeekDays != null
          ? Set<TaskWeekDay>.unmodifiable(selectedWeekDays)
          : this.selectedWeekDays,
      orientation: orientation ?? this.orientation,
      dialog: dialog ?? this.dialog,
      pendingScope: pendingScope ?? this.pendingScope,
      isSaving: isSaving ?? this.isSaving,
      outcome: outcome,
      errorMessage: errorMessage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      editedTaskId: editedTaskId ?? this.editedTaskId,
    );
  }

  /// Valida se a data inicial não é maior que a data final
  bool get isDateRangeValid {
    if (startDate == null || endDate == null) {
      return true; // Se não tem ambas as datas, considera válido
    }

    try {
      final start = _parseDate(startDate!);
      final end = _parseDate(endDate!);
      
      if (start == null || end == null) {
        return true; // Se não conseguir parsear, considera válido
      }

      // Data inicial não pode ser maior que data final
      return !start.isAfter(end);
    } catch (_) {
      return true; // Em caso de erro, considera válido
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // Tenta formato dd/MM/yyyy
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          return DateTime(year, month, day);
        }
      }
      // Tenta formato ISO
      return DateTime.tryParse(dateStr);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        task,
        mode,
        isAllDay,
        checkInTime,
        reminder,
        selectedWeekDays,
        orientation,
        dialog,
        pendingScope,
        isSaving,
        outcome,
        errorMessage,
        startDate,
        endDate,
        editedTaskId,
      ];
}
