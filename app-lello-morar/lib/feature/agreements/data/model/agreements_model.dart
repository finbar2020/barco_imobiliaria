import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/data/model/agreement_installment_model.dart';
import 'package:morar/feature/agreements/data/model/agreement_quota_model.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';

part 'agreements_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementModel {
  final String id;
  final String unit;
  final String unitOwner;
  final double baseValue;
  final double fineAndCosts;
  final String paymentMethod;
  final String expiration;
  final int installmentQuantity;
  final String proposaldedDate;
  final String? approvalDate;
  final String? agreementCodeAcob;
  final int reference;
  final DateTime? lastInstallmentDate;
  final String status;
  final String statusMessage;
  final List<AgreementInstallmentModel> installments;
  final List<AgreementQuotaModel> quotes;
  final String? reason;
  String? notificationParameter;

  AgreementModel({
    required this.id,
    required this.unit,
    required this.unitOwner,
    required this.baseValue,
    required this.fineAndCosts,
    required this.paymentMethod,
    required this.expiration,
    required this.installmentQuantity,
    required this.proposaldedDate,
    this.approvalDate,
    this.agreementCodeAcob,
    required this.reference,
    this.lastInstallmentDate,
    required this.status,
    required this.statusMessage,
    required this.installments,
    required this.quotes,
    this.reason,
    this.notificationParameter,
  });

  factory AgreementModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementModelToJson(this);

  static AgreementModel fromEntity(Agreement entity) => (AgreementModel(
        id: entity.id,
        unit: entity.unit,
        unitOwner: entity.unitOwner,
        baseValue: entity.baseValue,
        fineAndCosts: entity.fineAndCosts,
        paymentMethod: entity.paymentMethod,
        expiration: entity.expiration,
        installmentQuantity: entity.installmentQuantity,
        proposaldedDate: entity.proposaldedDate,
        approvalDate: entity.approvalDate,
        agreementCodeAcob: entity.agreementCodeAcob,
        reference: entity.reference,
        lastInstallmentDate: entity.lastInstallmentDate,
        status: entity.status,
        statusMessage: entity.statusMessage,
        installments: entity.installments
            .map((e) => AgreementInstallmentModel.fromEntity(e))
            .toList(),
        quotes: entity.quotes
            .map((e) => AgreementQuotaModel.fromEntity(e))
            .toList(),
        reason: entity.reason,
        notificationParameter: entity.notificationParameter,
      ));

  Agreement toEntity() => Agreement(
        id: this.id,
        unit: this.unit,
        unitOwner: this.unitOwner,
        baseValue: this.baseValue,
        fineAndCosts: this.fineAndCosts,
        paymentMethod: this.paymentMethod,
        expiration: this.expiration,
        installmentQuantity: this.installmentQuantity,
        proposaldedDate: this.proposaldedDate,
        approvalDate: this.approvalDate,
        agreementCodeAcob: this.agreementCodeAcob,
        reference: this.reference,
        lastInstallmentDate: this.lastInstallmentDate,
        status: this.status,
        statusMessage: this.statusMessage,
        installments: this.installments.map((e) => e.toEntity()).toList(),
        quotes: this.quotes.map((e) => e.toEntity()).toList(),
        reason: this.reason,
        notificationParameter: this.notificationParameter,
      );
}
