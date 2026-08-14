import 'package:lello/core/database/condominium_balance_detail/condominium_balance_debits_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_detail_dao.dart';
import 'package:lello/core/database/condominium_balance_detail/condominium_balance_summary_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/feature/condominium/data/data_source/local/condominium_balance_detail_local_data_source.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_detail_debits_model.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_detail_model.dart';
import 'package:lello/feature/condominium/data/model/condominium_balance_detail_summary_model.dart';
import 'package:drift/drift.dart';

class CondominiumBalanceDetailLocalDataSourceImpl
    extends CondominiumBalanceDetailLocalDataSource {
  final CondominiumBalanceDetailDao condominiumBalanceDetailDao;
  final CondominiumBalanceDebitsDao condominiumBalanceDebitsDao;
  final CondominiumBalanceSummaryDao condominiumBalanceSummaryDao;
  CondominiumBalanceDetailLocalDataSourceImpl({
    required this.condominiumBalanceDetailDao,
    required this.condominiumBalanceDebitsDao,
    required this.condominiumBalanceSummaryDao,
  });

  @override
  Future<CondominiumBalanceDetailModel?> save(
      CondominiumBalanceDetailModel? model) async {
    if (model == null) {
      return model;
    }

    final condominiumBalanceDetailDataModel =
        CondominiumBalanceDetailTableCompanion(
      reference: Value(model.reference!),
      previousBalance: Value(model.previousBalance!),
      balance: Value(model.balance!),
      accountBalance: Value(model.accountBalance!),
      debit: Value(model.debit!),
      credits: Value(model.credits!),
      lastUpdatedAt: Value(model.lastUpdatedAt!),
    );

    final condominiumBalanceDebitsDataModel = model.debits
        ?.map((e) => CondominiumBalanceDebitsTableCompanion(
              reference: Value(model.reference ?? ""),
              id: Value(e.id ?? ""),
              name: Value(e.name),
              type: Value(e.type),
              previousBalance: Value(e.previousBalance),
              balance: Value(e.balance),
              accountBalance: Value(e.accountBalance),
              debit: Value(e.debit),
              credits: Value(e.credits),
              period: Value(e.period),
            ))
        .toList();

    final condominiumBalanceSummaryDataModel = model.summary
        ?.map((e) => CondominiumBalanceSummaryTableCompanion(
              reference: Value(model.reference!),
              name: Value(e.name),
              debits: Value(e.debits),
              credits: Value(e.credits),
            ))
        .toList();

    await condominiumBalanceDetailDao
        .deleteCondominiumBalanceDetail(model.reference!);
    await condominiumBalanceDebitsDao
        .deleteCondominiumBalanceDebits(model.reference!);
    await condominiumBalanceSummaryDao
        .deleteCondominiumBalanceSummary(model.reference!);

    await condominiumBalanceDetailDao.insert(condominiumBalanceDetailDataModel);
    await condominiumBalanceDebitsDao
        .insert(condominiumBalanceDebitsDataModel!);
    await condominiumBalanceSummaryDao
        .insert(condominiumBalanceSummaryDataModel!);

    return model;
  }

  @override
  Future<CondominiumBalanceDetailModel?> select(String reference) async {
    final CondominiumBalanceDetailData? condominiumBalanceDetailData =
        await condominiumBalanceDetailDao
            .getCondominiumBalanceDetail(reference);
    if (condominiumBalanceDetailData == null) {
      return null;
    }
    final condominiumBalanceDebitsData = await condominiumBalanceDebitsDao
        .getCondominiumBalanceDebits(reference);
    final condominiumBalanceSummaryData = await condominiumBalanceSummaryDao
        .getCondominiumBalanceSummary(reference);

    final List<DebitsModel> debitsModelList = condominiumBalanceDebitsData
        .map((e) => DebitsModel()
          ..id = e.id
          ..name = e.name
          ..type = e.type
          ..previousBalance = e.previousBalance
          ..balance = e.balance
          ..accountBalance = e.accountBalance
          ..debit = e.debit
          ..credits = e.credits
          ..period = e.period)
        .toList();

    final List<SummaryModel> summaryModelList = condominiumBalanceSummaryData
        .map((e) => SummaryModel()
          ..name = e.name
          ..debits = e.debits
          ..credits = e.credits)
        .toList();

    final CondominiumBalanceDetailModel result = CondominiumBalanceDetailModel()
      ..previousBalance = condominiumBalanceDetailData.previousBalance
      ..balance = condominiumBalanceDetailData.balance
      ..accountBalance = condominiumBalanceDetailData.accountBalance
      ..debit = condominiumBalanceDetailData.debit
      ..credits = condominiumBalanceDetailData.credits
      ..debits = debitsModelList
      ..summary = summaryModelList
      ..reference = condominiumBalanceDetailData.reference
      ..lastUpdatedAt = condominiumBalanceDetailData.lastUpdatedAt;

    return result;
  }
}
