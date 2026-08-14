import 'package:json_annotation/json_annotation.dart';

part 'delete_schedule_event_response_model.g.dart';

@JsonSerializable(createToJson: false)
class DeleteScheduleEventResponseModel {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'message')
  final String? message;

  const DeleteScheduleEventResponseModel({
    required this.success,
    this.message,
  });

  factory DeleteScheduleEventResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$DeleteScheduleEventResponseModelFromJson(json);
}
