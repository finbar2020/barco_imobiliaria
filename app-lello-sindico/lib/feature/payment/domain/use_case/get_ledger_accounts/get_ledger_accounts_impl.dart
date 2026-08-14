import 'package:essentials/essentials.dart';
import 'package:essentials/functional/try.dart';
import 'package:lello/feature/payment/domain/entity/supplier_ledger_accounts.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_ledger_accounts/get_ledger_accounts.dart';

class GetLedgerAccountsImpl extends GetLedgerAccounts {
  final PaymentRepository repository;

  GetLedgerAccountsImpl({required this.repository});

  @override
  Future<Try<SupplierLedgerAccountsEntity?>> call(
      GetLedgerAccountsParam params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return await repository.findLedgerAccounts(
        params.condominiumId, params.supplierId);
  }

  Failure? _validate(GetLedgerAccountsParam? param) {
    if (param == null) return InvalidParamFailure();
    if (param.supplierId.isEmpty) return InvalidParamFailure();
    if (param.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
