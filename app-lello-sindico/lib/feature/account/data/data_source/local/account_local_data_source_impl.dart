import 'package:lello/core/database/account/account_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/feature/account/data/data_source/local/account_local_data_source.dart';
import 'package:lello/feature/account/data/model/account_model.dart';
import 'package:drift/drift.dart';

class AccountLocalDataSourceImpl extends AccountLocalDataSource {
  final AccountDao dao;

  AccountLocalDataSourceImpl({required this.dao});

  @override
  Future<List<AccountModel>> list(String condominiumId) async {
    final list = await dao.list(condominiumId);
    return list
        .map((e) => AccountModel()
          ..id = e.id
          ..condominiumId = e.condominiumId
          ..number = e.number
          ..name = e.name)
        .toList();
  }

  @override
  Future<List<AccountModel>> save(
      String condominiumId, List<AccountModel> models) async {
    final dataModels = models
        .map((e) => AccountTableCompanion(
            id: Value(e.id!),
            condominiumId: Value(e.condominiumId!),
            number: Value(e.number),
            name: Value(e.name)))
        .toList();

    await dao.insert(dataModels);
    return models;
  }
}
