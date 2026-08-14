import '../model/edit_schedule_event_request_model.dart';
import '../../domain/entity/edit_schedule_event_entity.dart';

class EditScheduleEventAdapter {
  static EditScheduleEventRequestModel fromEntity(
      EditScheduleEventRequestEntity entity) {
    return EditScheduleEventRequestModel(
      idSchedule: entity.idSchedule,
      idScheduleEvent: entity.idScheduleEvent,
      dtStart: entity.dtStart,
      timeStart: entity.timeStart,
      timeEnd: entity.timeEnd,
      allDay: entity.allDay,
      repeat: entity.repeat,
      until: entity.until,
      procedureGroupId: entity.procedureGroupId,
      procedureId: entity.procedureId,
      localId: entity.localId,
      assetId: entity.assetId,
      updateType: entity.updateType,
      rrule: entity.rrule != null
          ? EditScheduleEventRRuleModel(
              frequency: entity.rrule!.frequency,
              byDays: entity.rrule!.byDays,
            )
          : null,
    );
  }

  static EditScheduleEventResponseEntity toEntity(Map<String, dynamic> json) {
    return EditScheduleEventResponseEntity(
      success: json['success'] ?? true,
      message: json['message'],
      data: json['data'],
    );
  }
}
