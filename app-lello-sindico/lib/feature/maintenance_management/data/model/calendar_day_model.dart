import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/calendar_day_entity.dart';

part 'calendar_day_model.g.dart';

@JsonSerializable()
class CalendarDayModel {
  final int day;

  final bool hasEvents;

  final int taskCount;

  const CalendarDayModel({
    required this.day,
    required this.hasEvents,
    required this.taskCount,
  });

  factory CalendarDayModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarDayModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarDayModelToJson(this);

  /// Converte para entidade do domínio
  CalendarDayEntity toEntity() {
    return CalendarDayEntity(
      day: day,
      hasEvents: hasEvents,
      taskCount: taskCount,
    );
  }

  factory CalendarDayModel.fromEntity(CalendarDayEntity entity) {
    return CalendarDayModel(
      day: entity.day,
      hasEvents: entity.hasEvents,
      taskCount: entity.taskCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDayModel &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          hasEvents == other.hasEvents &&
          taskCount == other.taskCount;

  @override
  int get hashCode => day.hashCode ^ hasEvents.hashCode ^ taskCount.hashCode;

  @override
  String toString() {
    return 'CalendarDayModel(day: $day, hasEvents: $hasEvents, taskCount: $taskCount)';
  }
}
