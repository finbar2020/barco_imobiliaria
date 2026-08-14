import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/data/model/agreement_installment_model.dart';
import 'package:lello/feature/agreements/data/model/agreement_quote_model.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';

part 'agreement_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementModel {
  String? id;
  int reference;
  String? unit;
  String? unitOwner;
  double baseValue;
  double fineAndCosts;
  int installmentQuantity;
  String? paymentMethod;
  String? status;
  String? statusMessage;
  DateTime? expiration;
  DateTime? proposaldedDate;
  DateTime? approvalDate;
  int dueDate;
  DateTime? lastInstallmentDate;
  List<AgreementInstallmentModel> installments;
  List<AgreementQuoteModel> quotes;
  String? notificationParameter;

  AgreementModel({
    this.id,
    this.reference = 0,
    this.unit,
    this.unitOwner,
    this.baseValue = 0.0,
    this.fineAndCosts = 0.0,
    this.installmentQuantity = 0,
    this.paymentMethod,
    this.status,
    this.statusMessage,
    this.expiration,
    this.proposaldedDate,
    this.approvalDate,
    this.dueDate = 0,
    this.lastInstallmentDate,
    this.installments = const [],
    this.quotes = const [],
    this.notificationParameter,
  });

  factory AgreementModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementModelToJson(this);

  static AgreementModel? fromEntity(Agreement? entity) => entity == null
      ? null
      : AgreementModel(
          id: entity.id,
          unit: entity.unit,
          unitOwner: entity.unitOwner,
          baseValue: entity.baseValue,
          fineAndCosts: entity.fineAndCosts,
          installmentQuantity: entity.installmentQuantity,
          paymentMethod: entity.paymentMethod,
          proposaldedDate: entity.proposaldedDate,
          status: entity.status,
          approvalDate: entity.approvalDate,
          dueDate: entity.dueDate,
          reference: entity.reference,
          lastInstallmentDate: entity.lastInstallmentDate,
          installments: entity.installments
              .map((e) => AgreementInstallmentModel.fromEntity(e)!)
              .toList(),
          quotes: entity.quotes
              .map((e) => AgreementQuoteModel.fromEntity(e))
              .toList(),
          notificationParameter: entity.notificationParameter);

  Agreement toEntity() => Agreement(
        id: id,
        unit: unit,
        unitOwner: unitOwner,
        baseValue: baseValue,
        fineAndCosts: fineAndCosts,
        installmentQuantity: installmentQuantity,
        paymentMethod: paymentMethod,
        proposaldedDate: proposaldedDate,
        status: status,
        approvalDate: approvalDate,
        dueDate: dueDate,
        reference: reference,
        lastInstallmentDate: lastInstallmentDate,
        installments: installments.map((e) => e.toEntity()).toList(),
        quotes: quotes.map((e) => e.toEntity()).toList(),
        notificationParameter: notificationParameter,
      );
}
