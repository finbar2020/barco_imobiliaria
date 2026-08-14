import 'package:lello/feature/resin/data/model/resin_bank_account_model.dart';
import 'package:lello/feature/resin/data/model/resin_bank_model.dart';

abstract class ResinBankRemoteDataSource {
  Future<List<ResinBankModel>> getResinBanks(String condominiumId);
  Future<List<ResinBankAccountModel>> getResinBankAccounts(
      String condominiumId);
  Future<ResinBankAccountModel> createResinBankAccount(
      String condominiumId, ResinBankAccountModel newAccount);
  Future<bool> deleteResinBankAccount(String condominiumId, String accountId);
}
