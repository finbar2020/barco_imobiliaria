import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';

abstract class CreateResinBankAccount
    extends UseCase<ResinBankAccount, CreateResinBankAccountParams> {}

class CreateResinBankAccountParams {
  final String condominiumId;
  final ResinBankAccount newAccount;

  CreateResinBankAccountParams(
      {required this.condominiumId, required this.newAccount});
}
