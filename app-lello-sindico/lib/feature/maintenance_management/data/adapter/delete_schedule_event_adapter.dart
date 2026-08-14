import '../../domain/entity/delete_schedule_event_entity.dart';
import '../model/delete_schedule_event_request_model.dart';
import '../model/delete_schedule_event_response_model.dart';

class DeleteScheduleEventAdapter {
  static DeleteScheduleEventRequestModel fromEntity(
      DeleteScheduleEventRequestEntity entity) {
    return DeleteScheduleEventRequestModel(
      scheduleEventId: entity.scheduleEventId,
      mode: entity.mode,
    );
  }

  static DeleteScheduleEventResponseEntity toEntity(
      DeleteScheduleEventResponseModel model) {
    return DeleteScheduleEventResponseEntity(
      success: model.success,
      message: model.message,
    );
  }
}
