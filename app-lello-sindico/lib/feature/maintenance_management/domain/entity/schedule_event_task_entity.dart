class ScheduleEventTaskEntity {
  final String? idTask;
  final String idSchedule;
  final String idScheduleEvent;
  final String typeTask;
  final String name;
  final String fullDescription;
  final String responsibleUserable;
  final String procedureGroupId;
  final String responsibleId;
  final String timeStart;
  final String timeDescription;
  final String dtStart;
  final String dtStartFormatted;
  final String status;
  final String? rrule;
  final String? rruleDescription;
  final bool allDay;

  const ScheduleEventTaskEntity({
    this.idTask,
    required this.idSchedule,
    required this.idScheduleEvent,
    required this.typeTask,
    required this.name,
    required this.fullDescription,
    required this.responsibleUserable,
    required this.procedureGroupId,
    required this.responsibleId,
    required this.timeStart,
    required this.timeDescription,
    required this.dtStart,
    required this.dtStartFormatted,
    required this.status,
    this.rrule,
    this.rruleDescription,
    required this.allDay,
  });

  factory ScheduleEventTaskEntity.fromJson(Map<String, dynamic> json) {
    return ScheduleEventTaskEntity(
      idTask: json['idTask'] as String?,
      idSchedule: json['idSchedule'] as String,
      idScheduleEvent: json['idScheduleEvent'] as String,
      typeTask: json['typeTask'] as String,
      name: json['name'] as String,
      fullDescription: json['fullDescription'] as String,
      responsibleUserable: json['responsibleUserable'] as String,
      procedureGroupId: json['procedureGroupId'] as String,
      responsibleId: json['responsibleId'] as String,
      timeStart: json['timeStart'] as String,
      timeDescription: json['timeDescription'] as String,
      dtStart: json['dtstart'] as String,
      dtStartFormatted: json['dtstartFormatted'] as String,
      status: json['status'] as String,
      rrule: json['rrule'] as String?,
      rruleDescription: json['rruleDescription'] as String?,
      allDay: json['allDay'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTask': idTask,
      'idSchedule': idSchedule,
      'idScheduleEvent': idScheduleEvent,
      'typeTask': typeTask,
      'name': name,
      'fullDescription': fullDescription,
      'responsibleUserable': responsibleUserable,
      'procedureGroupId': procedureGroupId,
      'responsibleId': responsibleId,
      'timeStart': timeStart,
      'timeDescription': timeDescription,
      'dtstart': dtStart,
      'dtstartFormatted': dtStartFormatted,
      'status': status,
      'rrule': rrule,
      'rruleDescription': rruleDescription,
      'allDay': allDay,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleEventTaskEntity &&
          runtimeType == other.runtimeType &&
          idTask == other.idTask &&
          idSchedule == other.idSchedule &&
          idScheduleEvent == other.idScheduleEvent &&
          typeTask == other.typeTask &&
          name == other.name &&
          fullDescription == other.fullDescription &&
          responsibleUserable == other.responsibleUserable &&
          procedureGroupId == other.procedureGroupId &&
          responsibleId == other.responsibleId &&
          timeStart == other.timeStart &&
          timeDescription == other.timeDescription &&
          dtStart == other.dtStart &&
          dtStartFormatted == other.dtStartFormatted &&
          status == other.status &&
          rrule == other.rrule &&
          rruleDescription == other.rruleDescription &&
          allDay == other.allDay;

  @override
  int get hashCode =>
      idTask.hashCode ^
      idSchedule.hashCode ^
      idScheduleEvent.hashCode ^
      typeTask.hashCode ^
      name.hashCode ^
      fullDescription.hashCode ^
      responsibleUserable.hashCode ^
      procedureGroupId.hashCode ^
      responsibleId.hashCode ^
      timeStart.hashCode ^
      timeDescription.hashCode ^
      dtStart.hashCode ^
      dtStartFormatted.hashCode ^
      status.hashCode ^
      rrule.hashCode ^
      rruleDescription.hashCode ^
      allDay.hashCode;

  @override
  String toString() {
    return 'ScheduleEventTaskEntity(idTask: $idTask, idSchedule: $idSchedule, idScheduleEvent: $idScheduleEvent, name: $name)';
  }
}
