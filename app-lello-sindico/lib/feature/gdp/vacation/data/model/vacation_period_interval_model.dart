import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/vacation/domain/entity/vacation_period_interval.dart';

part 'vacation_period_interval_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationPeriodIntervalModel {
  List<int> days;
  int allowence;

  VacationPeriodIntervalModel({
    this.days = const [],
    this.allowence = 0,
  });

  factory VacationPeriodIntervalModel.fromJson(Map<String, dynamic> json) =>
      _$VacationPeriodIntervalModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationPeriodIntervalModelToJson(this);

  static VacationPeriodIntervalModel? fromEntity(
          VacationPeriodInterval? entity) =>
      entity == null
          ? null
          : (VacationPeriodIntervalModel()
            ..days = entity.intervals
            ..allowence = entity.allowence);

  VacationPeriodInterval toEntity() => VacationPeriodInterval(
        intervals: this.days,
        allowence: this.allowence,
      );

  map(Function(dynamic model) param0) {}
}
