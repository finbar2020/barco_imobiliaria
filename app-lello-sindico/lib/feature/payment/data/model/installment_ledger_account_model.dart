import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
part 'installment_ledger_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstallmentLedgerAccountModel {
  int? shortCode;
  String? name;
  String? recommendation;
  String? category;

  InstallmentLedgerAccountModel();

  factory InstallmentLedgerAccountModel.fromJson(Map<String, dynamic> json) =>
      _$InstallmentLedgerAccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentLedgerAccountModelToJson(this);

  static InstallmentLedgerAccountModel? fromEntity(
          PaymentInstallmentLedgerAccount? entity) =>
      entity == null
          ? null
          : (InstallmentLedgerAccountModel()
            ..shortCode = entity.shortCode
            ..name = entity.name
            ..recommendation = entity.recommendation
            ..category = entity.category);

  PaymentInstallmentLedgerAccount toEntity() => PaymentInstallmentLedgerAccount(
        shortCode: shortCode,
        name: name,
        recommendation: recommendation,
        category: category,
      );
}
