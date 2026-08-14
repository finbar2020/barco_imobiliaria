import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_account.dart';

part 'supplier_ledger_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierLedgerAccountModel {
  int? id;
  String? name;

  SupplierLedgerAccountModel();

  factory SupplierLedgerAccountModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierLedgerAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierLedgerAccountModelToJson(this);

  static SupplierLedgerAccountModel? fromEntity(
          SupplierLedgerAccount? entity) =>
      entity == null
          ? null
          : (SupplierLedgerAccountModel()
            ..id = entity.id
            ..name = entity.name);

  SupplierLedgerAccount toEntity() => SupplierLedgerAccount(
        id: id,
        name: name,
      );
}
