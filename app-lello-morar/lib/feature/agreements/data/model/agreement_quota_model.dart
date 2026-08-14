import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';

part 'agreement_quota_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementQuotaModel {
  String id;
  String receipt;
  double originValue;
  DateTime dueDate;
  double fineValue;
  double feeValue;
  double honoraryValue;
  String overdueMessage;

  AgreementQuotaModel({
    required this.id,
    required this.receipt,
    required this.originValue,
    required this.dueDate,
    required this.fineValue,
    required this.feeValue,
    required this.honoraryValue,
    required this.overdueMessage,
  });

  factory AgreementQuotaModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementQuotaModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementQuotaModelToJson(this);

  static AgreementQuotaModel fromEntity(AgreementQuota entity) =>
      (AgreementQuotaModel(
        id: entity.id,
        receipt: entity.receipt,
        originValue: entity.originValue,
        dueDate: entity.dueDate,
        fineValue: entity.fineValue,
        feeValue: entity.feeValue,
        honoraryValue: entity.honoraryValue,
        overdueMessage: entity.overdueMessage,
      ));

  AgreementQuota toEntity() => AgreementQuota(
        id: this.id,
        receipt: this.receipt,
        originValue: this.originValue,
        dueDate: this.dueDate,
        fineValue: this.fineValue,
        feeValue: this.feeValue,
        honoraryValue: this.honoraryValue,
        overdueMessage: this.overdueMessage,
      );
}
