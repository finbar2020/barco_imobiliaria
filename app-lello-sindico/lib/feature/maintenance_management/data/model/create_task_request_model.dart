import 'package:essentials/essentials.dart';

part 'create_task_request_model.g.dart';

@JsonSerializable()
class RruleModel {
  final String frequency;
  final List<String>? byDays;

  RruleModel({
    required this.frequency,
    this.byDays,
  });

  factory RruleModel.fromJson(Map<String, dynamic> json) =>
      _$RruleModelFromJson(json);

  Map<String, dynamic> toJson() => _$RruleModelToJson(this);
}

@JsonSerializable()
class CreateTaskRequestModel {
  final String procedureGroupId;
  final String procedureId;
  @JsonKey(includeIfNull: false)
  final String? localId;
  final String? assetId;
  final bool allDay;
  final String dtStart;
  final String? timeStart;
  final bool repeat;
  final RruleModel? rrule;

  CreateTaskRequestModel({
    required this.procedureGroupId,
    required this.procedureId,
    this.localId,
    this.assetId,
    required this.allDay,
    required this.dtStart,
    this.timeStart,
    required this.repeat,
    this.rrule,
  });

  factory CreateTaskRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskRequestModelToJson(this);
}
