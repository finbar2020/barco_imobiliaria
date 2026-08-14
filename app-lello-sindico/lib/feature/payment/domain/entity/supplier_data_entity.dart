import 'package:lello/feature/payment/domain/entity/contract.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/entity/supplier_payment_type.dart';

class SupplierDataEntity {
  final int? id;
  final String? document;
  final String? name;
  final List<ContractEntity?> contracts;
  final List<SupplierPaymentTypeEntity?> supplierPaymentTypes;
  final SupplierLedgerAccountsEntity? supplierLedgerAccounts;

  SupplierDataEntity({
    this.id,
    this.document,
    this.name,
    this.contracts = const [],
    this.supplierPaymentTypes = const [],
    this.supplierLedgerAccounts,
  });

  SupplierDataEntity copyWith({
    int? id,
    String? document,
    String? name,
    List<ContractEntity>? contracts,
    List<SupplierPaymentTypeEntity>? supplierPaymentTypes,
    SupplierLedgerAccountsEntity? supplierLedgerAccounts,
  }) {
    return SupplierDataEntity(
      id: id ?? this.id,
      document: document ?? this.document,
      name: name ?? this.name,
      contracts: contracts ?? this.contracts,
      supplierPaymentTypes: supplierPaymentTypes ?? this.supplierPaymentTypes,
      supplierLedgerAccounts:
          supplierLedgerAccounts ?? this.supplierLedgerAccounts,
    );
  }
}
