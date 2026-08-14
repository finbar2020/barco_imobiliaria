import '../domain/entity/schedule_event_task_entity.dart';
import '../data/model/schedule_event_task_model.dart';

extension ScheduleEventTaskModelAdapter on ScheduleEventTaskModel {
  ScheduleEventTaskEntity get toEntity {
    return ScheduleEventTaskEntity(
      idTask: idTask,
      idSchedule: idSchedule ?? '',
      idScheduleEvent: idScheduleEvent ?? '',
      typeTask: typeTask ?? '',
      name: name ?? '',
      fullDescription: fullDescription ?? '',
      responsibleUserable: responsibleUserable ?? '',
      procedureGroupId: procedureGroupId ?? '',
      responsibleId: responsibleId ?? '',
      timeStart: timeStart ?? '',
      timeDescription: timeDescription ?? '',
      dtStart: dtstart ?? '',
      dtStartFormatted: dtstartFormatted ?? '',
      status: status ?? 'NOT_STARTED',
      rrule: rrule,
      rruleDescription: rruleDescription,
      allDay: allDay ?? false,
    );
  }
}
