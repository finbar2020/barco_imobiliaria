import 'package:lello/feature/resin/data/model/resin_bank_account_model.dart';
import 'package:lello/feature/resin/data/model/resin_bank_model.dart';
import 'package:lello/feature/resin/data/model/resin_person_model.dart';
import 'package:lello/feature/resin/data/model/resin_refund_model.dart';

abstract class ResinLocalDataSource {
  Future<List<ResinPersonModel>> selectAllPeople(String condominiumId);
  Future<void> saveAllPeople(
      String condominiumId, List<ResinPersonModel> people);

  Future<List<ResinBankModel>> selectAllBanks(String condominiumId);
  Future<void> saveSingleBank(String condominiumId, ResinBankModel bank);
  Future<void> saveAllBanks(String condominiumId, List<ResinBankModel> banks);

  Future<List<ResinBankAccountModel>> selectAllBankAccounts(
      String condominiumId);
  Future<void> saveBankAccounts(
      String condominiumId, List<ResinBankAccountModel> bankAccounts);
  Future<void> saveSingleBankAccount(
      String condominiumId, ResinBankAccountModel bankAccount);
  Future<void> deleteBankAccounts(String accountId);

  Future<List<ResinRefundModel>> selectAllRefunds(String condominiumId);
  Future<void> saveAllRefunds(
      String condominiumId, List<ResinRefundModel> refunds);
  Future<void> saveSingleRefund(String condominiumId, ResinRefundModel refund);
}
