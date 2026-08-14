import 'package:essentials/essentials.dart';
import 'task_summary_model.dart';

part 'efficiency_response_model.g.dart';

@JsonSerializable()
class EfficiencyItemModel {
  final String id;
  final String name;
  final int done;
  @JsonKey(name: 'not_started')
  final int notStarted;
  final int draft;

  EfficiencyItemModel({
    required this.id,
    required this.name,
    required this.done,
    required this.notStarted,
    required this.draft,
  });

  factory EfficiencyItemModel.fromJson(Map<String, dynamic> json) =>
      _$EfficiencyItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$EfficiencyItemModelToJson(this);
}

@JsonSerializable()
class EfficiencyResponseModel {
  @JsonKey(name: 'efficiency_response')
  final List<EfficiencyItemModel> efficiencyResponse;
  @JsonKey(name: 'task_summary')
  final TaskSummaryModel taskSummary;

  EfficiencyResponseModel({
    required this.efficiencyResponse,
    required this.taskSummary,
  });

  factory EfficiencyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EfficiencyResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$EfficiencyResponseModelToJson(this);
}
