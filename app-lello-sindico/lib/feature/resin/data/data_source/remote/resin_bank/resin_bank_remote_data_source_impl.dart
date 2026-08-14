import 'package:essentials/essentials.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin_bank/resin_bank_api.dart';
import 'package:lello/feature/resin/data/data_source/remote/resin_bank/resin_bank_remote_data_source.dart';
import 'package:lello/feature/resin/data/model/resin_bank_account_model.dart';
import 'package:lello/feature/resin/data/model/resin_bank_model.dart';

class ResinBankRemoteDataSourceImpl extends ResinBankRemoteDataSource {
  final ResinBankApi api;
  ResinBankRemoteDataSourceImpl({required this.api});

  @override
  Future<List<ResinBankModel>> getResinBanks(String condominiumId) async {
    final response = await api.getResinBanks(condominiumId);
    final resinBanks =
        ApiMapper.mapList(response, (json) => ResinBankModel.fromJson(json));

    return resinBanks;
  }

  @override
  Future<List<ResinBankAccountModel>> getResinBankAccounts(
      String condominiumId) async {
    final response = await api.getAllBankAccounts(condominiumId);
    final resinBankAccounts = ApiMapper.mapList(
        response, (json) => ResinBankAccountModel.fromJson(json));

    return resinBankAccounts;
  }

  @override
  Future<ResinBankAccountModel> createResinBankAccount(
      String condominiumId, ResinBankAccountModel newAccount) async {
    final response = await api.createBankAccount(condominiumId, newAccount);
    final newBankAccount =
        ApiMapper.map(response, (json) => ResinBankAccountModel.fromJson(json));

    return newBankAccount;
  }

  @override
  Future<bool> deleteResinBankAccount(
      String condominiumId, String accountId) async {
    final response = await api.deleteBankAccount(condominiumId, accountId);
    if (!response.isSuccessful) {
      throw (response.error ?? "");
    }
    return true;
  }
}
