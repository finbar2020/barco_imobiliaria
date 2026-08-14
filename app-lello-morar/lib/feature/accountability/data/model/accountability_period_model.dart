import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_periods.dart';

part 'accountability_period_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityPeriodModel {
  DateTime? period;
  String? situation;
  DateTime? approvalDate;

  AccountabilityPeriodModel();

  factory AccountabilityPeriodModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityPeriodModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountabilityPeriodModelToJson(this);

  static AccountabilityPeriodModel? fromEntity(AccountabilityPeriods? entity) =>
      entity == null
          ? null
          : (AccountabilityPeriodModel()
            ..period = entity.period
            ..situation = entity.situation
            ..approvalDate = entity.approvalDate);

  AccountabilityPeriods toEntity() => AccountabilityPeriods()
    ..period = this.period
    ..situation = this.situation
    ..approvalDate = this.approvalDate;
}
