import 'package:essentials/essentials.dart';
import 'child_task_model.dart';

part 'maintenance_task_event_model.g.dart';

@JsonSerializable()
class MaintenanceTaskEventModel {
  final String? idTask;
  final String? idSchedule;
  final String? idScheduleEvent;
  final String typeTask;
  final String name;
  final String fullDescription;
  final String responsibleUserable;
  final String? procedureGroupId;
  final String? responsibleId;
  final String timeStart;
  final String timeDescription;
  final String dtstart;
  final String dtstartFormatted;
  final String status;
  final bool allDay;
  final String? rrule;
  final String? rruleDescription;
  final List<ChildTaskModel>? childTasks;

  MaintenanceTaskEventModel({
    this.idTask,
    this.idSchedule,
    this.idScheduleEvent,
    required this.typeTask,
    required this.name,
    required this.fullDescription,
    required this.responsibleUserable,
    this.procedureGroupId,
    this.responsibleId,
    required this.timeStart,
    required this.timeDescription,
    required this.dtstart,
    required this.dtstartFormatted,
    required this.status,
    required this.allDay,
    this.rrule,
    this.rruleDescription,
    this.childTasks,
  });

  factory MaintenanceTaskEventModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceTaskEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceTaskEventModelToJson(this);
}
