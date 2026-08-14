import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment.dart';

part 'agreement_installment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementInstallmentModel {
  String? readableLine;
  String? barCode;
  String? installmentId;
  String? recnum;
  double? value;
  DateTime? dueDate;
  String? status;
  String? paymentLink;

  AgreementInstallmentModel({
    this.readableLine,
    this.barCode,
    this.installmentId,
    this.recnum,
    this.value,
    this.dueDate,
    this.status,
    this.paymentLink,
  });

  factory AgreementInstallmentModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementInstallmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementInstallmentModelToJson(this);

  static AgreementInstallmentModel fromEntity(AgreementInstallment entity) =>
      (AgreementInstallmentModel(
        readableLine: entity.readableLine,
        barCode: entity.barCode,
        installmentId: entity.installmentId,
        recnum: entity.recnum,
        value: entity.value,
        dueDate: entity.dueDate,
        status: entity.status,
        paymentLink: entity.paymentLink,
      ));

  AgreementInstallment toEntity() => AgreementInstallment(
        readableLine: this.readableLine,
        barCode: this.barCode,
        installmentId: this.installmentId,
        recnum: this.recnum,
        value: this.value,
        dueDate: this.dueDate,
        status: this.status,
        paymentLink: this.paymentLink,
      );
}
