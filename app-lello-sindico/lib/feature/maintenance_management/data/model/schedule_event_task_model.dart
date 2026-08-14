class ScheduleEventTaskModel {
  final String? idTask;
  final String? idSchedule;
  final String? idScheduleEvent;
  final String? typeTask;
  final String? name;
  final String? fullDescription;
  final String? responsibleUserable;
  final String? procedureGroupId;
  final String? responsibleId;
  final String? timeStart;
  final String? timeEnd;
  final String? timeDescription;
  final String? dtstart;
  final String? dtend;
  final String? dtstartFormatted;
  final String? dtendFormatted;
  final String? status;
  final String? rrule;
  final String? rruleDescription;
  final bool? allDay;

  const ScheduleEventTaskModel({
    this.idTask,
    this.idSchedule,
    this.idScheduleEvent,
    this.typeTask,
    this.name,
    this.fullDescription,
    this.responsibleUserable,
    this.procedureGroupId,
    this.responsibleId,
    this.timeStart,
    this.timeEnd,
    this.timeDescription,
    this.dtstart,
    this.dtend,
    this.dtstartFormatted,
    this.dtendFormatted,
    this.status,
    this.rrule,
    this.rruleDescription,
    this.allDay,
  });

  factory ScheduleEventTaskModel.fromJson(Map<String, dynamic> json) {
    return ScheduleEventTaskModel(
      idTask: json['idTask'] as String?,
      idSchedule: json['idSchedule'] as String?,
      idScheduleEvent: json['idScheduleEvent'] as String?,
      typeTask: json['typeTask'] as String?,
      name: json['name'] as String?,
      fullDescription: json['fullDescription'] as String?,
      responsibleUserable: json['responsibleUserable'] as String?,
      procedureGroupId: json['procedureGroupId'] as String?,
      responsibleId: json['responsibleId'] as String?,
      timeStart: json['timeStart'] as String?,
      timeEnd: json['timeEnd'] as String?,
      timeDescription: json['timeDescription'] as String?,
      dtstart: json['dtstart'] as String?,
      dtend: json['dtend'] as String?,
      dtstartFormatted: json['dtstartFormatted'] as String?,
      dtendFormatted: json['dtendFormatted'] as String?,
      status: json['status'] as String?,
      rrule: json['rrule'] as String?,
      rruleDescription: json['rruleDescription'] as String?,
      allDay: json['allDay'] as bool?,
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
      'timeEnd': timeEnd,
      'timeDescription': timeDescription,
      'dtstart': dtstart,
      'dtend': dtend,
      'dtstartFormatted': dtstartFormatted,
      'dtendFormatted': dtendFormatted,
      'status': status,
      'rrule': rrule,
      'rruleDescription': rruleDescription,
      'allDay': allDay,
    };
  }
}
