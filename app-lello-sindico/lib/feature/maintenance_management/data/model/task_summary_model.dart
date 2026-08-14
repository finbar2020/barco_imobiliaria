import 'package:essentials/essentials.dart';

part 'task_summary_model.g.dart';

@JsonSerializable()
class TaskSummaryModel {
  final int total;
  final int done;
  final int notStarted;
  final int draft;

  TaskSummaryModel({
    required this.total,
    required this.done,
    required this.notStarted,
    required this.draft,
  });

  factory TaskSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TaskSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskSummaryModelToJson(this);
}
