import '../../domain/entity/schedule_events_response_entity.dart';
import '../../domain/entity/schedule_event_task_entity.dart';
import '../../domain/entity/efficiency_entity.dart';
import '../../adapters/schedule_event_task_model_adapter.dart';
import '../model/schedule_events_response_model.dart';
import '../model/schedule_events_detail_response_model.dart';
import '../model/task_summary_model.dart';

extension TaskSummaryModelAdapter on TaskSummaryModel {
  TaskSummaryEntity get toEntity {
    return TaskSummaryEntity(
      total: total,
      done: done,
      notStarted: notStarted,
      draft: draft,
    );
  }
}

/// Adapter para converter TaskSummaryDayModel em TaskSummaryEntity
extension TaskSummaryDayModelAdapter on TaskSummaryDayModel {
  TaskSummaryEntity get toEntity {
    return TaskSummaryEntity(
      total: total,
      done: done,
      notStarted: notStarted,
      draft: draft,
    );
  }
}

/// Adapter para converter ScheduleEventsResponseModel em ScheduleEventsResponseEntity
extension ScheduleEventsResponseModelAdapter on ScheduleEventsResponseModel {
  ScheduleEventsResponseEntity get toEntity {
    return ScheduleEventsResponseEntity(
      success: success,
      message: message,
      taskSummaryDay: taskSummaryDay?.toEntity,
      taskFormulary: taskFormulary.map((task) => task.toEntity).toList(),
      errorCode: errorCode,
      legacyStatusCode: legacyStatusCode,
    );
  }
}

/// Adapter para converter ScheduleEventsDetailResponseModel em ScheduleEventsResponseEntity
extension ScheduleEventsDetailResponseModelAdapter
    on ScheduleEventsDetailResponseModel {
  ScheduleEventsResponseEntity get toEntity {
    return ScheduleEventsResponseEntity(
      success: success,
      message: message,
      taskSummaryDay: data.taskSummaryDay.toEntity,
      taskFormulary: data.taskFormulary.map((task) => task.toEntity).toList(),
      errorCode: errorCode,
      legacyStatusCode: legacyStatusCode,
    );
  }
}

extension ScheduleEventTaskFormularyModelAdapter
    on ScheduleEventTaskFormularyModel {
  ScheduleEventTaskEntity get toEntity {
    return ScheduleEventTaskEntity(
      idTask: idTask,
      idSchedule: idSchedule ?? '',
      idScheduleEvent: idScheduleEvent ?? '',
      typeTask: typeTask ?? 'ROTINA',
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
