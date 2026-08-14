import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/lancamento_model.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
part 'payment_installment_in_approval_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentInstallmentInApprovalModel {
  final int? installmentId;
  final String? dueDate;
  final LancamentoModel? installment;

  PaymentInstallmentInApprovalModel({
    this.installmentId,
    this.dueDate,
    this.installment,
  });

  factory PaymentInstallmentInApprovalModel.fromJson(
          Map<String, dynamic> json) =>
      _$PaymentInstallmentInApprovalModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaymentInstallmentInApprovalModelToJson(this);

  static PaymentInstallmentInApprovalModel? fromEntity(
      PaymentInstallmentInApprovalEntity? entity) {
    if (entity == null) return null;
    return PaymentInstallmentInApprovalModel(
      installmentId: entity.installmentId,
      dueDate: entity.dueDate.toString(),
      installment: LancamentoModel.fromEntity(entity.lancamento),
    );
  }

  PaymentInstallmentInApprovalEntity toEntity() {
    return PaymentInstallmentInApprovalEntity(
      installmentId: installmentId,
      dueDate: dueDate,
      lancamento: installment?.toEntity(),
    );
  }
}
