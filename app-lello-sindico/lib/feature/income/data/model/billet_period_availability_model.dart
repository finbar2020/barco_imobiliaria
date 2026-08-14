import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/income/domain/entity/billet_periods_availability.dart';

part 'billet_period_availability_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BilletPeriodsAvailabilityModel {
  List<String> months;

  BilletPeriodsAvailabilityModel({
    this.months = const [],
  });

  factory BilletPeriodsAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$BilletPeriodsAvailabilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$BilletPeriodsAvailabilityModelToJson(this);

  static BilletPeriodsAvailabilityModel? fromEntity(
          BilletPeriodAvailability? entity) =>
      entity == null
          ? null
          : (BilletPeriodsAvailabilityModel()..months = entity.months);

  BilletPeriodAvailability toEntity() =>
      BilletPeriodAvailability()..months = months;
}
