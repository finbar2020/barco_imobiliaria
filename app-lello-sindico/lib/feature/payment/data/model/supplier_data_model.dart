import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/contract_model.dart';
import 'package:lello/feature/payment/data/model/supplier_ledger_accounts_model.dart';
import 'package:lello/feature/payment/data/model/supplier_payment_type_model.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
part 'supplier_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SupplierDataModel {
  final int? id;
  final String? document;
  final String? name;
  final List<ContractModel?> contracts;
  final List<SupplierPaymentTypeModel?> supplierPaymentTypes;
  final SupplierLedgerAccountsModel? supplierLedgerAccounts;

  SupplierDataModel({
    this.id,
    this.document,
    this.name,
    this.contracts = const [],
    this.supplierPaymentTypes = const [],
    this.supplierLedgerAccounts,
  });

  factory SupplierDataModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierDataModelToJson(this);

  static SupplierDataModel? fromEntity(SupplierDataEntity? entity) {
    if (entity == null) return null;
    return SupplierDataModel(
      id: entity.id,
      document: entity.document,
      name: entity.name,
      contracts: entity.contracts
          .map((contract) => ContractModel.fromEntity(contract))
          .toList(),
      supplierPaymentTypes: entity.supplierPaymentTypes
          .map(
              (paymentType) => SupplierPaymentTypeModel.fromEntity(paymentType))
          .toList(),
      supplierLedgerAccounts: entity.supplierLedgerAccounts != null
          ? SupplierLedgerAccountsModel.fromEntity(
              entity.supplierLedgerAccounts!)
          : null,
    );
  }

  SupplierDataEntity toEntity() {
    return SupplierDataEntity(
      id: id,
      document: document,
      name: name,
      contracts: contracts.isNotEmpty
          ? contracts.map((contract) => contract!.toEntity()).toList()
          : [],
      supplierPaymentTypes: supplierPaymentTypes.isNotEmpty
          ? supplierPaymentTypes
              .map((paymentType) => paymentType!.toEntity())
              .toList()
          : [],
      supplierLedgerAccounts: supplierLedgerAccounts?.toEntity(),
    );
  }
}
