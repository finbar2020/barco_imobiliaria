import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';

part 'agreement_installment_credit_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementInstallmentCreditModel {
  double billetValue;
  double installmentQtd;
  double? tax;
  double totalValue;
  double installmentValue;
  String? cetMonth;
  String? cetTotal;
  String? creditTax;
  double? creditTaxValue;

  AgreementInstallmentCreditModel({
    required this.billetValue,
    required this.installmentQtd,
    this.tax,
    required this.totalValue,
    required this.installmentValue,
    this.cetMonth,
    this.cetTotal,
    this.creditTax,
    this.creditTaxValue,
  });

  factory AgreementInstallmentCreditModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementInstallmentCreditModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AgreementInstallmentCreditModelToJson(this);

  static AgreementInstallmentCreditModel fromEntity(
          AgreementInstallmentCredit entity) =>
      (AgreementInstallmentCreditModel(
        billetValue: entity.billetValue,
        installmentQtd: entity.installmentQtd,
        tax: entity.tax,
        totalValue: entity.totalValue,
        installmentValue: entity.installmentValue,
        cetMonth: entity.cetMonth,
        cetTotal: entity.cetTotal,
        creditTax: entity.creditTax,
        creditTaxValue: entity.creditTaxValue,
      ));

  AgreementInstallmentCredit toEntity() => AgreementInstallmentCredit(
        billetValue: this.billetValue,
        installmentQtd: this.installmentQtd,
        tax: this.tax,
        totalValue: this.totalValue,
        installmentValue: this.installmentValue,
        cetMonth: this.cetMonth,
        cetTotal: this.cetTotal,
        creditTax: this.creditTax,
        creditTaxValue: this.creditTaxValue,
      );
}
