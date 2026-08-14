import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_period_interval_model.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_period.dart';

part 'vacation_period_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationPeriodModel {
  List<VacationPeriodIntervalModel?> gdpPeriodAmount;
  int gdpPeriodVacation;

  VacationPeriodModel({
    this.gdpPeriodAmount = const [],
    this.gdpPeriodVacation = 0,
  });

  factory VacationPeriodModel.fromJson(Map<String, dynamic> json) =>
      _$VacationPeriodModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationPeriodModelToJson(this);

  static VacationPeriodModel? fromEntity(VacationPeriod? entity) =>
      entity == null
          ? null
          : (VacationPeriodModel()
            ..gdpPeriodAmount = entity.intervals
                .map((e) => VacationPeriodIntervalModel.fromEntity(e))
                .toList()
            ..gdpPeriodVacation = entity.periodsNumber);

  VacationPeriod toEntity() => VacationPeriod(
      intervals: this.gdpPeriodAmount.map((e) => e?.toEntity()).toList(),
      periodsNumber: this.gdpPeriodVacation);

  map(Function(dynamic model) param0) {}
}
