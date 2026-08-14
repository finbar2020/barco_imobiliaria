import 'package:essentials/essentials.dart';
import 'maintenance_task_event_model.dart';
import 'task_summary_model.dart';

part 'maintenance_task_events_response_model.g.dart';

@JsonSerializable()
class MaintenanceTaskEventsResponseModel {
  final TaskSummaryModel taskSummaryDay;
  final List<MaintenanceTaskEventModel> taskFormulary;

  MaintenanceTaskEventsResponseModel({
    required this.taskSummaryDay,
    required this.taskFormulary,
  });

  factory MaintenanceTaskEventsResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$MaintenanceTaskEventsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MaintenanceTaskEventsResponseModelToJson(this);
}
