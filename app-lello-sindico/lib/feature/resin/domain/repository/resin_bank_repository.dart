import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';

abstract class ResinBankRepository {
  Future<Try<List<ResinBankAccount>>> getResinBankAccounts(
      String condominiumId);

  Future<Try<List<ResinBank>>> getResinBanks(String condominiumId);

  Future<Try<ResinBankAccount>> createResinBankAccount(
      String condominiumId, ResinBankAccount newAccount);

  Future<Try<bool>> deleteResinBankAccount(
      String condominiumId, String accountId);

  Future<Try<List<ResinBankAccount>>> getResinBankAccountsFromCache(
      String condominiumId);

  Future<Try<List<ResinBank>>> getResinBanksFromCache(String condominiumId);
}
