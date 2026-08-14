import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/supplier_ledger_account_model.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts_data.dart';

part 'supplier_ledger_accounts_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierLedgerAccountsDataModel {
  SupplierLedgerAccountModel? recommendation;
  List<SupplierLedgerAccountModel>? ordinary;
  List<SupplierLedgerAccountModel>? extraordinary;
  List<SupplierLedgerAccountModel>? all;

  SupplierLedgerAccountsDataModel();

  factory SupplierLedgerAccountsDataModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierLedgerAccountsDataModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SupplierLedgerAccountsDataModelToJson(this);

  static SupplierLedgerAccountsDataModel? fromEntity(
          SupplierLedgerAccountsData? entity) =>
      entity == null
          ? null
          : (SupplierLedgerAccountsDataModel()
            ..recommendation =
                SupplierLedgerAccountModel.fromEntity(entity.recommendation)
            ..ordinary = entity.ordinary
                ?.map(SupplierLedgerAccountModel.fromEntity)
                .where((e) => e != null)
                .map((e) => e!)
                .toList()
            ..extraordinary = entity.extraordinary
                ?.map(SupplierLedgerAccountModel.fromEntity)
                .where((e) => e != null)
                .map((e) => e!)
                .toList()
            ..all = entity.all
                ?.map(SupplierLedgerAccountModel.fromEntity)
                .where((e) => e != null)
                .map((e) => e!)
                .toList());

  SupplierLedgerAccountsData toEntity() => SupplierLedgerAccountsData(
        recommendation: recommendation?.toEntity(),
        ordinary: ordinary?.map((e) => e.toEntity()).toList(),
        extraordinary: extraordinary?.map((e) => e.toEntity()).toList(),
        all: all?.map((e) => e.toEntity()).toList(),
      );
}
