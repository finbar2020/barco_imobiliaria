import '../model/create_task_request_model.dart';
import '../model/create_task_response_model.dart';
import '../../domain/entity/create_task_entity.dart';

class CreateTaskModelAdapter {
  static CreateTaskRequestModel fromEntity(CreateTaskRequestEntity entity) {
    return CreateTaskRequestModel(
      procedureGroupId: entity.procedureGroupId,
      procedureId: entity.procedureId,
      localId: entity.localId,
      assetId: entity.assetId,
      allDay: entity.allDay,
      dtStart: entity.dtStart,
      timeStart: entity.timeStart,
      repeat: entity.repeat,
      rrule: entity.rrule != null
          ? RruleModel(
              frequency: entity.rrule!.frequency,
              byDays: entity.rrule!.byDays,
            )
          : null,
    );
  }

  static CreateTaskResponseEntity toEntity(CreateTaskResponseModel model) {
    return CreateTaskResponseEntity(
      idSchedule: model.idSchedule,
      idScheduleEvents: model.idScheduleEvents,
    );
  }
}
