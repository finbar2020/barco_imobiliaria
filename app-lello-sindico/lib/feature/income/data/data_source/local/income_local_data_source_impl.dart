import 'package:lello/core/database/income/income_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/feature/income/data/model/income_forecast_model.dart';
import 'package:lello/feature/income/data/model/income_model.dart';
import 'package:lello/feature/income/data/model/income_share_model.dart';
import 'package:drift/drift.dart';

import 'income_local_data_source.dart';

class IncomeLocalDataSourceImpl extends IncomeLocalDataSource {
  final IncomeDao dao;

  IncomeLocalDataSourceImpl({required this.dao});

  @override
  Future<IncomeModel> save(
      String condominiumId, DateTime period, IncomeModel model) async {
    final dataModel = IncomeTableCompanion(
      condominiumId: Value(condominiumId),
      value: Value(model.value!),
      year: Value(period.year),
      month: Value(period.month),
    );

    final shares = model.shares!
        .map((e) => IncomeShareTableCompanion(
              condominiumId: Value(condominiumId),
              year: Value(period.year),
              month: Value(period.month),
              title: Value(e!.title!),
              total: Value(e.total!),
              share: Value(e.share!),
              color: Value(e.color!),
            ))
        .toList();

    final forecasts = model.forecast!
        .map((e) => IncomeForecastTableCompanion(
              condominiumId: Value(condominiumId),
              year: Value(period.year),
              month: Value(period.month),
              forecastPeriod: Value(e!.period!),
              forecast: Value(e.forecast!),
              value: Value(e.value!),
            ))
        .toList();

    final insertions = [
      dao.insert(dataModel),
      dao.insertShares(shares),
      dao.insertForecast(forecasts)
    ];
    await Future.wait(insertions);
    return model;
  }

  @override
  Future<IncomeModel?> select(String condominiumId, DateTime period) async {
    final data = await Future.wait([
      dao.selectIncome(condominiumId, period),
      dao.selectForecast(condominiumId, period),
      dao.selectShares(condominiumId, period)
    ]);
    final income = data[0];
    if (income is IncomeData) {
      IncomeModel model = IncomeModel(
        period: "${income.year}-${income.month}",
        value: income.value,
        shares: [],
        forecast: [],
      );

      final shares = data[1];
      if (shares is List<IncomeShareData>) {
        model = model.copyWith(
          shares: shares
              .map(
                (e) => IncomeShareModel(
                  title: e.title,
                  total: e.total,
                  share: e.share,
                  color: e.color,
                ),
              )
              .toList(),
        );
      }

      final forecasts = data[2];
      if (forecasts is List<IncomeForecastData>) {
        model = model.copyWith(
          forecast: forecasts
              .map(
                (e) => IncomeForecastModel(
                  period: "${e.year}-${e.month}",
                  forecast: e.forecast,
                  value: e.value,
                ),
              )
              .toList(),
        );
      }
      return model;
    }
    return null;
  }
}
