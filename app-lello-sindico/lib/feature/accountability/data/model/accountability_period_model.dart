import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_periods.dart';

part 'accountability_period_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityPeriodModel {
  DateTime period;
  String situation;
  DateTime? approvalDate;
  DateTime? initialPeriod;
  DateTime? endingPeriod;

  AccountabilityPeriodModel({
    required this.period,
    required this.situation,
    this.approvalDate,
    this.endingPeriod,
    this.initialPeriod,
  });

  factory AccountabilityPeriodModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityPeriodModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountabilityPeriodModelToJson(this);

  static AccountabilityPeriodModel? fromEntity(AccountabilityPeriods? entity) =>
      entity == null
          ? null
          : (AccountabilityPeriodModel(
              period: entity.period, situation: entity.situation));

  AccountabilityPeriods toEntity() => AccountabilityPeriods(
        period: this.period,
        situation: this.situation,
        approvalDate: this.approvalDate,
        initialPeriod: this.initialPeriod,
        endingPeriod: this.endingPeriod,
      );
}
