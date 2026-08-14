class EditScheduleEventRequestEntity {
  final String idSchedule;
  final String idScheduleEvent;
  final String dtStart;
  final String? timeStart;
  final String? timeEnd;
  final bool allDay;
  final bool repeat;
  final String? until;
  final String? procedureGroupId;
  final String? procedureId;
  final String? localId;
  final String? assetId;
  final String updateType;
  final EditScheduleEventRRuleEntity? rrule;

  EditScheduleEventRequestEntity({
    required this.idSchedule,
    required this.idScheduleEvent,
    required this.dtStart,
    this.timeStart,
    this.timeEnd,
    required this.allDay,
    required this.repeat,
    this.until,
    this.procedureGroupId,
    this.procedureId,
    this.localId,
    this.assetId,
    required this.updateType,
    this.rrule,
  });
}

class EditScheduleEventRRuleEntity {
  final String frequency;
  final List<String>? byDays;

  EditScheduleEventRRuleEntity({
    required this.frequency,
    this.byDays,
  });
}

class EditScheduleEventResponseEntity {
  final bool success;
  final String? message;
  final String? data;

  EditScheduleEventResponseEntity({
    required this.success,
    this.message,
    this.data,
  });
}
