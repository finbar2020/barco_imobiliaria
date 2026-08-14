import 'package:essentials/essentials.dart';

part 'create_task_response_model.g.dart';

@JsonSerializable()
class CreateTaskResponseModel {
  @JsonKey(name: 'idSchedule')
  final String idSchedule;
  
  @JsonKey(name: 'idScheduleEvents')
  final List<String> idScheduleEvents;

  CreateTaskResponseModel({
    required this.idSchedule,
    required this.idScheduleEvents,
  });

  factory CreateTaskResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskResponseModelToJson(this);
}
