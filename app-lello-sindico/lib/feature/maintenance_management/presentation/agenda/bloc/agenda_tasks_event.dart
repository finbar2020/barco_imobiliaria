import 'package:equatable/equatable.dart';

abstract class AgendaTasksEvent extends Equatable {
  const AgendaTasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadAgendaTasksEvent extends AgendaTasksEvent {
  final DateTime selectedDate;
  final String orderBy;
  final List<String>? taskTypes;
  final List<String>? taskStatus;
  final List<String>? locals;
  final List<String>? assets;
  final List<String>? responsibles;
  final List<String>? employeeGroups;

  const LoadAgendaTasksEvent({
    required this.selectedDate,
    required this.orderBy,
    this.taskTypes,
    this.taskStatus,
    this.locals,
    this.assets,
    this.responsibles,
    this.employeeGroups,
  });

  @override
  List<Object?> get props => [
        selectedDate,
        orderBy,
        taskTypes,
        taskStatus,
        locals,
        assets,
        responsibles,
        employeeGroups,
      ];
}

class RefreshAgendaTasksEvent extends AgendaTasksEvent {
  final DateTime selectedDate;
  final String orderBy;
  final List<String>? taskTypes;
  final List<String>? taskStatus;
  final List<String>? locals;
  final List<String>? assets;
  final List<String>? responsibles;
  final List<String>? employeeGroups;

  const RefreshAgendaTasksEvent({
    required this.selectedDate,
    required this.orderBy,
    this.taskTypes,
    this.taskStatus,
    this.locals,
    this.assets,
    this.responsibles,
    this.employeeGroups,
  });

  @override
  List<Object?> get props => [
        selectedDate,
        orderBy,
        taskTypes,
        taskStatus,
        locals,
        assets,
        responsibles,
        employeeGroups,
      ];
}

class ClearAgendaTasksCacheEvent extends AgendaTasksEvent {
  const ClearAgendaTasksCacheEvent();
}
