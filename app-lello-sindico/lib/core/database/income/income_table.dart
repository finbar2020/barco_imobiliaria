
import 'package:drift/drift.dart';

@DataClassName("IncomeData")
class IncomeTable extends Table {
	TextColumn get condominiumId => text()();
	RealColumn get value => real()();
	IntColumn get year => integer()();
	IntColumn get month => integer()();

	@override
	Set<Column> get primaryKey => {condominiumId, year, month};

}