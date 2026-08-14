class RruleEntity {
  final String frequency;
  final List<String>? byDays;

  RruleEntity({
    required this.frequency,
    this.byDays,
  });
}

class CreateTaskRequestEntity {
  final String procedureGroupId;
  final String procedureId;
  final String? localId;
  /// Optional asset identifier when the task targets a specific equipment.
  final String? assetId;
  final bool allDay;
  final String dtStart;
  final String? timeStart;
  final bool repeat;
  final RruleEntity? rrule;

  CreateTaskRequestEntity({
    required this.procedureGroupId,
    required this.procedureId,
    this.localId,
    this.assetId,
    required this.allDay,
    required this.dtStart,
    this.timeStart,
    required this.repeat,
    this.rrule,
  });
}

class CreateTaskResponseEntity {
  final String idSchedule;
  final List<String> idScheduleEvents;

  CreateTaskResponseEntity({
    required this.idSchedule,
    required this.idScheduleEvents,
  });
}
