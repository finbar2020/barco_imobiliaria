import 'package:essentials/essentials.dart';

part 'task_formularies_model.g.dart';

@JsonSerializable()
class TaskFormulariesResponseModel {
  final List<TaskFormularyModel> formularies;

  TaskFormulariesResponseModel({required this.formularies});

  factory TaskFormulariesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TaskFormulariesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskFormulariesResponseModelToJson(this);
}

@JsonSerializable()
class TaskFormularyModel {
  final String? id;
  final String name;
  @JsonKey(name: 'responsible_name')
  final String? responsibleName;
  final String status;
  @JsonKey(name: 'event_id')
  final String? eventId;
  final int position;
  @JsonKey(name: 'author_id')
  final String? authorId;
  @JsonKey(name: 'max_created_at')
  final String? maxCreatedAt;
  @JsonKey(name: 'finished_at')
  final String? finishedAt;
  @JsonKey(name: 'can_start')
  final bool? canStart;

  TaskFormularyModel({
    this.id,
    required this.name,
    this.responsibleName,
    required this.status,
    this.eventId,
    required this.position,
    this.authorId,
    this.maxCreatedAt,
    this.finishedAt,
    this.canStart,
  });

  factory TaskFormularyModel.fromJson(Map<String, dynamic> json) =>
      _$TaskFormularyModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskFormularyModelToJson(this);
}
