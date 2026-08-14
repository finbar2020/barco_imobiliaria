import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';

abstract class GetLedgerAccounts
    extends UseCase<SupplierLedgerAccountsEntity?, GetLedgerAccountsParam> {}

class GetLedgerAccountsParam {
  final String condominiumId;
  final String supplierId;

  GetLedgerAccountsParam({
    required this.condominiumId,
    required this.supplierId,
  });
}
