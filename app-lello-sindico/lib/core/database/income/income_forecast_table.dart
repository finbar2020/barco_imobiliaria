
import 'package:drift/drift.dart';

@DataClassName("IncomeForecastData")
class IncomeForecastTable extends Table {

	TextColumn get condominiumId => text()();
	IntColumn get year => integer()();
	IntColumn get month => integer()();
	TextColumn get forecastPeriod => text()();
	RealColumn get forecast => real()();
	RealColumn get value => real()();

	@override
	Set<Column> get primaryKey => {condominiumId, year, month, forecastPeriod };

}