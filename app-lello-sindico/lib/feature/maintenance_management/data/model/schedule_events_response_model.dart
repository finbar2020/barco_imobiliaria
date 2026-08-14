import 'task_summary_model.dart';
import 'schedule_event_task_model.dart';

class ScheduleEventsResponseModel {
  final bool success;
  final String message;
  final ScheduleEventsDataModel? data;
  final String? errorCode;
  final int legacyStatusCode;

  const ScheduleEventsResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.errorCode,
    required this.legacyStatusCode,
  });

  factory ScheduleEventsResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleEventsResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ScheduleEventsDataModel.fromJson(
              json['data'] as Map<String, dynamic>)
          : null,
      errorCode: json['errorCode'] as String?,
      legacyStatusCode: json['legacyStatusCode'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'errorCode': errorCode,
      'legacyStatusCode': legacyStatusCode,
    };
  }

  TaskSummaryModel? get taskSummaryDay => data?.taskSummaryDay;
  List<ScheduleEventTaskModel> get taskFormulary => data?.taskFormulary ?? [];
}

class ScheduleEventsDataModel {
  final TaskSummaryModel? taskSummaryDay;
  final List<ScheduleEventTaskModel> taskFormulary;

  const ScheduleEventsDataModel({
    this.taskSummaryDay,
    required this.taskFormulary,
  });

  factory ScheduleEventsDataModel.fromJson(Map<String, dynamic> json) {
    return ScheduleEventsDataModel(
      taskSummaryDay: json['taskSummaryDay'] != null
          ? TaskSummaryModel.fromJson(
              json['taskSummaryDay'] as Map<String, dynamic>)
          : null,
      taskFormulary: (json['taskFormulary'] as List<dynamic>? ?? [])
          .map(
              (e) => ScheduleEventTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskSummaryDay': taskSummaryDay?.toJson(),
      'taskFormulary': taskFormulary.map((e) => e.toJson()).toList(),
    };
  }
}
