import 'package:equatable/equatable.dart';

import '../../../domain/entity/assets_lookup_entity.dart';
import '../../../domain/entity/create_task_entity.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../../domain/entity/locals_lookup_entity.dart';
import '../../../domain/entity/procedure_options_entity.dart';

abstract class CreateRoutineState extends Equatable {
  const CreateRoutineState();

  @override
  List<Object?> get props => [];
}

class CreateRoutineInitialState extends CreateRoutineState {
  const CreateRoutineInitialState();
}

class CreateRoutineLoadingState extends CreateRoutineState {
  const CreateRoutineLoadingState();
}

class CreateRoutineLoadedState extends CreateRoutineState {
  final ProcedureOptionsEntity procedureOptions;
  final ProcedureOptionEntity? selectedOption;
  final FilterOptionsEntity? filterOptions;
  final LocalsLookupEntity? localsLookup;
  final AssetsLookupEntity? assetsLookup;

  const CreateRoutineLoadedState({
    required this.procedureOptions,
    this.selectedOption,
    this.filterOptions,
    this.localsLookup,
    this.assetsLookup,
  });

  /// Sentinel para permitir passar `null` explicitamente no copyWith.
  ///
  /// Uso: `copyWith(selectedOption: null)` reseta o valor,
  /// enquanto omitir o parâmetro mantém o valor atual.
  static const Object _unset = Object();

  CreateRoutineLoadedState copyWith({
    ProcedureOptionsEntity? procedureOptions,
    Object? selectedOption = _unset,
    Object? filterOptions = _unset,
    Object? localsLookup = _unset,
    Object? assetsLookup = _unset,
  }) {
    return CreateRoutineLoadedState(
      procedureOptions: procedureOptions ?? this.procedureOptions,
      selectedOption: identical(selectedOption, _unset)
          ? this.selectedOption
          : selectedOption as ProcedureOptionEntity?,
      filterOptions: identical(filterOptions, _unset)
          ? this.filterOptions
          : filterOptions as FilterOptionsEntity?,
      localsLookup: identical(localsLookup, _unset)
          ? this.localsLookup
          : localsLookup as LocalsLookupEntity?,
      assetsLookup: identical(assetsLookup, _unset)
          ? this.assetsLookup
          : assetsLookup as AssetsLookupEntity?,
    );
  }

  @override
  List<Object?> get props => [
        procedureOptions,
        selectedOption,
        filterOptions,
        localsLookup,
        assetsLookup,
      ];
}

class CreateRoutineErrorState extends CreateRoutineState {
  final String message;

  const CreateRoutineErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateRoutineCreatingTaskState extends CreateRoutineState {
  const CreateRoutineCreatingTaskState();
}

class CreateRoutineTaskCreatedState extends CreateRoutineState {
  final CreateTaskResponseEntity response;

  const CreateRoutineTaskCreatedState(this.response);

  @override
  List<Object?> get props => [response];
}

class CreateRoutineTaskCreationErrorState extends CreateRoutineState {
  final String message;

  const CreateRoutineTaskCreationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateRoutineCreatingTaskFromScheduleState extends CreateRoutineState {
  const CreateRoutineCreatingTaskFromScheduleState();
}

class CreateRoutineTaskFromScheduleCreatedState extends CreateRoutineState {
  final String taskId;
  final String eventId;
  final String taskName;
  final String? currentResponsibleName;

  const CreateRoutineTaskFromScheduleCreatedState({
    required this.taskId,
    required this.eventId,
    required this.taskName,
    this.currentResponsibleName,
  });

  @override
  List<Object?> get props =>
      [taskId, eventId, taskName, currentResponsibleName];
}

class CreateRoutineTaskFromScheduleErrorState extends CreateRoutineState {
  final String message;

  const CreateRoutineTaskFromScheduleErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
