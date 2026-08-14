import 'package:json_annotation/json_annotation.dart';

part 'delete_schedule_event_request_model.g.dart';

@JsonSerializable(createFactory: false)
class DeleteScheduleEventRequestModel {
  @JsonKey(name: 'scheduleEventId')
  final String scheduleEventId;

  @JsonKey(name: 'mode')
  final String mode;

  const DeleteScheduleEventRequestModel({
    required this.scheduleEventId,
    required this.mode,
  });

  Map<String, dynamic> toJson() =>
      _$DeleteScheduleEventRequestModelToJson(this);
}
