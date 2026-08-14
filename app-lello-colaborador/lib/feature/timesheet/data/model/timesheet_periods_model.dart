import 'package:colaborador/feature/timesheet/domain/entity/timesheet_periods.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timesheet_periods_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetPeriodsModel {
  DateTime periodMonth;
  DateTime startDate;
  DateTime endDate;

  TimesheetPeriodsModel({
    required this.periodMonth,
    required this.startDate,
    required this.endDate,
  });

  factory TimesheetPeriodsModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetPeriodsModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimesheetPeriodsModelToJson(this);

  static TimesheetPeriodsModel? fromEntity(TimesheetPeriods? entity) =>
      entity == null
          ? null
          : TimesheetPeriodsModel(
              periodMonth: entity.periodMonth,
              startDate: entity.startDate,
              endDate: entity.endDate,
            );

  TimesheetPeriods? toEntity() => TimesheetPeriods(
        periodMonth: periodMonth,
        startDate: startDate,
        endDate: endDate,
      );
}
