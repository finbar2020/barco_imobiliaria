import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';

part 'vacation_locked_days_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VacationLockedDaysModel {
  List<String> locked_days;

  VacationLockedDaysModel({
    this.locked_days = const [],
  });

  factory VacationLockedDaysModel.fromJson(Map<String, dynamic> json) =>
      _$VacationLockedDaysModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacationLockedDaysModelToJson(this);

  static VacationLockedDaysModel? fromEntity(VacationLockedDays? entity) =>
      entity == null
          ? null
          : (VacationLockedDaysModel()..locked_days = entity.locked_days);

  VacationLockedDays toEntity() =>
      VacationLockedDays()..locked_days = this.locked_days;
}
