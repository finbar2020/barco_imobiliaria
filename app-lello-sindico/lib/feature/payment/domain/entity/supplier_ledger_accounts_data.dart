import 'package:lello/feature/payment/domain/entity/supplier_ledger_account.dart';

class SupplierLedgerAccountsData {
  SupplierLedgerAccount? recommendation;
  List<SupplierLedgerAccount>? ordinary;
  List<SupplierLedgerAccount>? extraordinary;
  List<SupplierLedgerAccount>? all;

  SupplierLedgerAccountsData({
    this.recommendation,
    this.ordinary,
    this.extraordinary,
    this.all,
  });

  @override
  String toString() {
    return 'SupplierLedgerAccountsData(recommendation: $recommendation, ordinaryQtd: ${ordinary?.length}, extraordinary: ${extraordinary?.length}, all: ${all?.length})';
  }
}
