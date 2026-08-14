class MaintenanceTaskEventEntity {
  final String? idTask;
  final String? idSchedule;
  final String? idScheduleEvent;
  final String typeTask;
  final String name;
  final String fullDescription;
  final String responsibleUserable;
  final String? procedureGroupId;
  final String? responsibleId;
  final String timeStart;
  final String timeEnd;
  final String timeDescription;
  final String dtstart;
  final String dtend;
  final String dtstartFormatted;
  final String dtendFormatted;
  final String status;
  final bool allDay;
  final String? rrule;
  final String? rruleDescription;

  MaintenanceTaskEventEntity({
    this.idTask,
    this.idSchedule,
    this.idScheduleEvent,
    required this.typeTask,
    required this.name,
    required this.fullDescription,
    required this.responsibleUserable,
    this.procedureGroupId,
    this.responsibleId,
    required this.timeStart,
    required this.timeEnd,
    required this.timeDescription,
    required this.dtstart,
    required this.dtend,
    required this.dtstartFormatted,
    required this.dtendFormatted,
    required this.status,
    required this.allDay,
    this.rrule,
    this.rruleDescription,
  });

  // Para compatibilidade com o código existente que usa title/dtStart/untilDate
  String get title => name;
  DateTime get dtStart => DateTime.parse(dtstart);
  DateTime get untilDate => DateTime.parse(dtend);
}
