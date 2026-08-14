import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';

abstract class GetResinBankAccounts
    extends UseCase<List<ResinBankAccount>, GetResinBankAccountsParams> {}

class GetResinBankAccountsParams {
  final String condominiumId;
  final DataOrigin origin;

  GetResinBankAccountsParams({
    required this.condominiumId,
    required this.origin,
  });
}
