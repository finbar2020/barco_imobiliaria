
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'unit_dao.g.dart';

@DriftAccessor(tables: [UnitData])
class UnitDao extends DatabaseAccessor<LelloDatabase> with _$UnitDaoMixin {
	final LelloDatabase database;
	UnitDao(this.database) : super(database);

	Future<List<UnitData>> listUnits(String condominiumId) => (
		select(database.unitTable)
			..where((dt) => dt.condominiumId.equals(condominiumId))
	).get();

	Future<int> deleteUnits(String condominiumId) => (
		delete(database.unitTable)
			..where((dt) => dt.condominiumId.equals(condominiumId))
	).go();


	Future<void> insertUnits(List<Insertable<UnitData>> data) => batch((b) => b.insertAll(database.unitTable, data, mode: InsertMode.replace));

	Future<int> clearUnits() => delete(database.unitTable).go();
}
