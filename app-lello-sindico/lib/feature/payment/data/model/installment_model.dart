import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/installment.dart';
part 'installment_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstallmentModel {
  final int? id;
  final DateTime dueDate;
  final double value;
  final int? paymentFormId;
  final int? paymentTypeId;
  final String? agency;
  final int? bankId;
  final String? accountDigit;
  final String? accountNumber;
  final String? accountType;

  InstallmentModel({
    this.id,
    required this.dueDate,
    required this.value,
    this.paymentFormId,
    this.paymentTypeId,
    this.agency,
    this.bankId,
    this.accountDigit,
    this.accountNumber,
    this.accountType,
  });

  factory InstallmentModel.fromJson(Map<String, dynamic> json) =>
      _$InstallmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstallmentModelToJson(this);

  static InstallmentModel? fromEntity(InstallmentEntity? entity) {
    if (entity == null) return null;
    return InstallmentModel(
      id: entity.id,
      dueDate: entity.dueDate,
      value: entity.value,
      paymentFormId: entity.paymentFormId,
      paymentTypeId: entity.paymentTypeId,
      agency: entity.agency,
      bankId: entity.bankId,
      accountDigit: entity.accountDigit,
      accountNumber: entity.accountNumber,
      accountType: entity.accountType,
    );
  }

  InstallmentEntity toEntity() {
    return InstallmentEntity(
      id: id,
      dueDate: dueDate,
      value: value,
      paymentFormId: paymentFormId,
      paymentTypeId: paymentTypeId,
      agency: agency,
      bankId: bankId,
      accountDigit: accountDigit,
      accountNumber: accountNumber,
      accountType: accountType,
    );
  }
}
