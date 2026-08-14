import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/ledger_account_model.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
part 'supplier_ledger_accounts_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierLedgerAccountsModel {
  final LedgerAccountModel? recommendation;
  final List<LedgerAccountModel?> ordinary;
  final List<LedgerAccountModel?> extraordinary;
  final List<LedgerAccountModel?> all;

  SupplierLedgerAccountsModel({
    this.recommendation,
    this.ordinary = const [],
    this.extraordinary = const [],
    this.all = const [],
  });

  factory SupplierLedgerAccountsModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierLedgerAccountsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierLedgerAccountsModelToJson(this);

  static SupplierLedgerAccountsModel? fromEntity(
      SupplierLedgerAccountsEntity? entity) {
    if (entity == null) return null;
    return SupplierLedgerAccountsModel(
      recommendation: LedgerAccountModel.fromEntity(entity.recomendation),
      ordinary: entity.ordinary
          .map((account) => LedgerAccountModel.fromEntity(account))
          .toList(),
      extraordinary: entity.extraordinary
          .map((account) => LedgerAccountModel.fromEntity(account))
          .toList(),
      all: entity.all
          .map((account) => LedgerAccountModel.fromEntity(account))
          .toList(),
    );
  }

  SupplierLedgerAccountsEntity toEntity() {
    return SupplierLedgerAccountsEntity(
      recomendation: recommendation?.toEntity(),
      ordinary: ordinary.isNotEmpty
          ? ordinary.map((account) => account!.toEntity()).toList()
          : [],
      extraordinary: extraordinary.isNotEmpty
          ? extraordinary.map((account) => account!.toEntity()).toList()
          : [],
      all: all.isNotEmpty
          ? all.map((account) => account!.toEntity()).toList()
          : [],
    );
  }
}
