import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_api.dart';
import 'package:lello/feature/payment/data/data_source/payment/payment_ledger_account_balance_datasource.dart';
import 'package:lello/feature/payment/data/model/ledger_account_balance_model.dart';

class PaymentLedgerAccountBalanceDatasourceImpl
    extends PaymentLedgerAccountBalanceDataSource {
  final PaymentApi api;

  PaymentLedgerAccountBalanceDatasourceImpl(this.api);

  @override
  Future<LedgerAccountBalanceModel> getLedgerAccountBalance(
      String condoId, String accountId) async {
    final response = await api.getLedgerAccountBalance(condoId, accountId);
    return ApiMapper.map(
      response,
      (json) => LedgerAccountBalanceModel.fromJson(json),
    );
  }
}
