import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment.dart';

part 'agreement_installment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementInstallmentModel {
  String? installmentId;
  double value;
  DateTime? dueDate;
  String? status;

  AgreementInstallmentModel({
    this.installmentId,
    this.value = 0.0,
    this.dueDate,
    this.status,
  });

  factory AgreementInstallmentModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementInstallmentModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementInstallmentModelToJson(this);

  static AgreementInstallmentModel? fromEntity(AgreementInstallment? entity) =>
      entity == null
          ? null
          : AgreementInstallmentModel(
              value: entity.value,
              dueDate: entity.dueDate,
              status: entity.status,
            );

  AgreementInstallment toEntity() => AgreementInstallment(
        value: this.value,
        dueDate: this.dueDate,
        status: this.status,
      );
}
