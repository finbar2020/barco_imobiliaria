import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/vacation/data/model/vacation_period_model.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_params.dart';

part 'vacation_params_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationParamsModel {
  List<VacationPeriodModel?> gdpVacationPeriods;
  int gdpVacationInitDays;

  VacationParamsModel({
    this.gdpVacationPeriods = const [],
    this.gdpVacationInitDays = 0,
  });

  factory VacationParamsModel.fromJson(Map<String, dynamic> json) =>
      _$VacationParamsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationParamsModelToJson(this);

  // static VacationParamsModel? fromEntity(VacationPeriod? entity) =>
  //     entity == null
  //         ? null
  //         : (VacationParamsModel()
  //           ..gdpVacationPeriods = entity.intervals
  //               .map((e) => VacationPeriodIntervalModel.fromEntity(e))
  //               .toList()
  //           ..gdpVacationInitDays = entity.periodsNumber);

  VacationParams toEntity() => VacationParams(
      periods: this.gdpVacationPeriods.map((e) => e?.toEntity()).toList(),
      qtdInitDays: this.gdpVacationInitDays);

  map(Function(dynamic model) param0) {}
}
