import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/update_transaction_installments_entity.dart';
part 'update_transaction_installments.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateTransactionInstallments {
  final int? transactionId;
  final int? installmentId;

  UpdateTransactionInstallments({
    this.transactionId,
    this.installmentId,
  });

  factory UpdateTransactionInstallments.fromJson(Map<String, dynamic> json) =>
      _$UpdateTransactionInstallmentsFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTransactionInstallmentsToJson(this);

  static UpdateTransactionInstallments? fromEntity(
      UpdateTransactionInstallmentsEntity? entity) {
    if (entity == null) return null;
    return UpdateTransactionInstallments(
      transactionId: entity.transactionId,
      installmentId: entity.installmentId,
    );
  }

  UpdateTransactionInstallmentsEntity toEntity() {
    return UpdateTransactionInstallmentsEntity(
      transactionId: transactionId,
      installmentId: installmentId,
    );
  }
}
