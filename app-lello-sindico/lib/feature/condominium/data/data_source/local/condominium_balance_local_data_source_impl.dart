import 'package:lello/core/database/condominium_balance/condominium_balance_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_local_data_source.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_model.dart';
import 'package:drift/drift.dart';

class CondominiumBalanceLocalDataSourceImpl
    extends CondominiumBalanceLocalDataSource {
  final CondominiumBalanceDao condominiumBalanceDao;
  CondominiumBalanceLocalDataSourceImpl({required this.condominiumBalanceDao});

  @override
  Future<CondominiumBalanceModel?> save(CondominiumBalanceModel? model) async {
    if (model == null) {
      return model;
    }

    final condominiumBalanceDataModel = CondominiumBalanceTableCompanion(
      id: Value(model.id!),
      balance: Value(model.balance!),
      date: Value(model.date!),
      previousBalance: Value(model.previousBalance!),
      forecast: Value(model.forecast!),
      income: Value(model.income!),
      expenses: Value(model.expenses!),
      reference: Value(model.reference!),
      lastUpdatedAt: Value(model.lastUpdatedAt!),
    );

    await condominiumBalanceDao.insert(condominiumBalanceDataModel);

    return model;
  }

  @override
  Future<CondominiumBalanceModel?> select(String reference) async {
    final CondominiumBalanceData? condominiumBalanceData =
        await condominiumBalanceDao.getCondominiumBalance(reference);
    if (condominiumBalanceData == null) {
      return null;
    }

    final CondominiumBalanceModel result = CondominiumBalanceModel()
      ..id = condominiumBalanceData.id
      ..balance = condominiumBalanceData.balance
      ..date = condominiumBalanceData.date
      ..previousBalance = condominiumBalanceData.previousBalance
      ..forecast = condominiumBalanceData.forecast
      ..income = condominiumBalanceData.income
      ..expenses = condominiumBalanceData.expenses
      ..reference = condominiumBalanceData.reference
      ..lastUpdatedAt = condominiumBalanceData.lastUpdatedAt;

    return result;
  }
}
