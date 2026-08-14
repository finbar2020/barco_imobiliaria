import 'package:equatable/equatable.dart';

import '../../../domain/entity/create_task_entity.dart';
import '../../../domain/entity/procedure_options_entity.dart';

abstract class CreateRoutineEvent extends Equatable {
  const CreateRoutineEvent();

  @override
  List<Object?> get props => [];
}

class LoadProcedureOptionsEvent extends CreateRoutineEvent {
  final String typeTask;

  const LoadProcedureOptionsEvent(this.typeTask);

  @override
  List<Object?> get props => [typeTask];
}

class SelectProcedureOptionEvent extends CreateRoutineEvent {
  final ProcedureOptionEntity selectedOption;

  const SelectProcedureOptionEvent(this.selectedOption);

  @override
  List<Object?> get props => [selectedOption];
}

class ClearSelectionEvent extends CreateRoutineEvent {
  const ClearSelectionEvent();
}

class ResetBlocEvent extends CreateRoutineEvent {
  const ResetBlocEvent();
}

class LoadFilterOptionsEvent extends CreateRoutineEvent {
  const LoadFilterOptionsEvent();
}

class LoadLocalsLookupEvent extends CreateRoutineEvent {
  final String procedureIds;

  const LoadLocalsLookupEvent(this.procedureIds);

  @override
  List<Object?> get props => [procedureIds];
}

class LoadAssetsLookupEvent extends CreateRoutineEvent {
  final String procedureIds;

  const LoadAssetsLookupEvent(this.procedureIds);

  @override
  List<Object?> get props => [procedureIds];
}

class CreateTaskEvent extends CreateRoutineEvent {
  final CreateTaskRequestEntity request;

  const CreateTaskEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class CreateTaskFromScheduleEvent extends CreateRoutineEvent {
  final String scheduleId;
  final String scheduleEventId;

  const CreateTaskFromScheduleEvent({
    required this.scheduleId,
    required this.scheduleEventId,
  });

  @override
  List<Object?> get props => [scheduleId, scheduleEventId];
}
