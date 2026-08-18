abstract class AgendaTasksEvent {}

class LoadAgendaTasksEvent extends AgendaTasksEvent {
  final DateTime selectedDate;
  final String orderBy;
  final List<String>? taskTypes;
  final List<String>? taskStatus;
  final List<String>? locals;
  final List<String>? assets;
  final List<String>? responsibles;
  final List<String>? employeeGroups;

  LoadAgendaTasksEvent({
    required this.selectedDate,
    required this.orderBy,
    this.taskTypes,
    this.taskStatus,
    this.locals,
    this.assets,
    this.responsibles,
    this.employeeGroups,
  });
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

  RefreshAgendaTasksEvent({
    required this.selectedDate,
    required this.orderBy,
    this.taskTypes,
    this.taskStatus,
    this.locals,
    this.assets,
    this.responsibles,
    this.employeeGroups,
  });
}

class ClearAgendaTasksCacheEvent extends AgendaTasksEvent {}
