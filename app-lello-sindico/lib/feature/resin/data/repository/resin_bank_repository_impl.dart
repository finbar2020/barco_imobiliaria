import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/data/data_source/local/resin_local_data_source.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin_bank/resin_bank_remote_data_source.dart';
import 'package:lello/feature/resin/data/model/resin_bank_account_model.dart';
import 'package:lello/feature/resin/data/model/resin_bank_model.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/repository/resin_bank_repository.dart';

class ResinBankRepositoryImpl extends ResinBankRepository {
  final ResinBankRemoteDataSource remoteDataSource;
  final ResinLocalDataSource localDataSource;

  ResinBankRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Try<List<ResinBank>>> getResinBanks(String condominiumId) async {
    try {
      final List<ResinBankModel> result =
          await remoteDataSource.getResinBanks(condominiumId);

      localDataSource.saveAllBanks(condominiumId, result);

      final List<ResinBank> banks =
          result.map((e) => e.toEntity()).whereType<ResinBank>().toList();
      return Success(banks);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<ResinBankAccount>>> getResinBankAccounts(
      String condominiumId) async {
    try {
      final List<ResinBankAccountModel> result =
          await remoteDataSource.getResinBankAccounts(condominiumId);

      localDataSource.saveBankAccounts(condominiumId, result);
      result.forEach((account) {
        if (account.bank != null) {
          localDataSource.saveSingleBank(condominiumId, account.bank!);
        }
      });

      result.sort((a, b) => a.supplierName.compareTo(b.supplierName));

      final List<ResinBankAccount> accounts = result
          .map((e) => e.toEntity())
          .whereType<ResinBankAccount>()
          .toList();
      return Success(accounts);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<bool>> deleteResinBankAccount(
      String condominiumId, String accountId) async {
    try {
      final bool result = await remoteDataSource.deleteResinBankAccount(
          condominiumId, accountId);

      localDataSource.deleteBankAccounts(accountId);

      return Success(result);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<ResinBankAccount>> createResinBankAccount(
      String condominiumId, ResinBankAccount newAccount) async {
    try {
      ResinBankAccountModel newAccountModel =
          ResinBankAccountModel.fromEntity(newAccount)!;
      final ResinBankAccountModel result = await remoteDataSource
          .createResinBankAccount(condominiumId, newAccountModel);
      final ResinBankAccount resultEntity = result.toEntity()!;

      localDataSource.saveSingleBankAccount(condominiumId, result);

      return Success(resultEntity);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<ResinBank>>> getResinBanksFromCache(
      String condominiumId) async {
    try {
      final List<ResinBankModel> result =
          await localDataSource.selectAllBanks(condominiumId);

      final List<ResinBank> banks =
          result.map((e) => e.toEntity()).whereType<ResinBank>().toList();
      return Success(banks);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }

  @override
  Future<Try<List<ResinBankAccount>>> getResinBankAccountsFromCache(
      String condominiumId) async {
    try {
      final List<ResinBankAccountModel> result =
          await localDataSource.selectAllBankAccounts(condominiumId);

      result.sort((a, b) => a.supplierName.compareTo(b.supplierName));

      final List<ResinBankAccount> accounts = result
          .map((e) => e.toEntity())
          .whereType<ResinBankAccount>()
          .toList();
      return Success(accounts);
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
