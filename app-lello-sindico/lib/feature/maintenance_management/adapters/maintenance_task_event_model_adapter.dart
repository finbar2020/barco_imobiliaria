import '../data/model/maintenance_task_event_model.dart';
import '../data/model/maintenance_task_events_response_model.dart';
import '../data/model/task_summary_model.dart';
import '../domain/entity/efficiency_entity.dart';
import '../domain/entity/maintenance_task_event_entity.dart';
import '../domain/entity/maintenance_task_events_response_entity.dart';

extension MaintenanceTaskEventModelExtension on MaintenanceTaskEventModel {
  MaintenanceTaskEventEntity get toEntity {
    return MaintenanceTaskEventEntity(
      idTask: idTask,
      idSchedule: idSchedule,
      idScheduleEvent: idScheduleEvent,
      typeTask: typeTask,
      name: name,
      fullDescription: fullDescription,
      responsibleUserable: responsibleUserable,
      procedureGroupId: procedureGroupId,
      responsibleId: responsibleId,
      timeStart: timeStart,
      timeEnd: '', // Removed as per requirements
      timeDescription: timeDescription,
      dtstart: dtstart,
      dtend: '', // Removed as per requirements
      dtstartFormatted: dtstartFormatted,
      dtendFormatted: '', // Removed as per requirements
      status: status,
      allDay: allDay,
      rrule: rrule,
      rruleDescription: rruleDescription,
    );
  }
}

extension TaskSummaryModelExtension on TaskSummaryModel {
  TaskSummaryEntity get toEntity {
    return TaskSummaryEntity(
      total: total,
      done: done,
      notStarted: notStarted,
      draft: draft,
    );
  }
}

extension MaintenanceTaskEventsResponseModelExtension
    on MaintenanceTaskEventsResponseModel {
  MaintenanceTaskEventsResponseEntity get toEntity {
    return MaintenanceTaskEventsResponseEntity(
      taskSummaryDay: taskSummaryDay.toEntity,
      taskFormulary: taskFormulary.map((e) => e.toEntity).toList(),
    );
  }
}
