import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_scheduled_periods.dart';

part 'vacation_scheduled_periods_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationScheduledPeriodsModel {
  DateTime? startDate;
  int? scheduledDays;
  int? totalVacation;

  VacationScheduledPeriodsModel({
    required this.startDate,
    required this.scheduledDays,
    required this.totalVacation,
  });

  factory VacationScheduledPeriodsModel.fromJson(Map<String, dynamic> json) =>
      _$VacationScheduledPeriodsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationScheduledPeriodsModelToJson(this);

  static VacationScheduledPeriodsModel? fromEntity(
          VacationScheduledPeriods? entity) =>
      entity == null
          ? null
          : (VacationScheduledPeriodsModel(
              startDate: entity.startDate,
              scheduledDays: entity.scheduledDays,
              totalVacation: entity.totalVacation,
            ));

  VacationScheduledPeriods toEntity() => VacationScheduledPeriods(
        startDate: this.startDate,
        scheduledDays: this.scheduledDays,
        totalVacation: this.totalVacation,
      );
}
