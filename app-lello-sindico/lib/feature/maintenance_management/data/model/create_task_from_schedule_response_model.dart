import 'package:essentials/essentials.dart';

part 'create_task_from_schedule_response_model.g.dart';

@JsonSerializable()
class CreateTaskFromScheduleResponseModel {
  final TaskCreatedModel task;
  final EventCreatedModel event;

  CreateTaskFromScheduleResponseModel({
    required this.task,
    required this.event,
  });

  factory CreateTaskFromScheduleResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$CreateTaskFromScheduleResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateTaskFromScheduleResponseModelToJson(this);
}

@JsonSerializable()
class TaskCreatedModel {
  final String id;
  final String name;
  @JsonKey(name: 'current_responsible_name')
  final String? currentResponsibleName;
  @JsonKey(name: 'current_responsible_id')
  final String? currentResponsibleId;

  TaskCreatedModel({
    required this.id,
    required this.name,
    this.currentResponsibleName,
    this.currentResponsibleId,
  });

  factory TaskCreatedModel.fromJson(Map<String, dynamic> json) =>
      _$TaskCreatedModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCreatedModelToJson(this);
}

@JsonSerializable()
class EventCreatedModel {
  final String id;
  final String? name;
  @JsonKey(name: 'last_content_answers')
  final LastContentAnswersModel? lastContentAnswers;

  EventCreatedModel({
    required this.id,
    this.name,
    this.lastContentAnswers,
  });

  factory EventCreatedModel.fromJson(Map<String, dynamic> json) =>
      _$EventCreatedModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventCreatedModelToJson(this);
}

@JsonSerializable()
class LastContentAnswersModel {
  final String questionId;
  final String type;
  final String content;
  final String updatedAt;
  final String formularyId;
  final String? deletedAt;

  LastContentAnswersModel({
    required this.questionId,
    required this.type,
    required this.content,
    required this.updatedAt,
    required this.formularyId,
    this.deletedAt,
  });

  factory LastContentAnswersModel.fromJson(Map<String, dynamic> json) =>
      _$LastContentAnswersModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastContentAnswersModelToJson(this);
}
