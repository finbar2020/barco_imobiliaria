import 'package:lello/core/database/income/income_forecast_table.dart';
import 'package:lello/core/database/income/income_share_table.dart';
import 'package:lello/core/database/income/income_table.dart';
import 'package:lello/core/database/lello_database.dart';

import 'package:drift/drift.dart';

part 'income_dao.g.dart';

@DriftAccessor(tables: [IncomeTable, IncomeForecastTable, IncomeShareTable])
class IncomeDao  extends DatabaseAccessor<LelloDatabase> with _$IncomeDaoMixin{
	final LelloDatabase database;
	IncomeDao(this.database) : super(database);

	Future<IncomeData> selectIncome(String condominiumId, DateTime period) => (select(database.incomeTable)
		..where((tbl) => tbl.condominiumId.equals(condominiumId) & tbl.month.equals(period.month) & tbl.year.equals(period.year))).getSingle();

	Future<List<IncomeShareData>> selectShares(String condominiumId, DateTime period) => (select(database.incomeShareTable)
		..where((tbl) => tbl.condominiumId.equals(condominiumId) & tbl.month.equals(period.month) & tbl.year.equals(period.year))).get();

	Future<List<IncomeForecastData>> selectForecast(String condominiumId, DateTime period) => (select(database.incomeForecastTable)
		..where((tbl) => tbl.condominiumId.equals(condominiumId) & tbl.month.equals(period.month) & tbl.year.equals(period.year))).get();

	Future<void> insert(Insertable<IncomeData> data) => batch((b) => b.insert(database.incomeTable, data, mode: InsertMode.replace));
	Future<void> insertShares(List<Insertable<IncomeShareData>> data) => batch((b) => b.insertAll(database.incomeShareTable, data, mode: InsertMode.replace));
	Future<void> insertForecast(List<Insertable<IncomeForecastData>> data) => batch((b) => b.insertAll(database.incomeForecastTable, data, mode: InsertMode.replace));

	Future<int> clear() {
		delete(database.incomeShareTable).go();
		delete(database.incomeForecastTable).go();
		return delete(database.accountTable).go();
	}

}