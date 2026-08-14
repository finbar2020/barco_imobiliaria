
import 'package:drift/drift.dart';

@DataClassName("IncomeShareData")
class IncomeShareTable extends Table {
	TextColumn get condominiumId => text()();
	IntColumn get year => integer()();
	IntColumn get month => integer()();
	TextColumn get title => text()();
	IntColumn get total => integer()();
	RealColumn get share => real()();
	TextColumn get color => text()();

	@override
	Set<Column> get primaryKey => {condominiumId, year, month, title};

}