import 'package:essentials/essentials.dart';

part 'create_task_from_schedule_request_model.g.dart';

@JsonSerializable()
class CreateTaskFromScheduleRequestModel {
  final String scheduleId;
  final String scheduleEventId;

  CreateTaskFromScheduleRequestModel({
    required this.scheduleId,
    required this.scheduleEventId,
  });

  factory CreateTaskFromScheduleRequestModel.fromJson(
          Map<String, dynamic> json) =>
      _$CreateTaskFromScheduleRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateTaskFromScheduleRequestModelToJson(this);
}
